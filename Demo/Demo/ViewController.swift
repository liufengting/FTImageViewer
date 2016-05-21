//
//  ViewController.swift
//  FTImageViewer
//
//  Created by liufengting on 15/12/16.
//  Copyright © 2015年 liufengting. All rights reserved.
//

import UIKit
import FTImageViewer


//private let FTImageGridViewImageMargin : CGFloat = 2.0
//private let KCOLOR_BACKGROUND_WHITE = UIColor(red:241/255.0, green:241/255.0, blue:241/255.0, alpha:1.0)

class ViewController: UIViewController {
    
//    var buttonArray : [UIButton] = []
//
//    var imageUrlArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false;
        
        /**
         imageUrlArray
         */
        
        let imageUrlArray = ["http://ww2.sinaimg.cn/large/005vbOHfjw1f30qdgqacnj30g00qodiw.jpg",
                             "http://ww4.sinaimg.cn/large/4bf31e43jw1f2nvj4ojtvj20dv0ku7kt.jpg",
                             "http://ww3.sinaimg.cn/large/4bf31e43jw1f2nvja7amzj20dw0k3abu.jpg",
                             "http://ww2.sinaimg.cn/large/4bf31e43jw1f2nvjbjnutj20dw0kutas.jpg",
                             "http://ww1.sinaimg.cn/large/4bf31e43jw1f2nvjg4wdbj20hs0qodk7.jpg",
                             "http://ww3.sinaimg.cn/large/92f5c4f5gw1f2yxy7pan9j20eg0je765.jpg",
                             "http://ww1.sinaimg.cn/large/4bf31e43jw1f2nvk312l5j20zk0onjwb.jpg",
                             "http://ww1.sinaimg.cn/large/4bf31e43jw1f2nvkn1fqxj20dw0kuwgs.jpg",
                             "http://ww2.sinaimg.cn/large/005vbOHfjw1f2zxomlpycj30f00mijwo.jpg",
                             "http://ww4.sinaimg.cn/large/92f5c4f5gw1f2zxy66n15j20ku10i79g.jpg",
                             "http://ww4.sinaimg.cn/large/aa594a48gw1f2z0xvo4t9j20lc0rs40n.jpg",
                             "http://ww2.sinaimg.cn/large/aa594a48gw1f2xpgiy5tej20go0l9753.jpg"]
        
//        self.setupImageGrid(imageUrlArray)
        
        /**
         get image grid height
         
         NOTICE : This is inconvenice. does anyone have a better idea ? Please let me know !
         
         */
//        FTImageViewer.sharedInstance.showImages([], atIndex: 0 , fromSenderArray: [])
        let ft = FTImageViewer
        
        

        
        
        let height = FTImageGridView.getHeightWithWidth(self.view.bounds.width, imgCount: imageUrlArray.count)
        
        /**
         initializer with block
         */
        
        let imageGrid = FTImageGridView(frame: CGRectMake(0, 10, self.view.bounds.width, height), imageArray: imageUrlArray) { (buttonArray,buttonIndex) -> () in
            
            print(buttonIndex)
            
            FTImageViewer.sharedInstance.showImages(imageUrlArray, atIndex: buttonIndex , fromSenderArray: buttonArray)

            
        }
        
        self.view.addSubview(imageGrid);
        
    }
    
    
//    func setupImageGrid( imageArray : [String]) {
//        
////        FTImageGridViewTapBlock = tapBlock
//        let imgHeight : CGFloat = (self.view.frame.size.width - FTImageGridViewImageMargin * 2) / 3
//        for i in 0 ... imageArray.count-1 {
//            let x = CGFloat(i % 3) * (imgHeight + FTImageGridViewImageMargin)
//            let y = CGFloat(i / 3) * (imgHeight + FTImageGridViewImageMargin)
//            let imageButton  = UIButton()
//            imageButton.frame = CGRectMake(x, y, imgHeight, imgHeight)
//            imageButton.backgroundColor = KCOLOR_BACKGROUND_WHITE
//            imageButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
//            imageButton.sd_setImageWithURL(NSURL(string: imageArray[i]), forState: UIControlState.Normal)
//            imageButton.tag = i
//            imageButton.clipsToBounds = true
//            imageButton.addTarget(self, action: #selector(self.onClickImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            self.view.addSubview(imageButton)
//            
//            self.buttonArray.append(imageButton)
//        }
//
//    }
//    
//    func onClickImage(sender: UIButton){
////        FTImageGridViewTapBlock?(buttonArray: self.buttonArray , buttonIndex: sender.tag)
//        
//        FTImageViewer.sharedInstance.showImages(imageUrlArray, atIndex: sender.tag , fromSenderArray: buttonArray)
//
//        
//        
//    }

    
    
    
}

