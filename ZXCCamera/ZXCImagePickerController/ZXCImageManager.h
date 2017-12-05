//
//  ZXCImageManager.h
//  ZXCCamera
//
//  Created by 周希财 on 2017/11/30.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZXCImageManager : NSObject
+ (instancetype)manager;
- (void)loadAlbumInfoWithCompletionBlock:(void (^)(NSArray * array))completionBlock;
- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage;
@end
