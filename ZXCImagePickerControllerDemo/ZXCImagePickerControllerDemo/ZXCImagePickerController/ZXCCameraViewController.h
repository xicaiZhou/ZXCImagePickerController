//
//  CameraViewController.h
//  photographDemo
//
//  Created by 周希财 on 2017/11/29.
//  Copyright © 2017年 Renford. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXCCameraViewControllerDelegate
-(void)cameraPhoto:(UIImage *)image;
@end
@interface ZXCCameraViewController : UIViewController
@property (nonatomic, weak)id<ZXCCameraViewControllerDelegate> delegate;
@end
