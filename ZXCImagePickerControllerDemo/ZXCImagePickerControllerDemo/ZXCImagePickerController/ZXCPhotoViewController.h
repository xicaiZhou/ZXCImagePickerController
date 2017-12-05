//
//  UIPhotoViewController.h
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/4.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@protocol ZXCPhotoViewControllerDelegate
-(void)albumPhoto:(UIImage *)image;
@end
@interface ZXCPhotoViewController : UIViewController
@property (nonatomic, weak) id<ZXCPhotoViewControllerDelegate> delegate;
@property (nonatomic, strong) PHAsset *asset;

@end
