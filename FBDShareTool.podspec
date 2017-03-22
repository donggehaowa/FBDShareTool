
Pod::Spec.new do |s|
  s.name         = "FBDShareTool"
  s.version      = "0.2.3"
  s.summary      = "FBDShareTool 是自定义Share 分享的UI界面 以后还要基于友盟分享的ShareCore进行分享的扩展 "
  s.homepage     = "https://github.com/donggehaowa/FBDShareTool"
  s.license      = "MIT"
  s.author             = { "feng" => "601291766@qq.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/donggehaowa/FBDShareTool.git", :tag => "#{s.version}" }
  s.source_files  = "FBDShareCustomView", "FBDShareCustomView/*.{h,m}"
  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

   s.resource  = "Resources/*.png"
   s.requires_arc = true

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

    s.framework  = "UIKit"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
   s.dependency "UMengUShare/Social/Sina"
   s.dependency "UMengUShare/Social/WeChat"
   s.dependency "UMengUShare/Social/QQ"
end
