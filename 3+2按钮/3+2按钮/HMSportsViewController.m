//
//  HMSportsViewController.m
//  3+2按钮
//
//  Created by 梅 on 2017/8/30.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "HMSportsViewController.h"
#import "HMMapViewController.h"

@interface HMSportsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continPauseButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tralingConstraint;

@end

@implementation HMSportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.continPauseButton setImage:[UIImage imageNamed:@"ic_sport_continue"] forState:UIControlStateNormal];
     [self.continPauseButton setImage:[UIImage imageNamed:@"ic_sport_pause"] forState:UIControlStateSelected];
//    [self.continPauseButton setImage:[UIImage imageNamed:@"ic_sport_continue"] forState:UIControlStateHighlighted];
    
    [self setupBackground];
}

- (void)setupBackground{
    CAGradientLayer *backgroundLayer = [CAGradientLayer new];
    backgroundLayer.frame = self.view.bounds;
    // 设置渐变属性
    // 渐变颜色区别,注意：内部数组不能用 UIColor，只能用  CGColorRef
    backgroundLayer.colors = @[
                               (__bridge id)[UIColor redColor].CGColor,
                               (__bridge id)[UIColor orangeColor].CGColor,
                               (__bridge id)[UIColor yellowColor].CGColor
                               ];
    backgroundLayer.locations = @[@0.0,@0.5,@1.0];//颜色原色出现百分比位置
    backgroundLayer.startPoint = CGPointMake(1, 0);
    backgroundLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:backgroundLayer atIndex:0];//最下层添加
}
- (IBAction)clickButton:(UIButton *)button {
    [self.view layoutIfNeeded];


    if(button.isSelected){
        //暂停->继续
        [UIView animateWithDuration:0.3 animations:^{
            self.leadingConstraint.constant = 20;
            self.tralingConstraint.constant = 20;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
//            [self.continPauseButton setImage:[UIImage imageNamed:@"ic_sport_continue"] forState:UIControlStateNormal];
            self.continPauseButton.selected = NO;
        }];
    }else{
        //继续->暂停137
        [UIView animateWithDuration:0.3 animations:^{
            self.leadingConstraint.constant = 137;
            self.tralingConstraint.constant = 137;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
//            [self.continPauseButton setImage:[UIImage imageNamed:@"ic_sport_pause"] forState:UIControlStateSelected];
            self.continPauseButton.selected = YES;
            
        }];
    }
//    self.continPauseButton.selected = !button.isSelected;

}
- (IBAction)actionOpenMap:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HMMapViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HMMapViewController"];
    [self presentViewController:vc  animated:YES completion:nil];
}

@end
