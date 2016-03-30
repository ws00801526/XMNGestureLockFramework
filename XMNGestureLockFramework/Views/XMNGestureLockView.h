//
//  XMNGestureLockView.h
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMNGestureLockView : UIView

@property (nonatomic, copy, nullable)   BOOL(^gestureLockFinished)(NSString  * _Nullable  password);

@end
