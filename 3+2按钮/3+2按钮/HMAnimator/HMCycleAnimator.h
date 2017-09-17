//
//  HMCycleAnimator.h
//  HMBest
//
//  Created by itteacher on 2017/8/29.
//  Copyright © 2017年 itteacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMAnimator.h"

@interface HMCycleAnimator : HMAnimator <UIViewControllerTransitioningDelegate>

@property (assign, nonatomic)   CGPoint centerPoint;

@end
