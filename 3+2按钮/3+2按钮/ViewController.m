//
//  ViewController.m
//  3+2按钮
//
//  Created by 梅 on 2017/8/30.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "ViewController.h"
#import "HMSportsViewController.h"

static CGRect twoToThreeFrame;
static CGRect threeToFourFrame;
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIView *sbView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *page;
@property (nonatomic,strong)UIImageView *boxImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.boxImageView = [[UIImageView alloc]init];
     self.boxImageView.image = [UIImage imageNamed:@"workThroughImage"];//初始化动图
    [self judgeVC];
    [self.scrollView insertSubview:self.boxImageView atIndex:5];//添加
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self addAnimation];
}
#pragma mark
#pragma mark - 判断是否是第一次进入
- (void)judgeVC{
    NSString *isFirstOpen = [[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstOpenApp"];
    if(isFirstOpen==nil){
        //第一次打开
         [self addAnimation];
    }else{
        return ;
    }
//    [self addAnimation];
    [[NSUserDefaults standardUserDefaults]setObject:@"isFirstOpenApp" forKey:@"isFirstOpenApp"];//赋值
}
- (IBAction)enterButton:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Sports" bundle:nil];
    HMSportsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HMSportsViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addAnimation{
    //
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    self.sbView = vc.view;
    vc.view.backgroundColor = [UIColor grayColor];
    //
    [self.view addSubview:self.sbView];//主页view加
    //
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.delegate = self;//pageControl用的代理方法
    self.scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*4, self.view.frame.size.height);
    self.scrollView.bounces = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = YES;
    [self.sbView addSubview:self.scrollView];
#pragma mark
#pragma mark - pageControl
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectZero];
    self.page = page;
    page.numberOfPages = 4;
    page.currentPageIndicatorTintColor = [UIColor blackColor];
    page.pageIndicatorTintColor = [UIColor grayColor];
    [self.sbView addSubview:page];
    page.frame = CGRectMake(0, self.view.bounds.size.height-20, self.view.bounds.size.width, 10);
    //循环添加图片
    NSArray *imageArr = @[@"workThrough_first",@"workThrough_second",@"workThrough_third",@"workThrough_four"];
    for(int i = 0;i<4;i++){
        UIImage *image = [UIImage imageNamed:imageArr[i]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        if(i == 3){
            UIButton *button = [[UIButton alloc]init];
//            [button setBackgroundColor:[UIColor grayColor]];
            [button setTitle:@"进入" forState:UIControlStateNormal];
            [button sizeToFit];
            [imageView addSubview:button];
            button.frame = CGRectMake(0, imageView.bounds.size.height-50, imageView.bounds.size.width, 30);
            imageView.userInteractionEnabled = YES;//图片交互
            [button addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if(i == 0){//插入第一张图
//            [self.scrollView addSubview:self.boxImageView];
            self.boxImageView.frame = CGRectMake(self.view.bounds.size.width*(83.0/375.0), self.view.bounds.size.height*(288.0/667.0), 208, 192);//......................................
            NSLog(@"%@",self.boxImageView);
//            NSLog(@"%@",imageView);
        }
        
    }
   
}
- (void)enterAction:(UIButton *)button{
    [self.sbView removeFromSuperview];
}
#pragma mark
#pragma mark - workThroughImage 跳跃的图片
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger number = scrollView.contentOffset.x/self.view.bounds.size.width;
    self.page.currentPage = number;
//    NSLog(@"%ld",number);
    float temp = scrollView.contentOffset.x/self.view.bounds.size.width;
//    NSLog(@"temp=%lf",temp);
    float width = self.view.bounds.size.width;
    float height = self.view.bounds.size.height;
    if(temp>0&&temp<1){
        CGRect frame = self.boxImageView.frame;
        frame = CGRectMake(width*(83.0/width) + (width+75-82)*(scrollView.contentOffset.x/width), height*(288.0/height)-(288-159)*(scrollView.contentOffset.x/width), 208+(224-208)*((scrollView.contentOffset.x/width)), 192+(195-192)*(scrollView.contentOffset.x/width));
        self.boxImageView.frame = frame;
    }
//    NSLog(@"%@",NSStringFromCGRect(self.boxImageView.frame));
    if(temp == 1)twoToThreeFrame = self.boxImageView.frame;
    if(temp>1&&temp<2){//   3>>>>2 错误??
        CGRect frame = twoToThreeFrame;
        frame.origin.x = frame.origin.x + (width + 191-75)*((scrollView.contentOffset.x-width)/(width));
        frame.origin.y = frame.origin.y + (167-159)*((scrollView.contentOffset.x-width)/(width));
        frame.size.width = frame.size.width - (224-103)*((scrollView.contentOffset.x-width)/(width));
        frame.size.height = frame.size.height - (195-88)*((scrollView.contentOffset.x-width)/(width));
        self.boxImageView.frame = frame;
    }
    if(temp == 2)threeToFourFrame = self.boxImageView.frame;
    if(temp>2&&temp<3){
        CGRect frame = threeToFourFrame;
        frame.origin.x = frame.origin.x + (width + 75-191)*((scrollView.contentOffset.x-width*2)/(width));
        frame.origin.y = frame.origin.y + (159-167)*((scrollView.contentOffset.x-width*2)/(width));
        frame.size.width = frame.size.width + (225-103)*((scrollView.contentOffset.x-width*2)/(width));
        frame.size.height = frame.size.height + (198-88)*((scrollView.contentOffset.x-width*2)/(width));
        self.boxImageView.frame = frame;
    }
}


@end
