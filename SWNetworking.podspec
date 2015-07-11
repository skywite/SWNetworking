Pod::Spec.new do |s|
  s.name             = "SWNetworking"
  s.version          = "0.9"
  s.summary          = "Open Source Request handeling/managing on iOS"
  s.description      = "SWNetworking is a open-source and highly versatile multi-purpose frameworks. Clean code and sleek features make SkyWite an ideal choice. Powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use. Achieve your deadlines by using SkyWite. You will save Hundred hours. Start development using Skywite. Definitely you will be happy....! yeah.."
  s.homepage         = "https://github.com/skywite/SWNetworking"
  s.license          = 'MIT'
  s.author           = { "saman kumara" => "me@isamankumara.com" }
  s.source           = { :git => "https://github.com/skywite/SWNetworking.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'SWNetworking/SWNetworking.h'

  s.public_header_files = 'SWNetworking/*.h'
  
  s.source_files = 'SWNetworking/**/*'
  s.resource_bundles = {
    'SWReachability' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'SystemConfiguration'
end
