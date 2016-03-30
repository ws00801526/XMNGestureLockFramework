//
//  XMNGestureLockInternalController.m
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNGestureLockInternalController.h"
#import "XMNGestureLockController.h"

#import "XMNGestureLockView.h"
#import "XMNGestureLockInfoView.h"

#import "CALayer+XMNShakeAnim.h"

/**
 *  内部实现的GestureLockController
 */
@interface XMNGestureLockInternalController()

@property (nonatomic, assign) XMNGestureLockType type;

@property (nonatomic, copy)   NSString *password;

/** 确认密码 */
@property (nonatomic, copy)   NSString *confirmPassword;

/** 验证成功, 修改密码时使用 */
@property (nonatomic, assign) BOOL verifySuccess;

@property (nonatomic, weak, readonly)   XMNGestureLockController *rootController;

@property (nonatomic, copy)   NSString *savedPassword;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet XMNGestureLockView *lockView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHConstraint;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet XMNGestureLockInfoView *lockInfoView;

/** 输入的错误次数 */
@property (nonatomic, assign) NSUInteger entryErrorCount;

@end

/** 错误类型 */
typedef NS_ENUM(NSUInteger, XMNGestureLockErrorType) {
    /** 无错误 */
    XMNGestureLockNoError,
    /** 长度不足 */
    XMNGestureLockPasswordLenghtNotEnoughError,
    /** 两次输入的密码不一致 */
    XMNGestureLockPasswordNotVerifyLastTime,
    /** 与保存的密码验证不通过 */
    XMNGestureLockPasswordNotVerifySaved,
};

@implementation XMNGestureLockInternalController

- (instancetype)initWithType:(XMNGestureLockType)type {
    
    if (self = [super initWithNibName:@"XMNGestureLockInternalController" bundle:[NSBundle bundleWithIdentifier:@"com.XMFraker.XMNGestureLockFramework"]]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _setup];
}

- (void)dealloc {
    
    [self.lockView setGestureLockFinished:nil];
    NSLog(@"%@ : dealloc",NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.topViewTConstraint.constant = self.navigationController.navigationBar.isTranslucent ? 64 : 0;
}

#pragma mark - Methods

- (void)_setup {
    
    self.navigationItem.title = self.title;
    self.view.backgroundColor = kXMNGestureLockBackgroundColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_handleCancelAction)];
    
    self.tipsLabel.highlightedTextColor = kXMNGestureLockErrorColor;
    self.tipsLabel.textColor = [UIColor lightTextColor];
    [self _updateTipsLabelWithErrorType:XMNGestureLockNoError];
    switch (self.type) {
        case XMNGestureLockCreate:
            self.tipsLabel.text = @"绘制解锁图案";
            break;
        case XMNGestureLockModify:
        case XMNGestureLockVerify:
        default:
            self.tipsLabel.text = @"请输入原手势密码";
            break;
    }
    
    self.lockInfoView.hidden = self.type != XMNGestureLockCreate;
    
    __weak typeof(*&self) wSelf = self;
    [self.lockView setGestureLockFinished:^(NSString *password) {
        __strong typeof(*&self) self = wSelf;
        switch (self.type) {
            case XMNGestureLockCreate:
                [self _handleGenerateLock:password];
                break;
            case XMNGestureLockModify:
                [self _handleModifyLock:password];
                break;
            case XMNGestureLockVerify:
                [self _handleVerifyLock:password];
                break;
            default:
                break;
        }
        return NO;
    }];
}

- (void)_handleCancelAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_handleGenerateLock:(NSString *)password {
    
    if (!self.password) {
        if (password.length < kXMNGestureLockMinItemCount) {
            [self _updateTipsLabelWithErrorType:XMNGestureLockPasswordLenghtNotEnoughError];
            return;
        }
        self.password = [password copy];
        self.tipsLabel.text = @"再次绘制解锁图案";
        return;
    }
    if ([self.password isEqualToString:password]) {
        self.savedPassword = password;
        self.rootController.generateLockBlock ? self.rootController.generateLockBlock(YES, password) : nil;
    }else {
        [self _updateTipsLabelWithErrorType:XMNGestureLockPasswordNotVerifyLastTime];
        self.entryErrorCount ++ ;
    }
}

- (void)_handleModifyLock:(NSString *)password {
    
    if (password.length < kXMNGestureLockMinItemCount) {
        [self _updateTipsLabelWithErrorType:XMNGestureLockPasswordLenghtNotEnoughError];
        return;
    }
    if (!self.verifySuccess) {
        self.verifySuccess = [self.savedPassword isEqualToString:password];
        if (self.verifySuccess) {
            self.lockInfoView.hidden = NO;
        }else {
            [self _updateTipsLabelWithErrorType:XMNGestureLockPasswordNotVerifySaved];
        }
        return;
    }
    if (!self.password) {
        self.password = [password copy];
        self.tipsLabel.text = @"再次绘制解锁图案";
        return;
    }
    if ([self.password isEqualToString:password]) {
        self.savedPassword = password;
        self.rootController.modifyLockBlock ? self.rootController.modifyLockBlock(YES, password) : nil;
    }else {
        [self _updateTipsLabelWithErrorType:XMNGestureLockPasswordNotVerifyLastTime];
        self.entryErrorCount ++ ;
    }
}

- (void)_handleVerifyLock:(NSString *)password {
    
    if (password.length < kXMNGestureLockMinItemCount) {
        [self _updateTipsLabelWithErrorType:XMNGestureLockPasswordLenghtNotEnoughError];
        return;
    }
    if ([self.savedPassword isEqualToString:password]) {
        self.rootController.verifyLockBlock ? self.rootController.verifyLockBlock(YES) : nil;
    }else {
        [self _updateTipsLabelWithErrorType:XMNGestureLockPasswordNotVerifySaved];
    }
}

- (void)_handleResetLock:(UIBarButtonItem *)item {
    
    self.entryErrorCount = 0;
    self.password = nil;
}

- (void)_updateTipsLabelWithErrorType:(XMNGestureLockErrorType)errorType {
    self.tipsLabel.highlighted = YES;
    switch (errorType) {
        case XMNGestureLockPasswordNotVerifySaved:
            self.tipsLabel.text = @"密码错误";
            [self.tipsLabel.layer shake];
            break;
        case XMNGestureLockPasswordNotVerifyLastTime:
            self.tipsLabel.text = @"与上次绘制不一致,请重新绘制";
            [self.tipsLabel.layer shake];
            break;
        case XMNGestureLockPasswordLenghtNotEnoughError:
            self.tipsLabel.text = [NSString stringWithFormat:@"至少连接%d个点,请重新绘制",(int)kXMNGestureLockMinItemCount];
            [self.tipsLabel.layer shake];
            break;
        case XMNGestureLockNoError:
            self.tipsLabel.highlighted = NO;
            self.tipsLabel.text = @"绘制解锁图案";
        default:
            break;
    }
}

#pragma mark - Setters

- (void)setSavedPassword:(NSString *)password {
    
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kXMNGestureLockPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setEntryErrorCount:(NSUInteger)entryErrorCount {
    _entryErrorCount = entryErrorCount;
    if (self.type == XMNGestureLockCreate && entryErrorCount >= 2) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(_handleResetLock:)];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}



#pragma mark - Setters

- (void)setPassword:(NSString *)password {
    
    _password = [password copy];
    [self.lockInfoView drawWithPassword:password];
}


#pragma mark - Getters

- (XMNGestureLockController *)rootController {
    
    return (XMNGestureLockController *)[super navigationController];
}


- (NSString *)savedPassword {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kXMNGestureLockPasswordKey];
}

- (BOOL)hasPassword {
    
    return self.savedPassword != nil;
}

- (NSString *)title {
    switch (self.type) {
        case XMNGestureLockCreate:
            return @"设置手势";
            break;
        case XMNGestureLockVerify:
            return @"验证手势";
        case XMNGestureLockModify:
            return @"修改手势";
        default:
            return @"";
    }
}

@end

