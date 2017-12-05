//
//  ZXCAlbumModel.h
//  ZXCCamera
//
//  Created by 周希财 on 2017/11/30.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZXCAlbumModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) id result;             

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) PHAsset *firstAsset;

@end
