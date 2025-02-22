Pod::Spec.new do |s|
  s.name             = 'flutter_aepcore'
  s.version          = '5.0.0'
  s.summary          = 'Adobe Experience Platform support for Flutter apps.'
  s.homepage         = 'https://developer.adobe.com/client-sdks'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPCore', '>= 5.4.0', '< 6.0.0'
s.dependency 'AEPLifecycle', '>= 5.4.0', '< 6.0.0'
s.dependency 'AEPIdentity', '>= 5.4.0', '< 6.0.0'
s.dependency 'AEPSignal', '>= 5.4.0', '< 6.0.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
