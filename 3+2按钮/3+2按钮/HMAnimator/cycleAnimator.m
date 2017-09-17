//
//  cycleAnimator.m
//  3+2按钮
//
//  Created by 梅 on 2017/9/17.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "cycleAnimator.h"

@interface cycleAnimator() <CAAnimationDelegate>

@end

@implementation cycleAnimator{
    __weak id<UIViewControllerContextTransitioning> _transtionContext;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    _transtionContext = transitionContext;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    //    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    //    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //
    //#pragma mark
    //#pragma mark - 动画实现containerView中必须加入fromView,toView两个视图(form默认加入)
    UIView *containerView = [transitionContext containerView];//获取动画容器
    if(self.isPresent){
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
    
    CGFloat beginRadius = self.isPresent ? 0 : radius;
    CGFloat endRadius = self.isPresent ? radius : 0;
    
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:beginRadius startAngle:0 endAngle:360 clockwise:YES];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:endRadius startAngle:0 endAngle:360 clockwise:YES];
    //动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"path"];
    ani.fromValue = (__bridge id _Nullable)([beginPath CGPath]);
    ani.toValue = (__bridge id _Nullable)([endPath CGPath]);
    ani.duration = [self transitionDuration:transitionContext];//动画时长与转场动画时长相等
    /*
     `fillMode' options.
     
     CA_EXTERN NSString * const kCAFillModeForwards
     
     CA_EXTERN NSString * const kCAFillModeBackwards
     
     CA_EXTERN NSString * const kCAFillModeBoth
     
     CA_EXTERN NSString * const kCAFillModeRemoved
     
     */
    ani.fillMode = kCAFillModeForwards;
    ani.removedOnCompletion = NO;
    
    ani.delegate = self;//->动画结束方法->告诉系统转场结束
    
    
    if(self.isPresent){
        //显示
        toView.layer.mask = maskLayer;
    }else{
        //消失
        fromView.layer.mask = maskLayer;
    }
    
    [maskLayer addAnimation:ani forKey:@"anima"];

    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_transtionContext completeTransition:YES];
}
@end
