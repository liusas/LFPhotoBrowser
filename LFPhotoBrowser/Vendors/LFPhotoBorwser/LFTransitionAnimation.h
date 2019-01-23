//
//  LFTransitionAnimation.h
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/17.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFTransitionType) {
    LFTransitionPresent = 0,
    LFTransitionDismiss
};

NS_ASSUME_NONNULL_BEGIN

@interface LFTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) LFTransitionType transitionType;
@end

NS_ASSUME_NONNULL_END
