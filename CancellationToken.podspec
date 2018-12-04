Pod::Spec.new do |s|
  s.name         = "CancellationToken"
  s.version      = "3.1.0"
  s.license      = "MIT"

  s.summary      = "CancellationToken in Swift"

  s.authors           = { "Tom Lokhorst" => "tom@lokhorst.eu" }
  s.social_media_url  = "https://twitter.com/tomlokhorst"
  s.homepage          = "https://github.com/tomlokhorst/swift-cancellationtoken"

  s.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source          = { :git => "https://github.com/tomlokhorst/swift-cancellationtoken.git", :tag => s.version }
  s.requires_arc    = true
  s.default_subspec = "Core"
  s.swift_version   = '4.2'

  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/CancellationToken"
  end

  s.subspec "Alamofire" do |ss|
    ss.source_files = "extensions/CancellationTokenExtensions/Alamofire+Cancellation.swift"
    ss.dependency "CancellationToken/Core"
    ss.dependency "Alamofire", "~> 4.0"
  end

end
