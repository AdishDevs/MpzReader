#
# Be sure to run `pod lib lint MpzReader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MpzReader'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MpzReader.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/mapalagama93/MpzReader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mapalagama93' => 'dev.hasitha@gmail.com' }
  s.source           = { :git => 'https://github.com/mapalagama93/MpzReader.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.xcconfig  = {'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'MpzReader/Classes/**/*'
  s.vendored_frameworks =  []
      
  s.resource_bundles = {
        'MpzReader' => ['MpzReader/Assets/**/*', 'MpzReader/Resources/**/*']
      }
  s.resources = ['MpzReader/Assets/**/*', 'MpzReader/Resources/**/*']
  # s.resource_bundles = {
  #   'MpzReader' => ['MpzReader/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SQLite.swift'
   s.dependency 'SwiftyJSON'
   s.dependency 'ZIPFoundation'
   s.dependency 'R2Shared'
   s.dependency 'R2Streamer'
   s.dependency 'R2Navigator'
   s.dependency 'CryptoSwift'
   s.dependency 'Fuzi'
   s.dependency 'Minizip'
   s.dependency 'Lightbox'
end
