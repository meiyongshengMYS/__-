//
//  cycleAnimator.h
//  3+2按钮
//
//  Created by 梅 on 2017/9/17.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "animator.h"

@interface cycleAnimator : animator <UIViewControllerTransitioningDelegate>

@property(nonatomic,assign)CGPoint centerPoint;

@end
