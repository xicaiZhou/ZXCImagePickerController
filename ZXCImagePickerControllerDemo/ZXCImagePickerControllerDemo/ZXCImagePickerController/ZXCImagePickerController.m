//
//  ZXCImagePickerController.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/5.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import "ZXCImagePickerController.h"
#import "ZXCCameraViewController.h"
#import "ZXCAlbumViewController.h"
@interface ZXCImagePickerController ()<ZXCCameraViewControllerDelegate>

@end

@implementation ZXCImagePickerController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumPhoto:) name:@"albumPhoto" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.Type == ZXCImagePickerTypeWithCamera) {
        ZXCCameraViewController *camera = [[ZXCCameraViewController alloc] init];
        camera.delegate = self;
        [self addChildViewController:camera];
        [self.view addSubview:camera.view];

    }else{
        UINavigationController *album = [[UINavigationController alloc] initWithRootViewController:[[ZXCAlbumViewController alloc] init]];
        [self addChildViewController:album];
        [self.view addSubview:album.view];
    }
}
-(void)cameraPhoto:(UIImage *)image{
    
    [self.delegate ZXCImagePickerWithPhoto:image];
}
-(void)albumPhoto:(NSNotification *)notification{
    UIImage *image = (UIImage *)notification.object[@"image"];
     [self.delegate ZXCImagePickerWithPhoto:image];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end
