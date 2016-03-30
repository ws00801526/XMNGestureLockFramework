Pod::Spec.new do |s|
  s.name         = "XMNGestureLockFramework"
  s.version      = "1.0.1"
  s.summary      = "仿支付宝解锁手势"
  s.description  = "模仿支付宝解锁手势,未用到图片,全部drawRect实现"
  s.homepage     = "https://github.com/ws00801526/XMNGestureLockFramework"
  s.license      = "MIT"
  s.author       = { "XMFraker" => "3057600441@qq.com" }  
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ws00801526/XMNGestureLockFramework.git", :tag => s.version }
  s.source_files = "XMNGestureLockFramework/**/*.{h,m}"
  s.ios.frameworks   = "UIKit", "Foundation"
  s.requires_arc = true
  s.resources = ["XMNGestureLockFramework/XMNGestureLockFramework.bundle","XMNGestureLockFramework/Controllers/XMNGestureLockInternalController.xib"]
end
