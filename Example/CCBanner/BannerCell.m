//
//  BannerCell.m
//  CCBanner_Example
//
//  Created by 蔡成汉 on 2020/11/12.
//  Copyright © 2020 1178752402@qq.com. All rights reserved.
//

#import "BannerCell.h"
#import <Masonry/Masonry.h>

@interface BannerCell ()

@property (nonatomic, strong) UILabel *textLab;

@end

@implementation BannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialView];
        [self makeConstraints];
    }
    return self;
}

- (void)initialView {
    [self.contentView addSubview:self.textLab];
}

- (void)makeConstraints {
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setData:(NSString *)data {
    _data = data;
    self.textLab.text = data;
}

- (UILabel *)textLab {
    if (_textLab == nil) {
        _textLab = [[UILabel alloc]init];
        _textLab.textColor = [UIColor blackColor];
        _textLab.textAlignment = NSTextAlignmentCenter;
        _textLab.font = [UIFont boldSystemFontOfSize:40];
        _textLab.layer.borderWidth = 1.0;
        _textLab.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _textLab;
}

@end
