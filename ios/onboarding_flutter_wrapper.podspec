#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint onboarding_flutter_wrapper.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'onboarding_flutter_wrapper'
  s.version          = '3.1.0'
  s.summary          = 'Incode Flutter SDK.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://incode.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Incode Technologies, Inc.' => 'office@incode.com' }
  s.source           = { :path => '.' }
  s.source_files = "Classes/**/*.{h,m,mm,swift}"
  s.platform = :ios, '13.0'
  s.libraries = 'c++'
  s.swift_version = '5.0'
  s.static_framework = true
  s.resource = 'Frameworks/IncdOnboarding.bundle'
  s.vendored_frameworks = 'Frameworks/IncdOnboarding.xcframework', 'Frameworks/opencv2.xcframework'
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', # Flutter.framework does not contain a i386 slice.
    'SWIFT_INCLUDE_PATHS' => '"${PODS_XCFRAMEWORKS_BUILD_DIR}/onboarding_flutter_wrapper"' }
  s.dependency 'Flutter'
end
