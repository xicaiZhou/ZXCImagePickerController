//
//  CameraViewController.m
//  photographDemo
//
//  Created by 周希财 on 2017/11/29.
//  Copyright © 2017年 Renford. All rights reserved.
//
#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0
#import "ZXCCameraViewController.h"
#import "ZXCImageManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ZXCCameraViewController()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong)UIButton *PhotoButton;
@property (nonatomic, strong)UIButton *flashButton;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *arrow;
@property (nonatomic)UIImageView *imageView;
@property (nonatomic, strong)UIView *focusView;
@property (nonatomic)BOOL isflashOn;
@property (nonatomic)UIImage *image;

@property (nonatomic)BOOL canCa;

@end

@implementation ZXCCameraViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    _canCa = [self canUserCamear];
    if (_canCa) {
        [self customCamera];
        [self customUI];
        
    }else{
        return;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(kScreenWidth*1/2.0 + 90, kScreenHeight-100, 60, 60);
        [_cancelBtn setImage:[UIImage imageNamed:@"images.bundle/cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.transform = CGAffineTransformMakeTranslation(-60, 0);
    }
    return _cancelBtn;
}
- (UIButton *)PhotoButton{
    
    if (!_PhotoButton) {
        _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _PhotoButton.frame = CGRectMake(kScreenWidth*1/2.0-30, kScreenHeight-100, 60, 60);
        [_PhotoButton setImage:[UIImage imageNamed:@"images.bundle/photograph"] forState: UIControlStateNormal];
        
        [_PhotoButton addTarget:self action:@selector(shutterCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PhotoButton;
}
-(UIView *)focusView{
    if (!_focusView) {
        _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor =[UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
    }
    return _focusView;
}
- (UIButton *)arrow{
    if (!_arrow) {
        _arrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrow.frame = CGRectMake(kScreenWidth*1/4.0-30, kScreenHeight-100, 60, 60);
        [_arrow setImage:[UIImage imageNamed:@"images.bundle/arrow_under"] forState:UIControlStateNormal];
        _arrow.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_arrow  addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrow;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(kScreenWidth - 70, 20, 60, 60);
        [_rightButton setImage:[UIImage imageNamed:@"images.bundle/camera"] forState: UIControlStateNormal];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(UIButton *)flashButton{
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.frame = CGRectMake(kScreenWidth-70, 80, 60, 60);
        
        [_flashButton setImage:[UIImage imageNamed:@"images.bundle/flash_off"] forState:UIControlStateNormal];
        [_flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}
- (void)customUI{
    
    [self.view addSubview:self.PhotoButton];

    self.cancelBtn.hidden = YES;
    [self.view addSubview:self.cancelBtn];
    
    [self.view addSubview:self.focusView];
    _focusView.hidden = YES;

    [self.view addSubview:self.arrow];
   
    [self.view addSubview:self.rightButton];
   
    [self.view addSubview:self.flashButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}
- (void)customCamera{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            _device.flashMode = AVCaptureFlashModeOff;
            [_device setTorchMode:AVCaptureTorchModeOff];
//            [_device setFlashMode:AVCaptureFlashModeAuto];
//            [_device setTorchMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}
- (void)FlashOn{
    
    //修改前必须先锁定
    [_device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([_device hasFlash]) {
        
        if (_device.flashMode == AVCaptureFlashModeOff) {
            _device.flashMode = AVCaptureFlashModeOn;
            [_device setTorchMode:AVCaptureTorchModeOn];

               [_flashButton setImage:[UIImage imageNamed:@"images.bundle/flash"] forState: UIControlStateNormal];
        } else if (_device.flashMode == AVCaptureFlashModeOn) {
            _device.flashMode = AVCaptureFlashModeOff;
            [_device setTorchMode:AVCaptureTorchModeOff];
            [_flashButton setImage:[UIImage imageNamed:@"images.bundle/flash_off"] forState:UIControlStateNormal];
//            _device.flashMode = AVCaptureFlashModeAuto;
//            [_device setTorchMode:AVCaptureFlashModeAuto];

        }
//        else if (_device.flashMode == AVCaptureFlashModeAuto) {
//            _device.flashMode = AVCaptureFlashModeOff;
//            [_device setTorchMode:AVCaptureFlashModeOff];
//
//        }
        
    } else {
        
        NSLog(@"设备不支持闪光灯");
    }
    [_device unlockForConfiguration];
    
   
}
- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        
        animation.duration = .5f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}
#pragma mark - 截取照片
- (void) shutterCamera:(UIButton *)sender
{
    
    if (sender.tag == 10001) {
        
       self.image = [[ZXCImageManager manager] fixOrientation:self.image];
        
        [self saveImageToPhotoAlbum:self.image];
        [self.delegate cameraPhoto:self.image];
        [self cancle];
        
        
        return;
    }
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            [_PhotoButton setImage:[UIImage imageNamed:@"images.bundle/a"] forState: UIControlStateNormal];
            _PhotoButton.tag = 10001;
            self.cancelBtn.hidden = NO;
            
            self.rightButton.hidden = YES;
            self.flashButton.hidden = YES;
            self.arrow.hidden = YES;
            self.cancelBtn.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];

        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self.session stopRunning];
        self.imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        [self.view insertSubview:_imageView belowSubview:_PhotoButton];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = _image;
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
    }];
}

#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)cancle{
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)cancel{
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    [UIView animateWithDuration:0.3 animations:^{
        [_PhotoButton setImage:[UIImage imageNamed:@"images.bundle/photograph"] forState: UIControlStateNormal];

        _cancelBtn.transform = CGAffineTransformMakeTranslation(-120, 0);

    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = YES;
        self.rightButton.hidden = NO;
        self.flashButton.hidden = NO;
        self.arrow.hidden = NO;
        _PhotoButton.tag = 10000;

    }];
    

}
#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

@end
