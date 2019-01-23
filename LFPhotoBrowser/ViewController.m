//
//  ViewController.m
//  PhotoBrowser
//
//  Created by 刘峰 on 17/6/6.
//  Copyright © 2018年 liufeng. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "YYWebImage.h"

#import "LFPhotoBrowser.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, LFPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空缓存" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)buttonClick {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"collectionCellID";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.item]] options:YYWebImageOptionProgressive];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LFPhotoBrowser *photoBrowser = [[LFPhotoBrowser alloc] init];
    [photoBrowser showByLastViewController:self currentImageIndex:indexPath.item];
}

#pragma mark - LFPhotoBrowserDelegate
- (NSInteger)numberOfPhotosInPhotoBrowser:(LFPhotoBrowser *)photoBrowser {
    return self.dataSource.count;
}

- (UIImage *)photoBrowser:(LFPhotoBrowser *)photoBrowser thumbnailImageIndex:(NSInteger)index {

    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];

    return cell.imageView.image;
}

- (NSString *)photoBrowser:(LFPhotoBrowser *)photoBrowser hightQualityUrlForIndex:(NSInteger)index {
    NSString *urlStr = [self.dataSource[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return urlStr;
}

- (UIImageView *)imageViewInPhotoBrowser:(LFPhotoBrowser *)photoBrowser withCurrentIndex:(NSInteger)index {
    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell.imageView;
}

#pragma mark - Getters
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[
                                                       @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                                                       @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                                                       @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                                                       @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                                                       @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                                                       @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                                                       @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                                                       @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                                                       @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg"
                                                       ]];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        flowLayout.minimumLineSpacing = 20.f;
        flowLayout.minimumInteritemSpacing = 10.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"collectionCellID"];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
