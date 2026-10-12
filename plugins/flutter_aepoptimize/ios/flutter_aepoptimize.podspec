Pod::Spec.new do |s|
  s.name             = 'flutter_aepoptimize'
  s.version          = '5.1.0'
  s.summary          = 'Adobe Experience Platform Optimize extension for Flutter apps.'
  s.homepage         = 'https://developer.adobe.com/client-sdks'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'flutter_aepoptimize/Sources/flutter_aepoptimize/**/*.{h,m}'
  s.public_header_files = 'flutter_aepoptimize/Sources/flutter_aepoptimize/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPOptimize', '~> 5.0'
  s.platform = :ios, '12.0'
  s.static_framework = true
end
