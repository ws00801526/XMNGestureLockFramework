//
//  XMNGestureLockInfoView.m
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/30.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNGestureLockInfoView.h"

#import "XMNGestureLockConst.h"

@interface XMNGestureLockInfoView ()

@property (nonatomic, copy)   NSArray *drawArray;

@end

@implementation XMNGestureLockInfoView


#pragma mark - Life Cycle

- (void)drawRect:(CGRect)rect {
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置属性
    CGContextSetLineWidth(ctx, kXMNGestureLockLineWidth);
    
    //新建路径
    CGMutablePathRef pathM =CGPathCreateMutable();
    
    CGFloat marginV = 3.f;
    CGFloat padding = 1.0f;
    CGFloat rectWH = (rect.size.width - marginV * 2 - padding*2) / 3;
    
    CGContextSetFillColorWithColor(ctx, kXMNGestureLockSelectedColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, kXMNGestureLockNormalColor.CGColor);
    //添加圆形路径
    for (NSUInteger i=0; i<9; i++) {
        
        NSUInteger row = i % 3;
        NSUInteger col = i / 3;
        
        CGFloat rectX = (rectWH + marginV) * row + padding;
        
        CGFloat rectY = (rectWH + marginV) * col + padding;
        
        CGRect rect = CGRectMake(rectX, rectY, rectWH, rectWH);
        
        
        if ([self.drawArray containsObject:[NSString stringWithFormat:@"%d",(int)i]]) {
            CGContextFillEllipseInRect(ctx, rect);
        }else {
            CGPathAddEllipseInRect(pathM, NULL, rect);
        }
    }
    
    //添加路径
    CGContextAddPath(ctx, pathM);
    
    //绘制路径
    CGContextStrokePath(ctx);
    
    
    //释放路径
    CGPathRelease(pathM);
}


#pragma mark - Methods

- (void)drawWithPassword:(NSString *)password {
    
    self.drawArray = [password componentsSeparatedByString:@","];
    [self setNeedsDisplay];
}


@end
