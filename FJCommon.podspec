#
# Be sure to run `pod lib lint FJCommon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FJCommon'
  s.version          = '0.1.0'
  s.summary          = '每个项目都应该有一个common的，因为总有一些代码需要被反复用到'
  s.description      = <<-DESC
Too lazy to write something down.
                       DESC
  s.homepage         = 'https://github.com/WalterCreazyBear/FJCommon'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'waltercreazybear' => '597370561@qq.com' }
  s.source           = { :git => 'https://github.com/WalterCreazyBear/FJCommon.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://github.com'
  s.ios.deployment_target = '9.0'
  # s.source_files = 'FJCommon/Classes/**/*'

  s.resource_bundles = {
    'FJCommon' => ['FJCommon/Resources/*']
  }
  
  s.subspec 'FJExtension' do |ext|
    ext.source_files = 'FJCommon/Classes/Extension/**/*'
  end

  s.subspec 'FJMacro' do |macro|
    macro.source_files = 'FJCommon/Classes/Macro/**/*'
  end

  s.subspec 'FJView' do |view|
    view.source_files = 'FJCommon/Classes/View/**/*'
  end

  s.subspec 'FJAll' do |all|
    all.source_files = 'FJCommon/Classes/**/*'
  end

  s.default_subspec = 'FJAll'
  
  s.test_spec 'FJTest' do |test_spec|
    test_spec.source_files = 'FJCommon/FJTest/**/*'
    test_spec.dependency 'OCMock'
  end  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
