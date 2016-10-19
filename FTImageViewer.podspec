
Pod::Spec.new do |s|

  s.name         = "FTImageViewer"
  s.version      = "1.8.2"
  s.summary      = "A simple ImageViewer and ImageGrid. Preview images with just a few lines of code."
  s.description  = <<-DESC
    FTImageViewer. A simple ImageViewer and ImageGrid. Can preview images with just a few lines of code.
    I wrote this for my future projects. Feel free to try it in your own projects!
                   DESC
  s.homepage     = "https://github.com/liufengting/FTImageViewer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "liufengting" => "wo157121900@me.com" }
  s.social_media_url   = "http://twitter.com/liufengting"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/liufengting/FTImageViewer.git", :tag => "#{s.version}" }
  s.source_files = "FTImageViewer/FTImageViewer/**/*.{h,swift}"
  s.resources = "FTImageViewer/FTImageViewer/**/*.{bundle}"
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.framework = "UIKit"
  s.dependency 'Kingfisher'

end
