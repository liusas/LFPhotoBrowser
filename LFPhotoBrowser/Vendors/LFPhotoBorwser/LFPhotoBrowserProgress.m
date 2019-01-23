//
//  LFPhotoBrowserProgress.m
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/20.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "LFPhotoBrowserProgress.h"
#import "LFPhotoBrowserConfig.h"

@interface LFPhotoBrowserProgress ()

@property (nonatomic, strong) CAShapeLayer *circleShapeLayer;/**< 外层的一圈*/
@property (nonatomic, strong) CAShapeLayer *panShapeLayer;/**< 饼状进度条*/

@end

@implementation LFPhotoBrowserProgress

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.frame = CGRectMake((SCREEN_WIDTH-PhotoBrowserProgressWidth)/2, (SCREEN_HEIGHT-PhotoBrowserProgressWidth)/2, PhotoBrowserProgressWidth, PhotoBrowserProgressWidth);
    [self addSublayer:self.circleShapeLayer];
    [self addSublayer:self.panShapeLayer];
}

- (UIBezierPath *)makeCirclePath {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, PhotoBrowserProgressWidth, PhotoBrowserProgressWidth)];
    path.lineWidth = 2;
    return path;
}

- (UIBezierPath *)makeProgressPathWithProgress:(CGFloat)progress {
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat radius = PhotoBrowserProgressWidth / 2 - 3;//半径
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:radius startAngle:-M_PI_2 endAngle:-M_PI_2 + progress * M_PI * 2 + 0.001 clockwise:true];
    
    [path closePath];
    path.lineWidth = 1.0;
    return path;
}

#pragma mark - Setters
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.panShapeLayer.path = [self makeProgressPathWithProgress:progress].CGPath;
}

#pragma mark - Getters
- (CAShapeLayer *)circleShapeLayer {
    if (!_circleShapeLayer) {
        _circleShapeLayer = [[CAShapeLayer alloc] init];
        _circleShapeLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
        _circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _circleShapeLayer.path = [self makeCirclePath].CGPath;
    }
    return _circleShapeLayer;
}

- (CAShapeLayer *)panShapeLayer {
    if (!_panShapeLayer) {
        _panShapeLayer = [[CAShapeLayer alloc] init];
        _panShapeLayer.fillColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
        _panShapeLayer.path = [self makeProgressPathWithProgress:0.01].CGPath;
    }
    return _panShapeLayer;
}

@end
