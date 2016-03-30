//
//  XMNGestureLockConst.h
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __OBJC__


#define XMNRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/// ========================================
/// @name   导航栏相关定义
/// ========================================

/** 是否使用自定义导航类 */
#define kXMNGestureLockCustomizeNavigationBar 1

/** 自定义导航栏tintColor barTintColor 当 kXMNGestureLockCustomizeNavigationBar = 1时起效 */
#define kXMNGestureLockCustomizeNavigationBarTintColor [UIColor whiteColor]

/** 自定义导航栏title Font 当 kXMNGestureLockCustomizeNavigationBar = 1时起效 */
#define kXMNGestureLockCustomizeNavigationBarTitleFont [UIFont systemFontOfSize:20]

/** 自定义导航栏titleColor 当 kXMNGestureLockCustomizeNavigationBar = 1时起效 */
#define kXMNGestureLockCustomizeNavigationBarTitleColor [UIColor whiteColor]

/** 自定义背景色 */
#define kXMNGestureLockBackgroundColor XMNRGBA(13,52,89,1)

/** 未选中时颜色 */
#define kXMNGestureLockNormalColor XMNRGBA(241,241,241,1)

/** 选中时颜色 */
#define kXMNGestureLockSelectedColor XMNRGBA(34,178,246,1)

/** 输入错误时显示的颜色 */
#define kXMNGestureLockErrorColor XMNRGBA(255,0,0,1)

/// ========================================
/// @name   enum 定义
/// ========================================

/** XMNGestureLock类型 */
typedef NS_ENUM(NSUInteger, XMNGestureLockType) {
    /** 创建lock手势 */
    XMNGestureLockCreate,
    /** 验证lock手势 */
    XMNGestureLockVerify,
    /** 修改lock手势 */
    XMNGestureLockModify,
};

/** 手势方向 */
typedef NS_ENUM(NSUInteger, XMNGestureLockDirection) {
    /** 未知方向手势 */
    XMNGestureLockDirectionUnknown = 0,
    /** 向上手势 */
    XMNGestureLockDirectionTop,
    /** 右上手势 */
    XMNGestureLockDirectionTopRight,
    /** 右手势 */
    XMNGestureLockDirectionRight,
    /** 右下手势 */
    XMNGestureLockDirectionBottomRight,
    /** 下手势 */
    XMNGestureLockDirectionBottom,
    /** 左下手势 */
    XMNGestureLockDirectionBottomLeft,
    /** 左手势 */
    XMNGestureLockDirectionLeft,
    /** 左上手势 */
    XMNGestureLockDirectionTopLeft,
};


/// ========================================
/// @name   Extension
/// ========================================

FOUNDATION_EXTERN CGFloat const kXMNGestureLockLineWidth;
FOUNDATION_EXTERN CGFloat const kXMNGestureLockInnerRoundRadio;
FOUNDATION_EXTERN CGFloat const kXMNGestureLockMinItemCount;

UIKIT_EXTERN NSString * const kXMNGestureLockPasswordKey;

#endif