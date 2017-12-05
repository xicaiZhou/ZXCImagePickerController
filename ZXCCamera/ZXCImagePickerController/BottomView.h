//
//  BottomView.h
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/4.
//  Copyright © 2017年 VIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TurnBlock)();
typedef void(^SavePhotoBlock)();

@interface BottomView : UIView
@property (nonatomic, copy) SavePhotoBlock block;
@property (nonatomic, copy) TurnBlock turnblock;

@end
