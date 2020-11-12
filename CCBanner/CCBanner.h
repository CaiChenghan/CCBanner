//
//  CCBanner.h
//  CCBanner
//
//  Created by CaiChenghan on 2020/10/31.
//  Copyright © 2020 1178752402@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CCBannerDataSource;
@protocol CCBannerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface CCBanner : UIView

@property (nonatomic, weak) id<CCBannerDataSource> dataSource;
@property (nonatomic, weak) id<CCBannerDelegate> delegate;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSTimeInterval scrollTime;

- (void)reloadData;
- (void)registerClass:(nullable Class)itemClass reuseIdentifier:(NSString *)identifier;
- (__kindof UICollectionViewCell *)dequeueReusableItemWithIdentifier:(nullable NSString *)reuseIdentifier forIndex:(NSInteger)index;

@end


@protocol CCBannerDataSource <NSObject>

/// banner页面数
- (NSInteger)numberOfItems;

/// banner页面
/// @param index 页面索引
- (__kindof UICollectionViewCell *)banner:(CCBanner *)banner itemAtIndex:(NSInteger)index;

@end


@protocol CCBannerDelegate <NSObject>

@optional

- (void)banner:(CCBanner *)banner didSelectItemAtIndex:(NSInteger)index;
- (void)banner:(CCBanner *)banner didEndScroll:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
