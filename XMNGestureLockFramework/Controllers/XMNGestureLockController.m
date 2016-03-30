//
//  XMNGestureLockController.m
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNGestureLockController.h"
#import "XMNGestureLockInternalController.h"

@implementation XMNGestureLockController

#pragma mark - Life Cycle

- (instancetype)initWithType:(XMNGestureLockType)type {
    [[self class] _setup];
    XMNGestureLockInternalController *gestureLockInternalC = [[XMNGestureLockInternalController alloc] initWithType:type];
    if (self = [super initWithRootViewController:gestureLockInternalC]) {

    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

#pragma mark - Methods

+ (void)_setup {
    
    //配置navigationbar的显示
#ifdef kXMNGestureLockCustomizeNavigationBar
    [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XMNGestureLockController class]]] setTranslucent:YES];
    [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XMNGestureLockController class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName:kXMNGestureLockCustomizeNavigationBarTitleColor,NSFontAttributeName:kXMNGestureLockCustomizeNavigationBarTitleFont}];
    [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XMNGestureLockController class]]] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XMNGestureLockController class]]].tintColor = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XMNGestureLockController class]]].barTintColor = kXMNGestureLockCustomizeNavigationBarTintColor;
#endif
}

@end


