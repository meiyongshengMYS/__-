//
//  CameraViewController.m
//  3+2按钮
//
//  Created by 梅 on 2017/9/19.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *output;

@property (nonatomic, assign) BOOL isFront;

@property (weak, nonatomic) IBOutlet UIImageView *waterImageView;
@property (weak, nonatomic) IBOutlet UIButton *photobuttonImageView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSession];
    
}

- (AVCaptureDeviceInput *)creatDeviceInput{
    //如何去获取2个不同的摄像头
    AVCaptureDevice *device = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *dev in devices){
        if(dev.position == AVCaptureDevicePositionFront && self.isFront){
            device = dev;
        }else if(dev.position == AVCaptureDevicePositionBack && !self.isFront){
            device = dev;
        }
    }
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    return input;
}

- (void)setupSession{
    self.session = [AVCaptureSession new];
    self.videoInput = [self creatDeviceInput];
    self.output = [AVCaptureStillImageOutput new];
    
    //关联session与input,output
    if( self.videoInput && [self.session canAddInput:self.videoInput]){
        [self.session addInput:self.videoInput];
    }
    if( self.output && [self.session canAddOutput:self.output]){
        [self.session addOutput:self.output];
    }
    
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    
    layer.frame = self.previewView.bounds;
    
    [self.previewView.layer insertSublayer:layer atIndex:0];
    //预览模式
    // AVLayerVideoGravityResizeAspect // 等比例缩放展示完整的图像 不拉伸
    // AVLayerVideoGravityResizeAspectFill // 全屏展示图像，把图像等比例放大裁剪 不拉伸
    // AVLayerVideoGravityResize 满屏显示 拉伸
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.session startRunning];//session开始
}

- (IBAction)actionCloseVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)actionOpenCamera:(id)sender {
    //捕获照片链接
    AVCaptureConnection *con = self.output.connections.lastObject;//..
    __weak typeof(self)weakself = self;
    [self.output captureStillImageAsynchronouslyFromConnection:con completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(error != nil) return;
        //照片数据转成JPEG格式数据
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        //插个水印
#pragma mark
#pragma mark - 开启绘图上下文
        UIGraphicsBeginImageContextWithOptions(self.previewView.frame.size, YES, 0);//(opaque:不透明)创建绘图上下文.......(preview大小的图上做文章)
        /*
         CGRectInset解析
         CGRect CGRectInset (
         CGRect rect,
         CGFloat dx,
         CGFloat dy
         );
         具体小多少都是要参照dx和dy来判定的。dx和dy—>>>正表示放大;负表示缩小
         */
        //CGRectInset中dy应该缩小的高度
        CGFloat reduceHeight = ([UIScreen mainScreen].bounds.size.height - self.previewView.frame.size.height)/2;//除以2;(上缩小一半;下缩小一半)
        [image drawInRect:CGRectInset(weakself.previewView.bounds, 0, -reduceHeight)];//dy=0宽不变;-dy高减少一半
        [weakself.waterImageView.image drawInRect:weakself.waterImageView.frame];
        //再_>获取 修改后的图
        UIImage *newIamge = UIGraphicsGetImageFromCurrentImageContext();
#pragma mark
#pragma mark - (得到绘制后图片)关闭绘图上下文
        UIGraphicsEndImageContext();
        //sleep(1);
        [self rotateButtonAnimation];
        UIImageWriteToSavedPhotosAlbum(newIamge, self, nil, nil);
    }];
    
}
- (void)rotateButtonAnimation{
    //if(self.session.isRunning){
    // 旋转拍照按钮
    [UIView transitionWithView:self.photobuttonImageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        //[self.photobuttonImageView setTitle:@"✔︎" forState:UIControlStateNormal];
                    } completion:^(BOOL finished) {
                        
                    }];
    
}
- (IBAction)actionSwitchCamera:(id)sender {
    [self.session stopRunning];//关闭设备
    [self.session removeInput:self.videoInput];//移除输入
    self.isFront = !self.isFront;
    self.videoInput = [self creatDeviceInput];//重新创建输入
    //重新设置输入
    if(self.videoInput && [self.session canAddInput:self.videoInput]){
        [self.session addInput:self.videoInput];
    }
    [self.session startRunning];//开启设备
}

- (void)dealloc{
    [self.session stopRunning];
}

@end
