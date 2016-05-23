//
//  DemoTableViewCell.swift
//  FTImageViewerDemo
//
//  Created by liufengting on 16/5/23.
//  Copyright © 2016年 liufengting. All rights reserved.
//

import UIKit

class DemoTableViewCell: UITableViewCell {


    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageGridView: FTImageGridView!
    @IBOutlet weak var imageGridHeight: NSLayoutConstraint!
    
    var imageArray : [String] = []{

        didSet {
            
            imageGridHeight.constant = FTImageGridView.getHeightWithWidth(UIScreen.mainScreen().bounds.size.width - 56 - 8, imgCount: imageArray.count)
            self.setNeedsLayout()
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageGridView.showWithImageArray(imageArray) { (buttonsArray, buttonIndex) in
            
            FTImageViewer.sharedInstance.showImages(self.imageArray, atIndex: buttonIndex, fromSenderArray: buttonsArray)
            
        }
        
    }
    

}
