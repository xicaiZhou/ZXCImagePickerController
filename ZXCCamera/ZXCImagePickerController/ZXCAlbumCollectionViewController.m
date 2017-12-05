//
//  UIAlbumCollectionViewController.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/12/4.
//  Copyright © 2017年 VIC. All rights reserved.
//
#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#import "ZXCAlbumCollectionViewController.h"
#import "ZXCAssetCell.h"
#import "ZXCPhotoViewController.h"

@interface ZXCAlbumCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZXCPhotoViewController *photoVC;
@property (nonatomic, strong) UIImageView *currentImage;
@property (nonatomic, assign) CGRect currentRect;

@end

@implementation ZXCAlbumCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navHeaderView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 -30, 30, 60, 20)];
    titleLabel.text = @"照片";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navHeaderView addSubview:titleLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kScreenWidth - 60, 25, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [navHeaderView addSubview:cancelBtn];
    
    UIButton *turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnBtn.frame = CGRectMake(0, 25, 70, 30);
    [turnBtn setImage:[UIImage imageNamed:@"images.bundle/返回"] forState:UIControlStateNormal];

    [turnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [turnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    turnBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    turnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    turnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);

    [turnBtn addTarget:self action:@selector(turnBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [navHeaderView addSubview:turnBtn];
    
    [self.view addSubview:navHeaderView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, kScreenWidth, 0.3)];
    label.backgroundColor = [UIColor lightGrayColor];
    
    [navHeaderView addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}
- (void)turnBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelBtn{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        //同一行相邻两个cell的最小间距
        layout.minimumInteritemSpacing = 5;
        //最小两行之间的间距
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ZXCAssetCell class] forCellWithReuseIdentifier:@"ZXCAssetCell"];
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXCAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXCAssetCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.asset = self.model.models[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 20) / 4, (kScreenWidth - 20) / 4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 0, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXCPhotoViewController *photo = [[ZXCPhotoViewController alloc] init];
    photo.asset = self.model.models[indexPath.row];
    [self.navigationController pushViewController:photo animated:YES];
    
    /* 这种方法先搁置（因为取到的图片不是高清原图）
    ZXCAssetCell *cell = (ZXCAssetCell *)[collectionView  cellForItemAtIndexPath:indexPath];
    self.photoVC = [[UIPhotoViewController alloc] init];
    self.photoVC.view.backgroundColor = [UIColor whiteColor];
    self.photoVC.view.alpha = 0;
    [self.view addSubview:self.photoVC.view];
    
    _currentImage = [[UIImageView alloc] init];
    _currentImage.image = cell.imageV.image;
    _currentImage.userInteractionEnabled = YES;
    
    CGRect rect = [_collectionView convertRect:cell.frame toView:_collectionView];
    _currentImage.frame = rect;
    _currentRect = rect;
    [self.photoVC.view addSubview:_currentImage];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [UIView animateWithDuration:0.5 animations:^{
        
        _currentImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
        
        self.photoVC.view.alpha = 1;
        cell.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
