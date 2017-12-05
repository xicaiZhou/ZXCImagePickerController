//
//  ZXCAssetCell.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/4.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import "ZXCAssetCell.h"
#import "ZXCImageManager.h"

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
@implementation ZXCAssetCell

- (UIImageView *)imageV {
    if (_imageV == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        _imageV = imageView;

    }
    return _imageV;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    [[ZXCImageManager manager] getPhotoWithAsset:_asset photoWidth:80 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.imageV.image = photo;
    }];
}
@end
