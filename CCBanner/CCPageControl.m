//
//  CCPageControl.m
//  CCBanner
//
//  Created by CaiChenghan on 2020/11/5.
//  Copyright © 2020 1178752402@qq.com. All rights reserved.
//

#import "CCPageControl.h"

@interface CCPageControlItem : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *itemView;

@end

@interface CCPageControlItem ()

@property (nonatomic, strong, readwrite) UIImageView *itemView;

@end

@implementation CCPageControlItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.itemView];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.itemView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.itemView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.itemView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return self;
}

- (UIImageView *)itemView {
    if (_itemView == nil) {
        _itemView = [[UIImageView alloc]init];
        _itemView.backgroundColor = [UIColor whiteColor];
        _itemView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _itemView;
}

@end



@interface CCPageControl ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation CCPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfPages = _currentPage = 0;
        _currentIndicatorColor = _indicatorColor = [UIColor whiteColor];
        _currentIndicatorWidth = _indicatorWidth = 13.0;
        _indicatorSpace = 3.0;
        _indicatorCornerRadius = 0;
        [self addSubview:self.collectionView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self.collectionView addConstraint:self.widthConstraint];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[CCPageControlItem class] forCellWithReuseIdentifier:@"CCPageControlItem"];
    }
    return _collectionView;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self resetPageControlWidth];
    [self.collectionView reloadData];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.collectionView reloadData];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    [self.collectionView reloadData];
}

- (void)setCurrentIndicatorColor:(UIColor *)currentIndicatorColor {
    _currentIndicatorColor = currentIndicatorColor;
    [self.collectionView reloadData];
}

- (void)setIndicatorWidth:(CGFloat)indicatorWidth {
    _indicatorWidth = indicatorWidth;
    [self resetPageControlWidth];
    [self.collectionView reloadData];
}

- (void)setCurrentIndicatorWidth:(CGFloat)currentIndicatorWidth {
    _currentIndicatorWidth = currentIndicatorWidth;
    [self resetPageControlWidth];
    [self.collectionView reloadData];
}

- (void)setIndicatorSpace:(CGFloat)indicatorSpace {
    _indicatorSpace = indicatorSpace;
    [self resetPageControlWidth];
    [self.collectionView reloadData];
}

- (void)resetPageControlWidth {
    self.widthConstraint.constant = MAX(self.numberOfPages - 1, 0)*(self.indicatorWidth + self.indicatorSpace) + self.currentIndicatorWidth;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfPages;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCPageControlItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCPageControlItem" forIndexPath:indexPath];
    if (indexPath.row == self.currentPage) {
        cell.itemView.backgroundColor = self.currentIndicatorColor;
    } else {
        cell.itemView.backgroundColor = self.indicatorColor;
    }
    cell.itemView.layer.cornerRadius = self.indicatorCornerRadius;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.currentPage) {
        return CGSizeMake(self.currentIndicatorWidth, collectionView.bounds.size.height);
    } else {
        return CGSizeMake(self.indicatorWidth, collectionView.bounds.size.height);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (self.indicatorWidth == self.currentIndicatorWidth) ? self.indicatorSpace : 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (self.indicatorWidth == self.currentIndicatorWidth) ? 0 : self.indicatorSpace;
}

@end
