//
//  CCBanner.m
//  CCBanner
//
//  Created by CaiChenghan on 2020/10/31.
//  Copyright © 2020 1178752402@qq.com. All rights reserved.
//

#import "CCBanner.h"

@interface CCBanner ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CCBanner

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        _scrollTime = 4;
        _autoScroll = YES;
        [self addSubview:self.collectionView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return self;
}

- (void)resetTotalItems {
    if ([self.dataSource respondsToSelector:@selector(numberOfItems)]) {
        self.totalItems = [self.dataSource numberOfItems] + 2;
    } else {
        self.totalItems = 0;
    }
}

- (void)setScrollTime:(NSTimeInterval)scrollTime {
    _scrollTime = scrollTime;
    [self reloadData];
}

- (void)reloadData {
    [self resetTotalItems];
    [self startTimer];
    [self.collectionView reloadData];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.collectionView.contentOffset = CGPointMake(self.bounds.size.width*MIN(MAX((self.currentIndex + 1), 1), MAX(self.totalItems - 2, 1)), 0);
    });
}

- (void)registerClass:(nullable Class)itemClass reuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:itemClass forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableItemWithIdentifier:(nullable NSString *)reuseIdentifier forIndex:(NSInteger)index {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

/// 计时器开始
- (void)startTimer {
    [self stopTimer];
    if (self.scrollTime > 0 && self.totalItems > 0 && self.autoScroll) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTime target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
    }
}

/// 计时器停止
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/// 计时器任务
- (void)timerTask {
    [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width + self.collectionView.contentOffset.x, 0) animated:YES];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self didMoved];
}

- (void)didMoved {
    if (self.superview) {
        [self reloadData];
    } else {
        [self stopTimer];
    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.totalItems > 2) {
        return self.totalItems;
    } else {
        return 0;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger index = indexPath.row - 1;
    if (index < 0) {
        index = self.totalItems - 3;
    }
    if (index > self.totalItems - 3) {
        index = 0;
    }
    indexPath = [NSIndexPath indexPathForRow:MAX(index, 0) inSection:0];
    return [self.dataSource banner:self itemAtIndex:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:MAX(indexPath.row - 1, 0)];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self resetContentOffset:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetContentOffset:scrollView];
}

- (void)resetContentOffset:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= (scrollView.bounds.size.width * (self.totalItems - 1))) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width * (self.totalItems - 2), 0);
    }
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.currentIndex = MAX(index - 1, 0);
    if (self.delegate && [self.delegate respondsToSelector:@selector(banner:didEndScroll:)]) {
        [self.delegate banner:self didEndScroll:self.currentIndex];
    }
}

@end
