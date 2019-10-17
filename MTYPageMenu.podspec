Pod::Spec.new do |s|
  s.name         = 'MTYPageMenu'
  s.summary      = 'Managing pages like ByteDance TouTiao App.'
  s.version      = '1.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'menttofly' => '1028365614@qq.com' }
  s.homepage     = 'https://github.com/menttofly/MTYPageMenu'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/menttofly/MTYPageMenu.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.source_files = 'MTYPageMenu/*.{h,m}'
  s.public_header_files = 'MTYPageMenu/*.{h}'

  s.subspec 'MTYUtils' do |ss|
    ss.source_files = 'MTYPageMenu/MTYUtils/*.{h,m}'
    ss.public_header_files = 'MTYPageMenu/MTYUtils/*.{h}'
  end

end

