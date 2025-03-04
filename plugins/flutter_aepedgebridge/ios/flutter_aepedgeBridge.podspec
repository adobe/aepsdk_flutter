Pod::Spec.new do |s|
  s.name             = 'flutter_aepedgebridge'
  s.version          = '5.0.0'
  s.summary          = 'Adobe Experience Platform Edge Bridge support for Flutter apps.'
  s.homepage         = 'https://developer.adobe.com/client-sdks'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPEdgeBridge', '~> 5.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

end
