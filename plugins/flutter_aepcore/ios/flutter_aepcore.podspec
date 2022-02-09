Pod::Spec.new do |s|
  s.name             = 'flutter_aepcore'
  s.version          = '0.0.1'
  s.summary          = 'Adobe Experience Platform support for Flutter apps.'
  s.homepage         = 'https://aep-sdks.gitbook.io/docs/'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Adobe Mobile SDK Team'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AEPCore', '~> 3.0'
  s.dependency 'AEPLifecycle', '~> 3.0'
  s.dependency 'AEPIdentity', '~> 3.0'
  s.dependency 'AEPSignal', '~> 3.0'
  s.platform = :ios, '10.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
