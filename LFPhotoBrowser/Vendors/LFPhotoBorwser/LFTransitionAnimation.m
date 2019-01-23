//
//  LFTransitionAnimation.m
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/17.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "LFTransitionAnimation.h"
#import "LFPhotoBrowser.h"
#import "ViewController.h"

@interface LFTransitionAnimation ()

@end

@implementation LFTransitionAnimation

/**< 动画过渡时间*/
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .3;
}

/**< 动画效果设计，过渡动画在此方法中实现*/
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionType == LFTransitionPresent) {
        [self presentTransition:transitionContext];
    } else if (self.transitionType == LFTransitionDismiss) {
        [self dismissTransition:transitionContext];
    }
}

- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //fromVC是转场前的VC
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //toVC是转场后的VC
    LFPhotoBrowser *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];//获取承载过渡动画的containerView
    
    UIImageView *fromImageView = [toVC imageViewBeforePresent];//转场前的imageView
    UIImageView *toImageView = [toVC imageViewInPhotoBrowser];//转场后的imageView
    fromImageView.hidden = YES;
    toImageView.hidden = YES;
    
    //对源视图截图，用作过渡动画，通过动画改变frame实现图片逐渐放大的效果。
    UIView *tempView = [fromImageView snapshotViewAfterScreenUpdates:NO];
    //convertRect的作用是将fromImageView转换到containerView坐标系中对应的frame
    tempView.frame = [fromImageView convertRect:fromImageView.frame toView:containerView];
    toView.alpha = 0;
    [containerView addSubview:toView];
    [containerView addSubview:tempView];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = [toImageView convertRect:toImageView.bounds toView:containerView];
        toView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [tempView removeFromSuperview];
        toImageView.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //fromVC是转场前的VC
    LFPhotoBrowser *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //toVC是转场后的VC
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    UIImageView *fromImageView = [fromVC imageViewInPhotoBrowser];
    UIImageView *toImageView = [fromVC imageViewBeforePresent];
    fromImageView.hidden = YES;
    toImageView.hidden = YES;
    
    UIView *tempView = [fromImageView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [fromImageView convertRect:fromImageView.bounds toView:containerView];
    fromView.alpha = 1.f;
    [containerView addSubview:toView];
    [containerView addSubview:tempView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = [toImageView convertRect:toImageView.bounds toView:containerView];
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
        [tempView removeFromSuperview];
        toImageView.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
}

@end
