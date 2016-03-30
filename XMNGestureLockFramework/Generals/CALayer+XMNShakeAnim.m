//
//  CALayer+XMNShakeAnim.m
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "CALayer+XMNShakeAnim.h"

@implementation CALayer (XMNShakeAnim)


- (void)shake {
    CAKeyframeAnimation *keyFrameAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    //shake幅度
    CGFloat s = 16;
    
    //关键帧
    keyFrameAnim.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    //时长
    keyFrameAnim.duration = .1f;
    //重复
    keyFrameAnim.repeatCount = 2;
    
    //移除
    keyFrameAnim.removedOnCompletion = YES;
    [self addAnimation:keyFrameAnim forKey:@"shake"];

}

@end
