//
//  ViewController.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/11/29.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import "ViewController.h"
#import "ZXCCameraViewController.h"
#import "ZXCAlbumViewController.h"
#import "ZXCPhotoViewController.h"
#import "ZXCImagePickerController.h"
@interface ViewController ()<ZXCImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
}
-(UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *photo = [[UIImageView alloc] initWithFrame:self.view.frame];
        _imageView = photo;
    }
    return _imageView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ZXCImagePickerController *pickerVC = [[ZXCImagePickerController alloc] init];
    pickerVC.delegate = self;
    //ZXCImagePickerTypeWithAlbum相册模式 ZXCImagePickerTypeWithCamera相机模式
    pickerVC.Type = ZXCImagePickerTypeWithAlbum;
    [self presentViewController:pickerVC animated:YES completion:nil];

}
-(void)ZXCImagePickerWithPhoto:(UIImage *)image{
    self.imageView.image = image;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
