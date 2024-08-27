#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'libphonenumber'
  s.version          = '0.0.1'
  s.summary          = 'Simple implementation of libphonenumber'
  s.description      = <<-DESC
Simple implementation of libphonenumber
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'libPhoneNumber-iOS', '0.9.9'
  
  s.ios.deployment_target = '8.0'
end

