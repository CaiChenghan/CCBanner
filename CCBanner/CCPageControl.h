//
//  CCPageControl.h
//  CCBanner
//
//  Created by CaiChenghan on 2020/11/5.
//  Copyright © 2020 1178752402@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPageControl : UIView

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *currentIndicatorColor;
@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat currentIndicatorWidth;
@property (nonatomic, assign) CGFloat indicatorSpace;
@property (nonatomic, assign) CGFloat indicatorCornerRadius;

@end

NS_ASSUME_NONNULL_END
