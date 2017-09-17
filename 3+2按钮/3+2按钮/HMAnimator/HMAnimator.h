//
//  HMAnimator.h
//  3+2按钮
//
//  Created by 梅 on 2017/9/15.
//  Copyright © 2017年 mei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMAnimator : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic,assign)BOOL isPresented;
@property (nonatomic,assign)CGPoint centerPoint;

// 提供显示时专场动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

// 提供消失时的专场动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;


@end
