//
//  animator.m
//  3+2按钮
//
//  Created by 梅 on 2017/9/17.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "animator.h"



@interface animator() <UIViewControllerAnimatedTransitioning>

@end

@implementation animator

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.isPresent = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPresent = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    NSAssert(true, @"必须实现transitionDuration");
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    NSAssert(true, @"必须实现transitionContext");
}

@end
