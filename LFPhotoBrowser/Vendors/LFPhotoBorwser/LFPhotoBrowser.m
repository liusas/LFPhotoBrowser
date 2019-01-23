//
//  LFPhotoBrowser.m
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/12.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "LFPhotoBrowser.h"
#import "LFPhotoBrowserConfig.h"
#import "LFPhotoBrowserCell.h"
#import "LFTransitionAnimation.h"

@interface LFPhotoBrowser () <UICollectionViewDelegate, UICollectionViewDataSource, LFPhotoBrowserCellDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;/**< 图片浏览器容器*/
@property (nonatomic, assign) NSInteger currentIndex;/**< 图片浏览器当前索引*/
@property (nonatomic, strong) LFTransitionAnimation *transitionAnimation;

@end

static NSString * const reuseIdentifier = @"LFPhotoBrowserCell";

@implementation LFPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    if (currentIndexPath != nil) {
        [self.collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
        //执行
        [self.collectionView layoutIfNeeded];
    }
}

- (void)showByLastViewController:(nonnull UIViewController *)viewController currentImageIndex:(NSInteger)index {
    self.currentIndex = index;
    self.delegate = (id<LFPhotoBrowserDelegate>)viewController;
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    viewController.definesPresentationContext = YES;
    [viewController presentViewController:self animated:YES completion:nil];
}

- (UIImageView *)imageViewInPhotoBrowser {
    LFPhotoBrowserCell *cell = (LFPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    return cell.imageView;
}

- (UIImageView *)imageViewBeforePresent {
    return [self.delegate imageViewInPhotoBrowser:self withCurrentIndex:self.currentIndex];
}

//隐藏该页面导航栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIViewControllerTransitionDelegate 过场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transitionAnimation.transitionType = LFTransitionPresent;
    return self.transitionAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionAnimation.transitionType = LFTransitionDismiss;
    return self.transitionAnimation;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfPhotosInPhotoBrowser:self];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setImageWithUrl:[NSURL URLWithString:[self.delegate photoBrowser:self hightQualityUrlForIndex:indexPath.item]] placeholderImage:[self.delegate photoBrowser:self thumbnailImageIndex:indexPath.item]];
    cell.delegate = self;
    return cell;
}

#pragma mark - LFPhotoBrowserCellDelegate
- (void)photoBrowserCellDismiss:(UICollectionViewCell *)cell {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowserCell:(UICollectionViewCell *)cell longPress:(UILongPressGestureRecognizer *)longPressGR {
}

- (void)photoBrowserCell:(UICollectionViewCell *)cell panGesture:(UIPanGestureRecognizer *)panGR {
}

- (void)photoBrowserCell:(UICollectionViewCell *)cell panScale:(CGFloat)scale {
    self.view.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:scale*scale];
}

#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds)+PhotoBrowserImageViewMargin, CGRectGetHeight(self.view.bounds));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)+PhotoBrowserImageViewMargin, CGRectGetHeight(self.view.bounds)) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[LFPhotoBrowserCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (LFTransitionAnimation *)transitionAnimation {
    if (!_transitionAnimation) {
        _transitionAnimation = [[LFTransitionAnimation alloc] init];
    }
    return _transitionAnimation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
