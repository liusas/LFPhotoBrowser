//
//  CollectionViewCell.m
//  LFPhotoBrowser
//
//  Created by 刘峰 on 2018/12/12.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.imageView];
}

@end
