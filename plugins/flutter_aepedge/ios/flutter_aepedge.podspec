#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aepedge'
  s.version          = '5.1.0'
  s.summary          = 'Adobe Experience Platform Edge Network extension for Flutter apps.'
  s.homepage         = 'https://developer.adobe.com/client-sdks'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'flutter_aepedge/Sources/flutter_aepedge/**/*.{h,m}'
  s.public_header_files = 'flutter_aepedge/Sources/flutter_aepedge/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPEdge', '~> 5.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

end
