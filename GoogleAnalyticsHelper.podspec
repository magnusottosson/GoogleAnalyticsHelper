Pod::Spec.new do |s|
  s.name             = "GoogleAnalyticsHelper"
  s.version          = "0.3.0"
  s.summary          = "A simple wrapper for the official Google Analytics lib."
  s.description      = <<-DESC
  A simple wrapper for the official Google Analytics lib. Write less code.
                       DESC

  s.homepage         = "https://github.com/permagnus/GoogleAnalyticsHelper"
  s.license          = 'MIT'
  s.author           = { "Magnus Ottosson" => "magnus@nixonnixon.se" }
  s.source           = { :git => "https://github.com/permagnus/GoogleAnalyticsHelper.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/permagnus'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'GAH/**/*'
  s.public_header_files = 'GAH/**/*.h'
  s.dependency 'Google/Analytics', '~> 1.0.0'
  s.dependency 'GBDeviceInfo', '~> 3.2.0'
end
