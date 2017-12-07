//
//  ViewController.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/11/29.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import "ViewController.h"

#import "ZXCImagePickerController.h"
@interface ViewController ()<ZXCImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(100, 100, 80, 30);
    [cancelBtn setTitle:@"相机模式" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cameraBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnBtn.frame = CGRectMake(100, 200, 80, 30);
    turnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [turnBtn setTitle:@"相册模式" forState:UIControlStateNormal];
    [turnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [turnBtn addTarget:self action:@selector(albumBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:turnBtn];
    
}
-(void)albumBtn{
    ZXCImagePickerController *pickerVC = [[ZXCImagePickerController alloc] init];
    pickerVC.delegate = self;
    //ZXCImagePickerTypeWithAlbum相册模式 ZXCImagePickerTypeWithCamera相机模式
    pickerVC.Type = ZXCImagePickerTypeWithAlbum;
    [self presentViewController:pickerVC animated:YES completion:nil];
}
-(void)cameraBtn{
    ZXCImagePickerController *pickerVC = [[ZXCImagePickerController alloc] init];
    pickerVC.delegate = self;
    //ZXCImagePickerTypeWithAlbum相册模式 ZXCImagePickerTypeWithCamera相机模式
    pickerVC.Type = ZXCImagePickerTypeWithCamera;
    [self presentViewController:pickerVC animated:YES completion:nil];
}
-(UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *photo = [[UIImageView alloc] initWithFrame:self.view.frame];
        _imageView = photo;
    }
    return _imageView;
}

-(void)ZXCImagePickerWithPhoto:(UIImage *)image{
    self.imageView.image = image;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


