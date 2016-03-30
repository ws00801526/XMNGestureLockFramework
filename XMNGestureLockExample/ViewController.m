//
//  ViewController.m
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "ViewController.h"
#import "XMNGestureLockController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createGestureLock:(UIButton *)sender {
    
    XMNGestureLockController *lockC = [[XMNGestureLockController alloc] initWithType:XMNGestureLockCreate];
    [lockC setGenerateLockBlock:^(BOOL success, NSString * _Nullable password) {
        NSLog(@"gerenate lock success %d :%@",success,password);
        success?[self dismissViewControllerAnimated:YES completion:nil] : nil;
    }];
    [self presentViewController:lockC animated:YES completion:nil];
}
- (IBAction)verifyGestureLock:(UIButton *)sender {
    
    
    XMNGestureLockController *lockC = [[XMNGestureLockController alloc] initWithType:XMNGestureLockVerify];
    [lockC setVerifyLockBlock:^(BOOL success) {
        NSLog(@"verify lock success :%d",success);
        success?[self dismissViewControllerAnimated:YES completion:nil] : nil;
    }];
    [self presentViewController:lockC animated:YES completion:nil];
    
    
}
- (IBAction)updateGestureLock:(UIButton *)sender {
    
    
    XMNGestureLockController *lockC = [[XMNGestureLockController alloc] initWithType:XMNGestureLockModify];
    [lockC setModifyLockBlock:^(BOOL success, NSString * _Nullable password) {
        NSLog(@"update lock success :%d  %@",success,password);
        success?[self dismissViewControllerAnimated:YES completion:nil] : nil;
    }];
    
    [self presentViewController:lockC animated:YES completion:nil];
}

@end
