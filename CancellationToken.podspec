Pod::Spec.new do |s|
  s.name         = "CancellationToken"
  s.version      = "0.1.0"
  s.license      = "MIT"

  s.summary      = "CancellationToken in Swift"

  s.authors           = { "Tom Lokhorst" => "tom@lokhorst.eu" }
  s.social_media_url  = "https://twitter.com/tomlokhorst"
  s.homepage          = "https://github.com/tomlokhorst/swift-cancellationtoken"

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source          = { :git => "https://github.com/tomlokhorst/swift-cancellationtoken.git", :tag => s.version }
  s.requires_arc    = true
  s.source_files    = "src/CancellationToken"

end
