//
//  DemoTableViewCell.swift
//  FTImageViewerDemo
//
//  Created by liufengting on 16/5/23.
//  Copyright © 2016年 <https://github.com/liufengting>. All rights reserved.
//

import UIKit
import FTImageViewer

class DemoTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageGridView: FTImageGridView!
    @IBOutlet weak var imageGridHeight: NSLayoutConstraint! // the height constrain for grid in stroyboard
    
    var imageArray : [String] = [] {
        didSet {

            
            self.setNeedsLayout()
        }
    }
    
    func setupWith(name: String, content: String, imageArray: [String]) {
        nameLabel.text = name
        contentLabel.text = content
        self.imageArray = imageArray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // set width for the image grid
        // 56 is the leading constraint for the grid in storyboard
        // 8 is the trailing constraint for the grid in storyboard
        // or set the width to a certain value in storyboard and leave the calculation to `FTImageGridView`
        let gridWidth = UIScreen.main.bounds.size.width - 56 - 8
        
        // get height for the image grid
        imageGridHeight.constant = FTImageGridView.getHeightWithWidth(gridWidth, imgCount: imageArray.count)
        
        // show images in grid
        imageGridView.showWithImageArray(imageArray) { (buttonsArray, buttonIndex) in
            // preview images with one line of code
            FTImageViewer.showImages(self.imageArray, atIndex: buttonIndex, fromSenderArray: buttonsArray)
        }
    }
    
    var name : String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    var content : String = "" {
        didSet {
            contentLabel.text = content
        }
    }
    

}
