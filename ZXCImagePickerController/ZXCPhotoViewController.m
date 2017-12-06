//
//  UIPhotoViewController.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/4.
//  Copyright © 2017年 VIC. All rights reserved.
//

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#import "ZXCPhotoViewController.h"
#import "ZXCImageManager.h"
#import "BottomView.h"
@interface ZXCPhotoViewController ()<UIScrollViewDelegate>
{
    BOOL bottomViewIsHidden;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) BottomView *bottomView;
@end

@implementation ZXCPhotoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight , kScreenWidth, 60)];
    _bottomView.transform = CGAffineTransformMakeTranslation(0, -60);
     [_bottomView.left addTarget:self action:@selector(turn) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.right addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:_bottomView];
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @autoreleasepool{
                _photo = [UIImage imageWithData:imageData];
                self.imageView.image = _photo;
            }
        });
    }];

}
- (void)save{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.photo forKey:@"image"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"albumPhoto" object:dic];
}
-(void)turn{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    scrollView.center = self.view.center;
    self.imageView.center = self.view.center;

}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.center = self.view.center;
        scrollView.frame = self.view.bounds;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 0.2;
        _scrollView =scrollView;
    }
    return _scrollView;
}
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    
    if (bottomViewIsHidden) {
        [UIView animateWithDuration:0.3 animations:^{
             _bottomView.transform = CGAffineTransformMakeTranslation(0, -60);
        }];
       

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.transform = CGAffineTransformIdentity;
        }];

    }
    bottomViewIsHidden = !bottomViewIsHidden;

    
}
-(UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *photo = [[UIImageView alloc] init];
        photo.userInteractionEnabled = YES;
        photo.frame = self.view.bounds;
        photo.center = self.view.center;
        photo.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [photo addGestureRecognizer:tapGesture];
        _imageView = photo;
    }
    return _imageView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
