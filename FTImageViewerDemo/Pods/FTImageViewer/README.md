# FTImageViewer


[![Twitter](https://img.shields.io/badge/twitter-@liufengting-blue.svg?style=flat)](http://twitter.com/liufengting) 
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/liufengting/FTImageViewer/master/LICENSE)
[![CI Status](http://img.shields.io/travis/liufengting/FTImageViewer.svg?style=flat)](https://travis-ci.org/liufengting/FTImageViewer)
[![GitHub stars](https://img.shields.io/github/stars/liufengting/FTImageViewer.svg)](https://github.com/liufengting/FTImageViewer/stargazers)

Preview images with just a few lines of code.     

I wrote this for my future projects. Feel free to try it in your own projects!


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


## License

FTImageViewer is available under the MIT license. See the LICENSE file for more info.

