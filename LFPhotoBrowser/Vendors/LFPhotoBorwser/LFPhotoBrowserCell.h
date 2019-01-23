//
//  LFPhotoBrowserCell.h
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/12.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYWebImage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LFPhotoBrowserCellDelegate <NSObject>

//单击代理
- (void)photoBrowserCellDismiss:(UICollectionViewCell *)cell;

//拖拽代理
- (void)photoBrowserCell:(UICollectionViewCell *)cell panGesture:(UIPanGestureRecognizer *)panGR;

//长按代理
- (void)photoBrowserCell:(UICollectionViewCell *)cell longPress:(UILongPressGestureRecognizer *)longPressGR;

//拖动改变背景alpha
- (void)photoBrowserCell:(UICollectionViewCell *)cell panScale:(CGFloat)scale;

@end

@interface LFPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, weak) id<LFPhotoBrowserCellDelegate> delegate;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
/**
 设置图片

 @param url 高分辨率图片的url
 @param image 占位图
 */
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
