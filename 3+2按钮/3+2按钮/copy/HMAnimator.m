//
//  HMAnimator.m
//  HMBest
//
//  Created by itteacher on 2017/8/29.
//  Copyright © 2017年 itteacher. All rights reserved.
//

#import "HMAnimator.h"

@interface HMAnimator () <UIViewControllerAnimatedTransitioning>

@end

@implementation HMAnimator

#pragma mark - UIViewControllerTransitioningDelegate -
// 提供显示时专场动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresented = YES;
    return self;
}

// 提供消失时的专场动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresented = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning -
// 提供专场动画时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(true,@"必须实现 transitionDuration");
    return 0.5;
}

// 编写具体的专场动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    NSAssert(true,@"必须实现 animateTransition");
    
}


@end
