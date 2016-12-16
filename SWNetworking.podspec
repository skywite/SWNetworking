Pod::Spec.new do |s|
  s.name             = "SWNetworking"
  s.version          = "1.3"
  s.summary          = "Open Source Request handeling/managing on iOS snf OS X"
  s.description      = "SWNetworking is a open-source and highly versatile multi-purpose frameworks. Clean code and sleek features make SkyWite an ideal choice. Powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use. Achieve your deadlines by using SkyWite. You will save Hundred hours. Start development using Skywite. Definitely you will be happy....! yeah.."
  s.homepage         = "https://github.com/skywite/SWNetworking"
  s.license          = 'MIT'
  s.author           = { "saman kumara" => "me@isamankumara.com" }
  s.source           = { :git => "https://github.com/skywite/SWNetworking.git", :tag => s.version.to_s, :submodules => true }

  s.requires_arc = true
  s.ios.deployment_target = "7.0"
  s.tvos.deployment_target = '9.0'
  #s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'SWNetworking/SWNetworking.h'
  s.public_header_files = 'SWNetworking/*.h'
  
  s.subspec 'File' do |ss|
  	ss.source_files		= 'SWNetworking/File'
  end
  
  s.subspec 'ResponseType' do |ss|
  	ss.source_files		= 'SWNetworking/ResponseType'
    ss.dependency 'SWNetworking/File'
  end
  
  s.subspec 'Reachability' do |ss|
  	ss.source_files		= 'SWNetworking/Reachability'
  end
  
  s.subspec 'SWRequest' do |ss|
  	ss.source_files		= 'SWNetworking/SWRequest'
  	ss.dependency 'SWNetworking/ResponseType'
  	ss.dependency 'SWNetworking/File'
  	ss.dependency 'SWNetworking/Reachability'
  end

  s.subspec 'UIKit+SWNetworking' do |ss|
  	ss.source_files		= 'SWNetworking/UIKit+SWNetworking'
  	ss.dependency 'SWNetworking/SWRequest'
  	ss.dependency 'SWNetworking/ResponseType'

  end
  

  s.frameworks = 'SystemConfiguration'
end
