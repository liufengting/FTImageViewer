Pod::Spec.new do |s|

  s.name         = "FTImageViewer"
  s.version      = "2.0.8"
  s.summary      = "A simple ImageViewer and ImageGrid. Preview images with just a few lines of code."
  s.description  = <<-DESC
    FTImageViewer. A simple ImageViewer and ImageGrid. Can preview images with just a few lines of code.
    I wrote this for my future projects. Feel free to try it in your own projects!
                   DESC
  s.homepage     = "https://github.com/liufengting/FTImageViewer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "liufengting" => "wo157121900@me.com" }
  s.platform     = :ios, "13.0"
  s.source       = { :git => "https://github.com/liufengting/FTImageViewer.git", :tag => "#{s.version}" }
  s.source_files = "FTImageViewer", "FTImageViewer/*.{h,m,swift,xib}"
  s.resources    = "FTImageViewer/*.{bundle}"
  s.requires_arc = true
  s.framework    = "UIKit"
  s.swift_versions = '5.0'
  s.dependency 'Kingfisher'

end
