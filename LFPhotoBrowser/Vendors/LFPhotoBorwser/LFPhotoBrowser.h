//
//  LFPhotoBrowser.h
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/12.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LFPhotoBrowser;
@protocol LFPhotoBrowserDelegate <NSObject>

@required
- (UIImageView *)imageViewInPhotoBrowser:(LFPhotoBrowser *)photoBrowser withCurrentIndex:(NSInteger)index;

@optional
/**< 返回图片数量*/
- (NSInteger)numberOfPhotosInPhotoBrowser:(LFPhotoBrowser *)photoBrowser;

/**< 返回缩略图或占位图*/
- (UIImage *)photoBrowser:(LFPhotoBrowser *)photoBrowser thumbnailImageIndex:(NSInteger)index;

/**< 返回高清图片url,string,UIImage等等*/
- (NSString *)photoBrowser:(LFPhotoBrowser *)photoBrowser hightQualityUrlForIndex:(NSInteger)index;

@end

@interface LFPhotoBrowser : UIViewController

@property (nonatomic, weak) id<LFPhotoBrowserDelegate> delegate;


/**
 展示图片浏览器

 @param viewController 上一级控制器
 @param index 当前图片的索引
 */
- (void)showByLastViewController:(nonnull UIViewController *)viewController currentImageIndex:(NSInteger)index;


/**
 获取过场动画前的imageView对象, 用来做动效
 */
- (UIImageView *)imageViewInPhotoBrowser;


/**
 获取过场动画后的imageView对象, 用来做动效
 */
- (UIImageView *)imageViewBeforePresent;

@end

NS_ASSUME_NONNULL_END
