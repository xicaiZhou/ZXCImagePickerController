//
//  BottomView.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/4.
//  Copyright © 2017年 VIC. All rights reserved.
//

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0
#import "BottomView.h"

@implementation BottomView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.7;
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        [left setImage:[UIImage imageNamed:@"images.bundle/leftTurn"] forState:UIControlStateNormal];
        
        left.frame = CGRectMake(20, 15, 30, 30);
        _left = left;
        [self addSubview:_left];
        UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
        [right setImage:[UIImage imageNamed:@"images.bundle/sure"] forState:UIControlStateNormal];
        
        right.frame = CGRectMake(kScreenWidth - 50, 15, 30, 30);
        _right = right;
        [self addSubview:_right];
    }
    return self;
}

@end
