#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aepedge'
  s.version          = '3.0.0'
  s.summary          = 'Adobe Experience Platform Edge Network extension for Flutter apps.'
  s.homepage         = 'https://developer.adobe.com/client-sdks'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPEdge', '~> 4.0'
  s.platform = :ios, '11.0'
  s.static_framework = true

end
