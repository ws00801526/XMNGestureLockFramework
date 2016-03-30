//
//  XMNGestureLockItemView.h
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMNGestureLockConst.h"

typedef NS_ENUM(NSUInteger, XMNGestureLockItemViewState) {
    XMNGestureLockItemViewStateNormal,
    XMNGestureLockItemViewStateSelected,
    XMNGestureLockItemViewStateError,
};

@interface XMNGestureLockItemView : UIView

@property (nonatomic, assign) XMNGestureLockItemViewState state;
@property (nonatomic, assign) XMNGestureLockDirection direction;
@property (nonatomic, assign) CGFloat angle;

@end
