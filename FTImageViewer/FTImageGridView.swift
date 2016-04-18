//
//  FTImageGridView.swift
//  FTImageViewer
//
//  Created by liufengting on 15/12/16.
//  Copyright © 2015年 liufengting. All rights reserved.
//

import UIKit

private let FTImageGridViewImageMargin : CGFloat = 2.0
private let KCOLOR_BACKGROUND_WHITE = UIColor(red:241/255.0, green:241/255.0, blue:241/255.0, alpha:1.0)


class FTImageGridView: UIView{
    
    var FTImageGridViewTapBlock : ((buttonArray: [UIButton] , buttonIndex : NSInteger) ->())?
    var buttonArray : [UIButton] = []
    
    /**
     internal init frame imageArray tapBlock
     
     - parameter frame:        frame
     - parameter withImgArray: withImgArray
     - parameter tapBlock:     FTImageGridViewTapBlock
     
     - returns: FTImageGridView
     */
    internal init(frame : CGRect, imageArray : [String] , tapBlock : ((buttonsArray: [UIButton] , buttonIndex : NSInteger) ->())){
        super.init(frame: frame)

        FTImageGridViewTapBlock = tapBlock
        let imgHeight : CGFloat = (frame.size.width - FTImageGridViewImageMargin * 2) / 3
        for i in 0 ... imageArray.count-1 {
            let x = CGFloat(i % 3) * (imgHeight + FTImageGridViewImageMargin)
            let y = CGFloat(i / 3) * (imgHeight + FTImageGridViewImageMargin)
            let imageButton  = UIButton()
            imageButton.frame = CGRectMake(x, y, imgHeight, imgHeight)
            imageButton.backgroundColor = KCOLOR_BACKGROUND_WHITE
            imageButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            imageButton.sd_setImageWithURL(NSURL(string: imageArray[i]), forState: UIControlState.Normal)
            imageButton.tag = i
            imageButton.clipsToBounds = true
            imageButton.addTarget(self, action: #selector(FTImageGridView.onClickImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(imageButton)
            
            self.buttonArray.append(imageButton)
        }
        
    }
     
     /**
     get Height With Width
     
     - parameter width:    width
     - parameter imgCount: imgCount
     
     - returns: CGFloat Height
     */
    class func getHeightWithWidth(width: CGFloat, imgCount: Int) -> CGFloat{
        let imgHeight: CGFloat = (width - FTImageGridViewImageMargin * 2) / 3
        let photoAlbumHeight : CGFloat = imgHeight * CGFloat(ceilf(Float(imgCount / 3))) + FTImageGridViewImageMargin * CGFloat(ceilf(Float(imgCount / 3)-1))
        return photoAlbumHeight
        
    }

    /**
     onClickImage
     
     - parameter sender: UIButton
     */
    func onClickImage(sender: UIButton){
        FTImageGridViewTapBlock?(buttonArray: self.buttonArray , buttonIndex: sender.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
