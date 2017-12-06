@version = "1.0.5"

Pod::Spec.new do |s|
  s.name          = "ZXCImagePickerController"
  s.version       = @version
  s.summary       = "自定义相册、自定义相机、自定义图片选择器"
  s.description   = "只需要四行代码，即可完成！抛弃UIImagePickerController！"
  s.homepage      = "https://github.com/xicaiZhou/ZXCImagePickerController"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "ZXC" => "zhouxicaijob@163.com" }
  s.ios.deployment_target   = "8.0"
  s.source        = { :git => "https://github.com/xicaiZhou/ZXCImagePickerController.git", :tag => "v#{s.version}" }
  s.resources    = "ZXCImagePickerController/*.{png,bundle}"
  s.source_files  = "ZXCImagePickerController/*.{h,m}"
  s.requires_arc  = true
  s.framework     = "UIKit","Photos"
end
