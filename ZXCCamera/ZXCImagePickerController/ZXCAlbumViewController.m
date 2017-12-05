//
//  UIAlbumViewController.m
//  ZXCCamera
//
//  Created by 周希财 on 2017/11/30.
//  Copyright © 2017年 VIC. All rights reserved.
//
#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0
#import "ZXCAlbumViewController.h"
#import "ZXCImageManager.h"
#import "ZXCAlbumCell.h"
#import "ZXCAlbumCollectionViewController.h"
@interface ZXCAlbumViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *albumArr;

@end

@implementation ZXCAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UIView *navHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navHeaderView.backgroundColor = [UIColor clearColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 -30, 30, 60, 20)];
    titleLabel.text = @"相册";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navHeaderView addSubview:titleLabel];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kScreenWidth - 60, 30, 40, 20);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [navHeaderView addSubview:cancelBtn];
    
    [self.view addSubview:navHeaderView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, kScreenWidth, 0.3)];
    label.backgroundColor = [UIColor lightGrayColor];
    
    [navHeaderView addSubview:label];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self data];
}


- (void)cancelBtn{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)data{
    
    [[ZXCImageManager manager] loadAlbumInfoWithCompletionBlock:^(NSArray *array) {
        _albumArr = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[ZXCAlbumCell class] forCellReuseIdentifier:@"ZXCAlbumCell"];
    }
    return _tableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albumArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXCAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCAlbumCell"];
    cell.model = _albumArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXCAlbumCollectionViewController *vc = [[ZXCAlbumCollectionViewController alloc] init];
    vc.model =_albumArr[indexPath.row];

    [self.navigationController pushViewController:vc animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
