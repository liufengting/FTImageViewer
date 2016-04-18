//
//  ViewController.swift
//  FTImageViewer
//
//  Created by liufengting on 15/12/16.
//  Copyright © 2015年 liufengting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         imageUrlArray
         */
        
        let imageUrlArray = ["http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1489.jpg",
        "http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1489.jpg",
        "http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1489.jpg",
        "http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1334.jpg","http://tu.66vod.net/2015/1489.jpg"]
        
        /**
         get image grid height 
         
         NOTICE : This is inconvenice. does anyone have a better idea ? Please let me know !
         
         */

        let height = FTImageGridView.getHeightWithWidth(self.view.bounds.width, imgCount: imageUrlArray.count)
        
        /**
         initializer with block
         */

        let imageGrid = FTImageGridView(frame: CGRectMake(0, 20, self.view.bounds.width, height), imageArray: imageUrlArray)
                        { (buttonArray,buttonIndex) -> () in
                            
                            print(buttonIndex)
            
                            FTImageViewer.sharedInstance.showImages(imageUrlArray, atIndex: buttonIndex , fromSenderArray: buttonArray)
            

        }
        
        self.view.addSubview(imageGrid);
        
    }

    


}

