Pod::Spec.new do |s|
  s.name         = "XMNGestureLockFramework"
  s.version      = "1.0.0"
  s.summary      = "仿支付宝解锁手势"
  s.description  = "模仿支付宝解锁手势,未用到图片,全部drawRect实现"
  s.homepage     = "https://github.com/ws00801526/XMChatBarExample"
  s.license      = "MIT"
  s.author       = { "XMFraker" => "3057600441@qq.com" }  
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ws00801526/XMChatBarExample.git", :tag => s.version }
  s.source_files = "XMChatBar/**/*.{h,m}"
  s.ios.frameworks   = "UIKit", "MapKit", "Foundation"
  s.requires_arc = true
  s.ios.vendored_library = 'XMChatBar/Vendors/VoiceLib/libmp3lame.a'
  s.resources = ["XMChatBar/chatBar.xcassets", "XMChatBar/face.plist"]
  s.dependency "Masonry"
end
