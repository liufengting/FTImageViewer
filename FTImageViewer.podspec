
Pod::Spec.new do |s|

  s.name         = "FTImageViewer"
  s.version      = "0.0.1"
  s.summary      = "A simple ImageViewer and ImageGrid. Preview images with just a few lines of code."
  s.description  = <<-DESC
    FTImageViewer. A simple ImageViewer and ImageGrid. Can preview images with just a few lines of code.
    I wrote this for my future projects. Feel free to try it in your own projects!
                   DESC
  s.homepage     = "https://github.com/liufengting/FTImageViewer"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "liufengting" => "wo157121900@me.com" }
  s.social_media_url   = "http://twitter.com/liufengting"
  s.platform     = :ios

  s.source       = { :git => "https://github.com/liufengting/FTImageViewer.git", :tag => "0.0.1" }
  s.source_files  = "FTImageViewer", "FTImageViewer/*.{swift}"
  s.resources = "FTImageViewer/ImageAssets.bundle/*.png"
  s.requires_arc = true
  s.dependency "SDWebImage", "~> 3.7.3"

end
