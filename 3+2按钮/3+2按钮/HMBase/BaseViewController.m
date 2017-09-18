//
//  BaseViewController.m
//  3+2按钮
//
//  Created by 梅 on 2017/9/17.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationCustom;//重写动画时,设置modalPresentationStyle为UIModalPresentationCustom(定制)
    self.transitioningDelegate = self.animator;//?????
}

//-(id<UIViewControllerTransitioningDelegate>)animator{
//    if(_animator == nil){
//        _animator = [HMCycleAnimator new];
//    }
//    return _animator;
//}



@end
