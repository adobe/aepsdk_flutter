#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aepedgeidentity'
  s.version          = '1.0.0'
  s.summary          = 'Adobe Experience Platform Identity for Edge Network extension for Adobe Experience Platform Mobile SDK. Written and maintained by Adobe.'
  s.homepage         = 'https://aep-sdks.gitbook.io/docs/'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPEdgeIdentity', '~> 1.0'
  s.platform = :ios, '10.0'
  s.static_framework = true

end
