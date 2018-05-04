#
# Be sure to run `pod lib lint HZYFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HZYNetwork'
  s.version          = '1.0.0'
  s.summary          = '基于AFNetworking的网络库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  					基于AFNetworking的网络库，面向对象的网络请求
                       DESC

  s.homepage         = 'https://github.com/timehzy/HZYNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '郝振壹' => 'yiliforever@qq.com' }
  s.source           = { :git => 'https://github.com/timehzy/HZYNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  # s.resource_bundles = {
  #   'HZYFoundation' => ['HZYFoundation/Assets/**/*.png']
  # }
  s.source_files = 'HZYNetwork/'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'

  
end
