//
//  XMNGestureLockController.h
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMNGestureLockConst.h"

@interface XMNGestureLockController : UINavigationController

@property (nonatomic, assign, readonly) BOOL hasPassword;
@property (nonatomic, copy, readonly, nullable)   NSString *savedPassword;


/** 创建手势密码的回调block */
@property (nonatomic, copy, nullable)   void(^generateLockBlock)(BOOL success, NSString * _Nullable password);

/** 修改手势密码的回调block */
@property (nonatomic, copy, nullable)   void(^modifyLockBlock)(BOOL success,NSString * _Nullable password);

/** 验证手势密码的回调block */
@property (nonatomic, copy, nullable)   void(^verifyLockBlock)(BOOL success);

/** 点击忘记密码的回调block */
@property (nonatomic, copy, nullable)   void(^forgetPasswordBlock)();

- (_Nullable instancetype)initWithType:(XMNGestureLockType)type;

@end

