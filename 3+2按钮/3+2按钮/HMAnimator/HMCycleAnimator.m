//
//  HMCycleAnimator.m
//  HMBest
//
//  Created by itteacher on 2017/8/29.
//  Copyright © 2017年 itteacher. All rights reserved.
//

#import "HMCycleAnimator.h"

@interface HMCycleAnimator () <CAAnimationDelegate>

@end

@implementation HMCycleAnimator {
    __weak id <UIViewControllerContextTransitioning>    _transitionContext;//weak
}
/*
 @protocol UIViewControllerAnimatedTransitioning <NSObject>
 
 // This is used for percent driven interactive transitions, as well as for
 // container controllers that have companion animations that might need to
 // synchronize with the main animation.
 - (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
 // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
 - (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
 */

#pragma mark - UIViewControllerAnimatedTransitioning -
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
 ** 注意，如果当前是present切style是Custom,那么在dismiss的时候就不要加toView了，你可以这样简单理解，一般在转场结束completeTransition后，会自动将fromView从容器中移除。但是Custom类型的时候却没有移除，你可以明显的看到。因此在dismiss的时候，之前的fromView 也就变成了toView。**
 3.书写酷炫的动画代码，一般使用UIView 的类方法 animaitonWithDur....，如果对toView/fromView的layer做动画就用CABaseAnimation去做。
 4.在completion回调或者animationdidStop中记得写上 completeTransition（ture）很重要
 */
// 提供专场动画时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

// 编写具体的专场动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    _transitionContext = transitionContext;
    
    // 1. 获取动画容器
    UIView *containerView = [transitionContext containerView];
    
    // 2. 获取(源)视图和(目标)视图
    // 就是当前显示的视图
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    // 还能拿到视图控制器
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 将要打开视图
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // 将要打开的视图控制器
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    
    
//    NSLog(@"containerView:%@",containerView);
//
//    NSLog(@"fromVC:%@,toVC:%@",fromVC,toVC);
//    NSLog(@"fromView:%@,toView:%@",fromView,toView);
    // 如果需要2个视图进行动画就必须都在视图容器内
    // 难点：fromVivew 和 toView 上下层次关系
    if(self.isPresented) {
        //显示
        [containerView addSubview:toView];//最上面
    } else {
        //消失
#pragma mark
#pragma mark - 反正dimiss时用insertSubview:atIndex就对了
        [containerView insertSubview:toView atIndex:0];//最下面
    }
    
    

    // toView 和 fromView 之间关系
    
    
    // 专场方式
    // 思路让2个视图叠加，同时有一个圆漏空显示
    // 可以采用一种遮罩的形式
    // 思路:
    // 1. 你设置一个视图作为一个遮罩视图 -> 只要遮罩到的地方就可以显示出来
    // 2. 想办法改变遮罩的半径
    // 3. 计算结束半径长度
    /*
    UIView *maskView = [UIView new];
    maskView.frame = CGRectMake(0, 0, 200, 200);
    maskView.backgroundColor = [UIColor redColor];
    toView.maskView = maskView;
     */
    // 创建遮罩层 -> 遮罩中部分才显示
    
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    
    // 中心点
    CGPoint centerPoint = self.centerPoint;
    
    // 计算宽度
    CGFloat width = MAX(centerPoint.x, [UIScreen mainScreen].bounds.size.width - centerPoint.x);
    // 计算高度
    CGFloat height = MAX(centerPoint.y, [UIScreen mainScreen].bounds.size.height - centerPoint.y);//MAX(8,9) = 9************
    
    CGFloat maxRadius = sqrt(pow(width, 2) + pow(height, 2));//pow(3,2)=9;sqrt(9)=3*****
    
    // 半径                  //显示时 0->Max
    CGFloat beginRadius = self.isPresented ? 0 : maxRadius;
    
    // 通过勾股定理计算        //消失时 Max->0
    CGFloat endRadius = self.isPresented ? maxRadius : 0;
    
    // 创建圆型绘制路径 // clockwise 是否顺时针 ///贝塞尔曲线->画圆
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:beginRadius startAngle:0 endAngle:360 clockwise:YES];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:endRadius startAngle:0 endAngle:360 clockwise:YES];
    
    // 创建一个keypath动画     CABasicAnimation基础动画( CAKeyframeAnimation 关键帧动画???)
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)([beginPath CGPath]);
    animation.toValue = (__bridge id _Nullable)([endPath CGPath]);
    animation.duration = [self transitionDuration:transitionContext];//***
    
    // 设置动画向前填充
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    // 设置代理完成后完成动画
    animation.delegate = self;
    
    // 设置层的遮罩
    // 遮罩应用目标色糊涂
#pragma mark
#pragma mark - 反正CAShapeLayer遮罩都是针对toView的
    if(self.isPresented) {
        //显示时动画     // 0->max
        toView.layer.mask = maskLayer;
    } else {
        //消失时动画     // Max->0
        fromView.layer.mask = maskLayer;
    }
    
    
    [maskLayer addAnimation:animation forKey:@"anim"];//遮罩添加动画
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [transitionContext completeTransition:YES];
//    });
    
}

#pragma mark - CAAnimationDelegate -
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 一旦使用自定义专场动画，苹果API会事件冻结，所以当我们完成动画以后需要解除冻结
    [_transitionContext completeTransition:YES];
    
}

@end
