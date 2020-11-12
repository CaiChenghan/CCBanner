#
# Be sure to run `pod lib lint CCBanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CCBanner'
  s.version          = '1.0.0'
  s.summary          = '轮播控件，可自定义轮播内容。'
  s.homepage         = 'https://github.com/CaiChenghan/CCBanner'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CaiChenghan' => '1178752402@qq.com' }
  s.source           = { :git => 'https://github.com/CaiChenghan/CCBanner.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'CCBanner/*.{h,m}'
end
