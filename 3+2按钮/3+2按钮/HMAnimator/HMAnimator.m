//
//  HMAnimator.m
//  3+2按钮
//
//  Created by 梅 on 2017/9/15.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "HMAnimator.h"

@interface HMAnimator()<CAAnimationDelegate>

@end

@implementation HMAnimator{
    __weak id<UIViewControllerContextTransitioning> _transtionContext;//,
}

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
/*
 //告诉他动画的时长
 func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
 return 0.5
 }
 
 //这个是最主要的，告诉他执行什么动画
 func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
 ...
 1.拿到容器视图containerView，fromVC,toVC
 2.将要执行动画的视图 toView 加到containerView中，其中fromView 系统已经自动加入.
 ** 注意，如果当前是present的style是Custom,那么在dismiss的时候就不要加toView了，你可以这样简单理解，一般在转场结束completeTransition后，会自动将fromView从容器中移除。但是Custom类型的时候却没有移除，你可以明显的看到。因此在dismiss的时候，之前的fromView 也就变成了toView。**
 3.书写酷炫的动画代码，一般使用UIView 的类方法 animaitonWithDur....，如果对toView/fromView的layer做动画就用CABaseAnimation去做。
 4.在completion回调或者animationdidStop中记得写上 completeTransition（ture）很重要
 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    _transtionContext = transitionContext;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
#pragma mark
#pragma mark - 动画实现containerView中必须加入fromView,toView两个视图(form默认加入)
     UIView *containerView = [transitionContext containerView];//获取动画容器
    if(self.isPresented){
        //显示动画
        [containerView addSubview:toView];
    }else{
        //消失动画
#pragma mark
#pragma mark - 反正dimiss时用insertSubView:atIndex就行
        [containerView insertSubview:toView atIndex:0];
    }
    
    
    //遮罩层制作动画
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    
    CGPoint centerPoint = self.centerPoint;//圆心
    //半径
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat radius = sqrt(powf(width, 2)+pow(height, 2));
    
    CGFloat beginRadius = self.isPresented ? 0 : radius;
    CGFloat endRadius = self.isPresented ? radius : 0;
    
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:beginRadius startAngle:0 endAngle:360 clockwise:YES];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:endRadius startAngle:0 endAngle:360 clockwise:YES];
    //动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"path"];
    ani.fromValue = beginPath;
    ani.toValue = endPath;
    ani.duration = [self transitionDuration:transitionContext];//动画时长与转场动画时长相等
    /*
     `fillMode' options.
    
    CA_EXTERN NSString * const kCAFillModeForwards
    
    CA_EXTERN NSString * const kCAFillModeBackwards
    
    CA_EXTERN NSString * const kCAFillModeBoth
    
    CA_EXTERN NSString * const kCAFillModeRemoved
    
     */
    ani.fillMode = kCAFillModeForwards;
    ani.removedOnCompletion = YES;
    
    ani.delegate = self;//->动画结束方法->告诉系统转场结束
    
    [maskLayer addAnimation:ani forKey:@""];
    
}
@end
