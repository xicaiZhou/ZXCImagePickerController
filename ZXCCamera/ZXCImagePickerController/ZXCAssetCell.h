//
//  ZXCAssetCell.h
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/4.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ZXCAssetCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) PHAsset *asset;

@end
