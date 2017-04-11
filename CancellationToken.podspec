Pod::Spec.new do |s|
  s.name         = "CancellationToken"
  s.version      = "1.0.1"
  s.license      = "MIT"

  s.summary      = "CancellationToken in Swift"

  s.authors           = { "Tom Lokhorst" => "tom@lokhorst.eu" }
  s.social_media_url  = "https://twitter.com/tomlokhorst"
  s.homepage          = "https://github.com/tomlokhorst/swift-cancellationtoken"

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'
  s.watchos.deployment_target = '2.0'

  s.source          = { :git => "https://github.com/tomlokhorst/swift-cancellationtoken.git", :tag => s.version }
  s.requires_arc    = true
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "src/CancellationToken"
  end

  s.subspec "Alamofire" do |ss|
    ss.source_files = "extensions/CancellationTokenExtensions/Alamofire+Cancellation.swift"
    ss.dependency "CancellationToken/Core"
    ss.dependency "Alamofire", "~> 4.0"
  end

end
