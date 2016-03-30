//
//  XMNGestureLockItemView.m
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNGestureLockItemView.h"


@interface XMNGestureLockItemView ()

@property (nonatomic, assign) CGRect outerRect;
@property (nonatomic, assign) CGRect innerRect;

@property (nonatomic, strong, readonly) UIColor *drawColor;


@end

@implementation XMNGestureLockItemView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self _transCtx:ctx fromRect:rect];
    [self  _setupContext:ctx];
    [self _drawOuter:ctx];
    if (self.state != XMNGestureLockItemViewStateNormal) {
        [self _drawInner:ctx];
        [self _drawDirectionFlag:ctx rect:rect];
    }
}


#pragma mark - Methods

- (void)_transCtx:(CGContextRef)ctx fromRect:(CGRect)rect {

    if(self.direction == XMNGestureLockDirectionUnknown) return;
        
    CGFloat translateXY = rect.size.width * .5f;
    //平移
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    //旋转指定角度
    CGContextRotateCTM(ctx, self.angle);
    //再平移回来
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}

- (void)_setupContext:(CGContextRef)ctx {
    
    //设置线宽
    CGContextSetLineWidth(ctx, kXMNGestureLockLineWidth);
    //设置颜色
    [self.drawColor set];
}

- (void)_drawOuter:(CGContextRef)ctx {
    
    //新建路径：外部圆环
    CGMutablePathRef outerPath = CGPathCreateMutable();
    
    //设置一个圆环路径
    CGRect calRect = self.outerRect;
    CGPathAddEllipseInRect(outerPath, NULL, calRect);
    //将路径添加到上下文中
    CGContextAddPath(ctx, outerPath);
    //绘制空心圆环
    CGContextStrokePath(ctx);
    //释放路径
    CGPathRelease(outerPath);
}

- (void)_drawInner:(CGContextRef)ctx {
    
    //新建路径：内环
    CGMutablePathRef innerPath = CGPathCreateMutable();
    
    //绘制一个圆形
    CGPathAddEllipseInRect(innerPath, NULL, self.innerRect);
    
    //设置内部实心环颜色
    [self.drawColor set];

    //将路径添加到上下文中
    CGContextAddPath(ctx, innerPath);
    //绘制内部实心圆环
    CGContextFillPath(ctx);
    //释放路径
    CGPathRelease(innerPath);
}

- (void)_drawDirectionFlag:(CGContextRef)ctx rect:(CGRect)rect{
    
    if(self.direction == XMNGestureLockDirectionUnknown) return;
    
    //新建路径：三角形
    CGMutablePathRef trianglePathM = CGPathCreateMutable();
    
    CGFloat marginSelectedCirclev = 4.0f;
    CGFloat w =8.0f;
    CGFloat h =5.0f;
    CGFloat topX = rect.origin.x + rect.size.width * .5f;
    CGFloat topY = rect.origin.y +(rect.size.width *.5f - h - marginSelectedCirclev - self.innerRect.size.height *.5f);
    
    CGPathMoveToPoint(trianglePathM, NULL, topX, topY);
    
    //添加左边点
    CGFloat leftPointX = topX - w *.5f;
    CGFloat leftPointY =topY + h;
    CGPathAddLineToPoint(trianglePathM, NULL, leftPointX, leftPointY);
    
    //右边的点
    CGFloat rightPointX = topX + w *.5f;
    CGPathAddLineToPoint(trianglePathM, NULL, rightPointX, leftPointY);
    
    //将路径添加到上下文中
    CGContextAddPath(ctx, trianglePathM);
    
    //绘制圆环
    CGContextFillPath(ctx);
    
    //释放路径
    CGPathRelease(trianglePathM);
}

#pragma mark - Setters

- (void)setState:(XMNGestureLockItemViewState)state {
    
    _state = state;
    [self setNeedsDisplay];
}

- (void)setDirection:(XMNGestureLockDirection)direction {
    
    _direction = direction;
    self.angle = M_PI_4 * (direction -1);
    [self setNeedsDisplay];
}

- (void)setAngle:(CGFloat)angle {
    
    _angle = angle;
    [self setNeedsDisplay];
}

#pragma mark - Getters


- (CGRect)outerRect {
    
    if (CGRectEqualToRect(_outerRect, CGRectZero)) {
        _outerRect = CGRectInset(self.bounds, kXMNGestureLockLineWidth, kXMNGestureLockLineWidth);
    }
    return _outerRect;
}

-(CGRect)innerRect{
    
    if (CGRectEqualToRect(_innerRect, CGRectZero)) {
        _innerRect = CGRectInset(self.outerRect, self.outerRect.size.width * kXMNGestureLockInnerRoundRadio, self.outerRect.size.width * kXMNGestureLockInnerRoundRadio);
    }
    return _innerRect;
}

- (UIColor *)drawColor {
    
    switch (self.state) {
        case XMNGestureLockItemViewStateSelected:
            return kXMNGestureLockSelectedColor;
            break;
        case XMNGestureLockItemViewStateError:
            return kXMNGestureLockErrorColor;
            break;
        case XMNGestureLockItemViewStateNormal:
        default:
            return kXMNGestureLockNormalColor;
            break;
    }
}

@end
