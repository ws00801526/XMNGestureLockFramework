//
//  XMNGestureLockView.m
//  XMNGestureLockExample
//
//  Created by XMFraker on 16/3/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNGestureLockView.h"
#import "XMNGestureLockItemView.h"

@interface XMNGestureLockView ()

@property (nonatomic, strong) NSMutableArray<XMNGestureLockItemView *> *selectedViews;
@property (nonatomic, strong) NSMutableArray *passwordArray;


@property (nonatomic, assign) BOOL generateSuccess;

@end

@implementation XMNGestureLockView

#pragma mark - Methods


- (instancetype)init {
    
    if (self = [super init]) {
        [self _setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self _setup];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat itemViewWH = (self.frame.size.width - 4 * 36) /3.0f;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx % 3;
        NSUInteger col = idx / 3;
        CGFloat x = 36 * (row +1) + row * itemViewWH;
        CGFloat y =36 * (col +1) + col * itemViewWH;
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        //设置tag
        subview.tag = idx;
        subview.frame = frame;
    }];
}

/*
 *  绘制线条
 */
-(void)drawRect:(CGRect)rect{
    
    //数组为空直接返回
    if(self.selectedViews == nil || self.selectedViews.count == 0) return;
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加路径
    CGContextAddRect(ctx, rect);
    
    //添加圆形路径
    //遍历所有的itemView
    //遮挡住selectedViews 内部的线
    [self.selectedViews enumerateObjectsUsingBlock:^(XMNGestureLockItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextAddEllipseInRect(ctx, obj.frame);
    }];
    //剪裁
    CGContextEOClip(ctx);
    
    //新建路径：管理线条
    CGMutablePathRef pathM = CGPathCreateMutable();
    
    //设置上下文属性
    //1.设置线条颜色
    [(self.generateSuccess ? kXMNGestureLockSelectedColor : kXMNGestureLockErrorColor) set];
    
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    //设置线宽
    CGContextSetLineWidth(ctx, kXMNGestureLockLineWidth * 2);
    
    [self.selectedViews enumerateObjectsUsingBlock:^(XMNGestureLockItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint directPoint = obj.center;
        if(idx == 0){//第一个
            //添加起点
            CGPathMoveToPoint(pathM, NULL, directPoint.x, directPoint.y);
        }else{//其他
            //添加路径线条
            CGPathAddLineToPoint(pathM, NULL, directPoint.x, directPoint.y);
        }
    }];
    
    //将路径添加到上下文
    CGContextAddPath(ctx, pathM);
    //渲染路径
    CGContextStrokePath(ctx);
    
    //释放路径
    CGPathRelease(pathM);
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self _handleGestureChanged:[touches anyObject]];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self _handleGestureChanged:[touches anyObject]];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self _handleGestureEnd];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self _handleGestureEnd];
    [super touchesCancelled:touches withEvent:event];
}


#pragma mark - Methods

- (void)_setup {
    
    self.generateSuccess = YES;
    for (NSUInteger i=0; i<9; i++) {
        XMNGestureLockItemView *itemView = [[XMNGestureLockItemView alloc] init];
        [self addSubview:itemView];
    }
}

- (void)_handleGestureChanged:(UITouch *)touch {
    
    CGPoint touchPoint = [touch locationInView:self];
    XMNGestureLockItemView *itemView = [self _getItemViewWithPoint:touchPoint];
    //如果为空，返回
    if(itemView ==nil) return;
    
    //如果已经存在，返回
    if([self.selectedViews containsObject:itemView]) return;
    
    //添加
    [self.selectedViews addObject:itemView];
    
    //记录密码
    [self.passwordArray addObject:[NSString stringWithFormat:@"%@",@(itemView.tag)]];
    
    //计算方向：每添加一次itemView就计算一次
    [self _calculateDirection];
    
    [itemView setState:XMNGestureLockItemViewStateSelected];

    
    [self setNeedsDisplay];
    
}

- (XMNGestureLockItemView *)_getItemViewWithPoint:(CGPoint)point {
    
    __weak __block XMNGestureLockItemView *itemView = nil;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            itemView = obj;
            *stop = YES;
        }
    }];
    return itemView;
}

- (void)_handleGestureEnd {
    
    self.generateSuccess = self.gestureLockFinished ? self.gestureLockFinished([self.passwordArray componentsJoinedByString:@","]) : YES;

    if (self.generateSuccess) {
        [self _handleClearContext];
    }else {
        [self.selectedViews enumerateObjectsUsingBlock:^(XMNGestureLockItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setState:XMNGestureLockItemViewStateError];
        }];
        self.userInteractionEnabled = NO;
        [self performSelector:@selector(_handleClearContext) withObject:nil afterDelay:.7f];
        [self setNeedsDisplay];
    }
}

- (void)_handleClearContext {
    
    self.userInteractionEnabled = YES;
    self.generateSuccess = YES;
    [self.selectedViews enumerateObjectsUsingBlock:^(XMNGestureLockItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setState:XMNGestureLockItemViewStateNormal];
        [obj setDirection:XMNGestureLockDirectionUnknown];
        [obj setAngle:.0f];
    }];
    [self.selectedViews removeAllObjects];
    [self setNeedsDisplay];
    //清空密码
    [self.passwordArray removeAllObjects];
}

- (void)_calculateDirection {
    
    if (self.selectedViews.count <= 1) {
        return;
    }
    XMNGestureLockItemView *lastItemView = [self.selectedViews objectAtIndex:self.selectedViews.count - 2];
    XMNGestureLockItemView *lastItemView2 = [self.selectedViews lastObject];
    
    CGFloat delatX = lastItemView.frame.origin.x - lastItemView2.frame.origin.x;
    CGFloat delatY = lastItemView.frame.origin.y - lastItemView2.frame.origin.y;
    
    if (delatX < 0) {
        if (delatY == 0) {
            lastItemView.direction = XMNGestureLockDirectionRight;
        }else {
            lastItemView.direction = delatY > 0 ? XMNGestureLockDirectionTopRight : XMNGestureLockDirectionBottomRight;
        }
    }else if (delatX > 0) {
        if (delatY == 0) {
            lastItemView.direction = XMNGestureLockDirectionLeft;
        }else {
            lastItemView.direction = delatY > 0 ? XMNGestureLockDirectionTopLeft : XMNGestureLockDirectionBottomLeft;
        }
    }else {
        if (delatY == 0) {
            lastItemView.direction = XMNGestureLockDirectionUnknown;
        }else {
            lastItemView.direction = delatY > 0 ? XMNGestureLockDirectionTop : XMNGestureLockDirectionBottom;
        }
    }
}

#pragma mark - Getters

-(NSMutableArray *)passwordArray{
    
    if (!_passwordArray) {
        _passwordArray = [NSMutableArray array];
    }
    return _passwordArray;
}

- (NSMutableArray *)selectedViews {
    
    if (!_selectedViews) {
        _selectedViews = [NSMutableArray array];
    }
    return _selectedViews;
}

@end
