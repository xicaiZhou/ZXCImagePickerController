//
//  ZXCImagePickerController.h
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/5.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXCImagePickerControllerDelegate <NSObject>

-(void)ZXCImagePickerWithPhoto:(UIImage *)image;
@end

typedef NS_ENUM(NSUInteger, ZXCImagePickerType) {
    ZXCImagePickerTypeWithCamera,  // 照相机模式
    ZXCImagePickerTypeWithAlbum    // 相册模式
};

@interface ZXCImagePickerController : UIViewController
@property (nonatomic, assign) ZXCImagePickerType Type;
@property (nonatomic, assign) id<ZXCImagePickerControllerDelegate> delegate;
@end
