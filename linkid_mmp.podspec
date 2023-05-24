#
# Be sure to run `pod lib lint linkid_mmp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'linkid_mmp'
  s.version          = '1.0.2'
  s.summary          = 'LinkId Mobile Marketing Platform.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/leonacky/linkid_mmp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tuan Dinh' => 'leonacky@gmail.com' }
  s.source           = { :git => 'https://github.com/leonacky/linkid_mmp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'linkid_mmp/Classes/**/*'
  
  # s.resource_bundles = {
  #   'linkid_mmp' => ['linkid_mmp/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
#  s.dependency 'SQLite.swift', '~> 0.14.0'
#  s.dependency 'KeychainSwift', '~> 20.0'
#  s.dependency 'CryptoSwift', '~> 1.3.3'
  
  s.dependency 'GRDB.swift', '~> 4.14.0'
  s.preserve_paths = 'CryptoSwift.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework CryptoSwift' }
  s.vendored_frameworks = 'CryptoSwift.xcframework'
  
end


