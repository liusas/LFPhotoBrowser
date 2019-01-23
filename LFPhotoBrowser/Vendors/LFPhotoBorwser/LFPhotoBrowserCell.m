//
//  LFPhotoBrowserCell.m
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/12.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "LFPhotoBrowserCell.h"
#import "LFPhotoBrowserConfig.h"
#import "UIImageView+YYWebImage.h"
#import "LFPhotoBrowserProgress.h"

@interface LFPhotoBrowserCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LFPhotoBrowserProgress *progressLayer;//进度条

@property (nonatomic, assign) CGPoint centerOfContentSize;
@property (nonatomic, assign) CGRect originFrame;//拖拽之前的imageView初始frame
@property (nonatomic, assign) CGPoint originTouchPoint;//拖拽之前的imageView初始触点

@end

@implementation LFPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.layer addSublayer:self.progressLayer];
    [self addGesture];
}

/**
 设置图片
 
 @param url 高分辨率图片的url
 @param image 占位图
 */
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image {
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    UIImage *imageFromMemory = nil;
    if (manager.cache) {
        imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:url] withType:YYImageCacheTypeMemory];
    }
    
    if (imageFromMemory) {
        self.imageView.image = imageFromMemory;
        [self setImagePositionOnContainerView:image];
        self.progressLayer.hidden = YES;
        return;
    }
    
    //计算imageView的位置
    [self setImagePositionOnContainerView:image];
    
    [self.imageView yy_setImageWithURL:url placeholder:image options:YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionProgressiveBlur progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        self.progressLayer.progress = progress;
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (!error) {
            self.progressLayer.hidden = YES;
            [self setImagePositionOnContainerView:image];
        }
    }];
}

//添加手势
- (void)addGesture {
    //单击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGR:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    //双击事件
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    
    //拖拽事件
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)];
    pan.delegate = self;
    [self.scrollView addGestureRecognizer:pan];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}


/**
 根据图片设置图片位置

 @param image 源图片
 */
- (void)setImagePositionOnContainerView:(UIImage *)image {
    CGFloat heightRatio = image.size.height / image.size.width;
    CGFloat height = self.bounds.size.width * heightRatio;
    
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, height);
    self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, height);
    
    self.imageView.center = self.centerOfContentSize;
}

#pragma mark - GestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]) {
        return true;
    }
    
    //判断拖拽手势的方向,如果是横向的话则不响应拖拽手势
    //下列方法是获取手势在X,Y轴的移动像素,没有负值,但交互不是特别理想,
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.scrollView];
    if (translation.x) {//当translation.x有值时,是横向滑动
        return false;
    }
    
    //判断拖拽手势上下移动方向,velocityInView属于在指定坐标系内的移动速度,具有正负值,所以可以用来判断
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.scrollView];
    if (ABS((int)velocity.x) - velocity.y >= 0) {//角度小于45°的都属于横向滑动
        return false;
    }
    
    if ((int)velocity.y < 0) {//向上滑动,不相应拖拽手势
        return false;
    }
    
    //在图片被放大,超出屏幕显示范围时,不响应拖拽手势
    if (self.scrollView.contentOffset.y > 0) {
        return false;
    }
    
    return true;
}

#pragma mark - Gesture response
//单击事件
- (void)singleTapGR:(UITapGestureRecognizer *)tapGR {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowserCellDismiss:)]) {
        [self.delegate photoBrowserCellDismiss:self];
    }
}

//双击事件
- (void)doubleTapGR:(UITapGestureRecognizer *)doubleGR {
    if (self.scrollView.zoomScale >= ImageMaximumScale) {//表示已经放大,现在缩小
        [self.scrollView setZoomScale:1.0f animated:YES];
    } else {//现在没有放大,则先暂放大
        CGPoint point = [doubleGR locationInView:self.scrollView];
        CGRect zoomRect = [self zoomRectForScrollView:self.scrollView withScale:ImageMaximumScale withCenter:point];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

//拖拽事件
- (void)panGR:(UIPanGestureRecognizer *)panGR {
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.originFrame = self.imageView.frame;
            self.originTouchPoint = [panGR locationInView:panGR.view];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            //拖动偏移量
            CGPoint translation = [panGR translationInView:panGR.view];
            CGPoint currentTouch = [panGR locationInView:panGR.view];
            
            //根据下拉偏移量决定缩放比例,scale的值区间为[0.3, 1.0]
            CGFloat scale = MIN(1.0, MAX(0.3, 1 - translation.y / self.bounds.size.height));
            
            CGFloat width = CGRectGetWidth(self.originFrame) * scale;
            CGFloat height = CGRectGetHeight(self.originFrame) * scale;
            
            //计算触点与照片的相对位置,比如计算(原触点与原图片左侧的距离)/原图片宽度 = (现触点与现图片左侧的距离)/现图片宽度
            CGFloat xRate = (self.originTouchPoint.x - self.originFrame.origin.x) / self.originFrame.size.width;
            CGFloat yRate = (self.originTouchPoint.y - self.originFrame.origin.y) / self.originFrame.size.height;
            CGFloat x = currentTouch.x - xRate * width;
            CGFloat y = currentTouch.y - yRate * height;
            
            self.imageView.frame = CGRectMake(x, y, width, height);
            
            //改变背景alpha
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowserCell:panScale:)]) {
                [self.delegate photoBrowserCell:self panScale:scale];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {//拖拽停止时,判断速度如果小于50,图片归位
            CGPoint velocity = [panGR velocityInView:self];
            if (velocity.y <= 50.f) {
                //改变背景alpha
                if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowserCell:panScale:)]) {
                    [self.delegate photoBrowserCell:self panScale:1.f];
                }
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.imageView.frame = self.originFrame;
                }];
                
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowserCellDismiss:)]) {
                    [self.delegate photoBrowserCellDismiss:self];
                }
            }
        }
            break;
            
        default:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowserCellDismiss:)]) {
                [self.delegate photoBrowserCellDismiss:self];
            }
        };
            break;
    }
}

/**
 苹果官方提供的示例
 该方法返回的矩形适合传递给zoomToRect:animated:方法。
 
 @param scrollView UIScrollView实例
 @param scale 新的缩放比例（通常zoomScale通过添加或乘以缩放量而从现有的缩放比例派生而来)
 @param center 放大缩小的中心点
 @return zoomRect 是以内容视图为坐标系
 */
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    self.imageView.center = self.centerOfContentSize;
}

#pragma mark - Getters
- (LFPhotoBrowserProgress *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [[LFPhotoBrowserProgress alloc] init];
    }
    return _progressLayer;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)-PhotoBrowserImageViewMargin, CGRectGetHeight(self.bounds))];
//        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)-PhotoBrowserImageViewMargin, CGRectGetHeight(self.bounds))];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

- (CGPoint)centerOfContentSize {
    CGFloat deltaWidth = SCREEN_WIDTH - self.scrollView.contentSize.width;
    CGFloat offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0;
    CGFloat deltaHeight = SCREEN_HEIGHT - self.scrollView.contentSize.height;
    CGFloat offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0;
    
    return CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}

@end
