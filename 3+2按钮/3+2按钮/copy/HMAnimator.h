//
//  HMAnimator.h
//  HMBest
//
//  Created by itteacher on 2017/8/29.
//  Copyright © 2017年 itteacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMAnimator : NSObject<UIViewControllerTransitioningDelegate>



@property (assign, nonatomic)   BOOL    isPresented;//是否正在展示
//UIViewControllerTransitioningDelegate

//// 提供显示时专场动画
//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
//
//// 提供消失时的专场动画
//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

@end
