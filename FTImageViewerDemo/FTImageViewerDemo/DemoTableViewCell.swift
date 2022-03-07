//
//  DemoTableViewCell.swift
//  FTImageViewerDemo
//
//  Created by LiuFengting on 2022/3/7.
//  Copyright © 2022年 <https://github.com/liufengting>. All rights reserved.
//

import UIKit
import FTImageViewer

class DemoTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageGridView: FTImageGridView!
    @IBOutlet weak var imageGridHeight: NSLayoutConstraint! // the height constrain for grid in stroyboard

    
    func setupWith(name: String, content: String, imageArray: [String]) {
        if imageArray.count > 0 {
            if let url = URL(string: imageArray[0]) {
                self.iconImageView.kf.setImage(with: url)
            }
        }

        nameLabel.text = name
        contentLabel.text = content
        
        let gridWidth = UIScreen.main.bounds.size.width - 56 - 8
        
        // get height for the image grid
        imageGridHeight.constant = FTImageGridView.getHeightWithWidth(gridWidth, imgCount: imageArray.count)
        
        // show images in grid
        imageGridView.showWithImageArray(imageArray) { (buttonsArray, buttonIndex) in
            // preview images with one line of code
            FTImageViewer.showImages(imageArray, atIndex: buttonIndex, fromSenderArray: buttonsArray)
        }
    }

}
