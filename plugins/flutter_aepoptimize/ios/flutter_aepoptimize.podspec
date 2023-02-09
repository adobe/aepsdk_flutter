#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_aepoptimize.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aepoptimize'
  s.version          = '1.0.0'
  s.summary          = 'Adobe Experience Platform Optimize extension for Flutter apps'
  s.homepage         = 'https://developer.adobe.com/client-sdks/documentation'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPOptimize', '~> 1.0'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
