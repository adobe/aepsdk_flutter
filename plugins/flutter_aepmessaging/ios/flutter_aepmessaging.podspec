#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_aepmessaging.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aepmessaging'
  s.version          = '3.0.0.beta.1'
  s.summary          = 'Adobe Experience Platform Messaging extension for Flutter apps'
  s.homepage         = 'https://developer.adobe.com/client-sdks/documentation'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPMessaging', '~> 4.0'
  s.dependency 'AEPCore', '~> 4.0'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end