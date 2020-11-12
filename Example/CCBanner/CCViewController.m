//
//  CCViewController.m
//  CCBanner
//
//  Created by 1178752402@qq.com on 11/12/2020.
//  Copyright (c) 2020 1178752402@qq.com. All rights reserved.
//

#import "CCViewController.h"
#import "BannerCell.h"
#import <CCBanner/CCBanner.h>
#import <CCBanner/CCPageControl.h>
#import <Masonry/Masonry.h>

@interface CCViewController ()<CCBannerDataSource,CCBannerDelegate>

@property (nonatomic, strong) CCBanner *banner;
@property (nonatomic, strong) CCPageControl *pageControl;

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.banner];
    [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(self.banner.mas_width).multipliedBy(1.0/3.0);
    }];
    
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.banner.mas_bottom).offset(30);
        make.height.mas_equalTo(5);
    }];
}

- (CCBanner *)banner {
    if (_banner == nil) {
        _banner = [[CCBanner alloc]init];
        _banner.dataSource = self;
        _banner.delegate = self;
        [_banner registerClass:[BannerCell class] reuseIdentifier:@"BannerCell"];
    }
    return _banner;
}

- (CCPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[CCPageControl alloc]init];
        _pageControl.backgroundColor = [UIColor yellowColor];
        _pageControl.numberOfPages = 3;
        _pageControl.indicatorColor = [UIColor blueColor];
        _pageControl.currentIndicatorColor = [UIColor redColor];
        _pageControl.currentIndicatorWidth = 20.0;
        _pageControl.indicatorCornerRadius = 2;
    }
    return _pageControl;
}

#pragma mark - CCBannerDataSource,CCBannerDelegate

- (NSInteger)numberOfItems {
    return 3;
}

- (__kindof UICollectionViewCell *)banner:(CCBanner *)banner itemAtIndex:(NSInteger)index {
    BannerCell *cell = [banner dequeueReusableItemWithIdentifier:@"BannerCell" forIndex:index];
    cell.data = [NSString stringWithFormat:@"%ld",index];
    return cell;
}

- (void)banner:(CCBanner *)banner didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击：%ld",index);
}

- (void)banner:(CCBanner *)banner didEndScroll:(NSInteger)index {
    NSLog(@"滚动：%ld",index);
    self.pageControl.currentPage = index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
