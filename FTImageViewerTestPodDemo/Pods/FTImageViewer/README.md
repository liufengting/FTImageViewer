# FTImageViewer


[![Twitter](https://img.shields.io/badge/twitter-@liufengting-blue.svg?style=flat)](http://twitter.com/liufengting) 
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/liufengting/FTImageViewer/master/LICENSE)
[![Pods Versions](https://img.shields.io/cocoapods/v/FTImageViewer.svg?style=flat)](http://cocoapods.org/pods/FTImageViewer)
[![CI Status](http://img.shields.io/travis/liufengting/FTImageViewer.svg?style=flat)](https://travis-ci.org/liufengting/FTImageViewer)
[![Swift Version Compatibility](https://img.shields.io/badge/swift2-compatible-4BC51D.svg?style=flat-square)](https://developer.apple.com/swift)
[![swiftyness](https://img.shields.io/badge/pure-swift-ff3f26.svg?style=flat)](https://swift.org/)
[![Swift Version](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://swift.org)
[![GitHub stars](https://img.shields.io/github/stars/liufengting/FTImageViewer.svg)](https://github.com/liufengting/FTImageViewer/stargazers)





Preview images with just a few lines of code. I wrote this for my future projects. Feel free to try it in your own projects!


## ScreenShots

<table>
  <tr>
    <th><img src="/ScreenShots/Demo1.gif" width="250"/></th>
    <th><img src="/ScreenShots/Demo2.gif" width="250"/></th>
    <th><img src="/ScreenShots/Demo3.gif" width="250"/></th>
  </tr>
</table>

##Usage

* show images in  a grid

```swift
        let imageGrid = FTImageGridView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height), imageArray: imageUrlArray)
                        { (buttonArray,buttonIndex) -> () in
                                                    
        }
        self.view.addSubview(imageGrid);
```

* Preview images with one line of code

```swift
	FTImageViewer.sharedInstance.showImages(imageUrlArray, atIndex: buttonIndex , fromSenderArray: buttonArray)
```


##Installation

###Manually

* clone this repo.
* Simply drop the 'FTImageViewer' folder into your project.
* Enjoy！ 

###Cocoapods

* Not supported yet.  


# Bonus

In `FTImageViewerDemo`, shows you how to use it in tableview, using pure `AutoLayout`. Here is the screenshot:

![screenshot AutoLayout](/ScreenShots/autolayout.jpg)

# Asking for help

I am having trouble making `FTImageViewer` into Pod. If anyone see this, and if you have made swift Pods, please contact me and give me a hand. Much appreciated.

## License

FTImageViewer is available under the MIT license. See the LICENSE file for more info.

