# CCBanner

[![CI Status](https://img.shields.io/travis/CaiChenghan/CCBanner.svg?style=flat)](https://travis-ci.org/CaiChenghan/CCBanner)
[![Version](https://img.shields.io/cocoapods/v/CCBanner.svg?style=flat)](https://cocoapods.org/pods/CCBanner)
[![License](https://img.shields.io/cocoapods/l/CCBanner.svg?style=flat)](https://cocoapods.org/pods/CCBanner)
[![Platform](https://img.shields.io/cocoapods/p/CCBanner.svg?style=flat)](https://cocoapods.org/pods/CCBanner)

基于**UICollectionView**实现的轮播控件，可**自定义**轮播内容，以及**重用机制**的使用。

## 安装

```ruby
pod 'CCBanner', '~> 1.0.0'
```
## 使用
##### 创建对象
```
- (CCBanner *)banner {
    if (_banner == nil) {
        _banner = [[CCBanner alloc]init];
        _banner.dataSource = self;
        _banner.delegate = self;
        [_banner registerClass:[BannerCell class] reuseIdentifier:@"BannerCell"];
    }
    return _banner;
}
```
##### 实现代理
```
- (NSInteger)numberOfItems {
    return 3;
}

- (__kindof UICollectionViewCell *)banner:(CCBanner *)banner itemAtIndex:(NSInteger)index {
    BannerCell *cell = [banner dequeueReusableItemWithIdentifier:@"BannerCell" forIndex:index];
    cell.data = [NSString stringWithFormat:@"%ld",index];
    return cell;
}

```



