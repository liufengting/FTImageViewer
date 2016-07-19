//
//  FTImageViewer.swift
//  FTImageViewer
//
//  Created by liufengting on 15/12/17.
//  Copyright © 2015年 liufengting. All rights reserved.
//

import UIKit
import SDWebImage


//MARK: - Marcros -

private let FTImageViewerAnimationDuriation : NSTimeInterval =  0.3
private let FTImageViewerScreenWidth =  UIScreen.mainScreen().bounds.width
private let FTImageViewerScreenHeight =  UIScreen.mainScreen().bounds.height
private let FTImageViewerBackgroundColor =  UIColor.blackColor()
private let FTImageViewBarBackgroundColor =  UIColor.blackColor().colorWithAlphaComponent(0.3)
private let FTImageViewBarHeight : CGFloat =  40.0
private let FTImageViewBarButtonWidth : CGFloat =  30.0
private let FTImageViewBarDefaultMargin : CGFloat =  5.0
private let FTImageGridViewImageMargin : CGFloat = 2.0
private let KCOLOR_BACKGROUND_WHITE = UIColor(red:241/255.0, green:241/255.0, blue:241/255.0, alpha:1.0)



//MARK: - FTImageViewer -

public class FTImageViewer: NSObject , UIScrollViewDelegate,UIGestureRecognizerDelegate{

    var backgroundView: UIView!
    var scrollView: UIScrollView!
    var tabBar: FTImageViewBar!
    var beginAnimationView: UIImageView!
    var fromRect: CGRect!
    var fromIndex: NSInteger = 0
    var imageUrlArray: [String]!
    var fromSenderRectArray: [CGRect] = []
    var isPanRecognize: Bool = false


    //MARK: - sharedInstance -

    public class var sharedInstance : FTImageViewer {
        struct Static {
            static let instance : FTImageViewer = FTImageViewer()
        }
        return Static.instance
    }
    
//    internal static let sharedInstance: FTImageViewer = {
//        return FTImageViewer()
//    }()
    
    
    //MARK: - showImages -

    /**
     showImages
     
     - parameter images:          images
     - parameter atIndex:         atIndex
     - parameter fromSenderArray: fromSenderArray
     */
    
    public func showImages(images : [String] , atIndex : NSInteger , fromSenderArray: [UIView]){
        
        fromSenderRectArray = []
        
        for i in 0 ... fromSenderArray.count-1 {
            let rect : CGRect = fromSenderArray[i].superview!.convertRect(fromSenderArray[i].frame, toView:UIApplication.sharedApplication().keyWindow)
            fromSenderRectArray.append(rect)
        }
        
        

        
        fromIndex = atIndex
        imageUrlArray = images
        fromRect = fromSenderRectArray[atIndex]

        
        if backgroundView == nil {
            backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
        }
        backgroundView.backgroundColor = FTImageViewerBackgroundColor
        UIApplication.sharedApplication().keyWindow?.addSubview(backgroundView);

        
        beginAnimationView = UIImageView(frame : fromRect)
        beginAnimationView.sd_setImageWithURL(NSURL(string: images[atIndex]))
        beginAnimationView.clipsToBounds = true
        beginAnimationView.userInteractionEnabled = false
        beginAnimationView.contentMode = UIViewContentMode.ScaleAspectFit
        beginAnimationView.backgroundColor = UIColor.clearColor();
        backgroundView.addSubview(beginAnimationView)
        
        UIView.animateWithDuration(FTImageViewerAnimationDuriation,
            animations: { () -> Void in
                self.beginAnimationView.layer.frame = UIScreen.mainScreen().bounds;
            }) { (finished) -> Void in
                if (finished == true){
                    self.setupView()
                }
        }
    }

    //MARK: - setupView -

    private func setupView(){
        if (scrollView == nil){
            
            scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
            scrollView.backgroundColor = UIColor.clearColor()
            scrollView.pagingEnabled = true
            scrollView.alpha = 0.0
            scrollView.bounces = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceHorizontal = true
            scrollView.delegate = self
            
            
            tabBar = FTImageViewBar(frame: CGRectMake(0 ,  FTImageViewerScreenHeight ,  FTImageViewerScreenWidth, FTImageViewBarHeight) ,
                                    saveTapBlock: {
                                        self.saveCurrentImage();
                    },
                                    closeTapBlock: {
                                        self.animationOut()
                    })
            tabBar.alpha = 0
            
            backgroundView.addSubview(scrollView)
            backgroundView.addSubview(tabBar)

        }
        scrollView.frame = UIScreen.mainScreen().bounds

        
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        for i in 0 ..< imageUrlArray.count {
            let imageView: FTImageView = FTImageView(frame: CGRectMake(FTImageViewerScreenWidth * CGFloat(i), 0, FTImageViewerScreenWidth, FTImageViewerScreenHeight), imageURL: imageUrlArray[i], atIndex: i)
            imageView.FTImageViewHandleTap = {
                self.animationOut()
            }
            imageView.panGesture.delegate = self;
            imageView.panGesture.addTarget(self, action: #selector(self.panGestureRecognized(_:)))
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * CGFloat(imageUrlArray.count), UIScreen.mainScreen().bounds.height)
        scrollView.scrollRectToVisible(CGRectMake(FTImageViewerScreenWidth*CGFloat(fromIndex), 0, FTImageViewerScreenWidth, FTImageViewerScreenHeight), animated: false)
        
        tabBar.countLabel.text = "\(fromIndex+1)/\(imageUrlArray.count)"
        
        UIView.animateWithDuration(FTImageViewerAnimationDuriation, animations: { () -> Void in
            self.scrollView.alpha = 1.0
            self.tabBar.alpha = 1
            self.tabBar.frame = CGRectMake(0, FTImageViewerScreenHeight-FTImageViewBarHeight, FTImageViewerScreenWidth, FTImageViewBarHeight)
            }) { (finished: Bool) -> Void in
                self.beginAnimationView.hidden = true
        }
    }
    
    //MARK: - gestureRecognizerShouldBegin -

    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view!.isKindOfClass(FTImageView)){
            let translatedPoint = (gestureRecognizer as! UIPanGestureRecognizer).translationInView(gestureRecognizer.view)
            return fabs(translatedPoint.y) > fabs(translatedPoint.x);
        }
        return true
    }
    
    //MARK: - panGestureRecognized -

    func panGestureRecognized(gesture : UIPanGestureRecognizer){
        let currentItem : UIView = gesture.view!
        let translatedPoint = gesture.translationInView(currentItem)
        let newAlpha = CGFloat(1 - fabsf(Float(translatedPoint.y/FTImageViewerScreenHeight)))

        if (gesture.state == UIGestureRecognizerState.Began || gesture.state == UIGestureRecognizerState.Changed){
            scrollView.scrollEnabled = false
            currentItem.frame = CGRectMake(currentItem.frame.origin.x, translatedPoint.y, currentItem.frame.size.width, currentItem.frame.size.height)
            self.tabBar.frame = CGRectMake(0, FTImageViewerScreenHeight-FTImageViewBarHeight*newAlpha, FTImageViewerScreenWidth, FTImageViewBarHeight)
            backgroundView.backgroundColor = FTImageViewerBackgroundColor.colorWithAlphaComponent(newAlpha)
        }else if (gesture.state == UIGestureRecognizerState.Ended ){
            
            scrollView.scrollEnabled = true
            if (fabs(translatedPoint.y) >= FTImageViewerScreenHeight*0.2){
                UIView.animateWithDuration(FTImageViewerAnimationDuriation, animations: { () -> Void in
                    self.backgroundView.backgroundColor = UIColor.clearColor()
                    if (translatedPoint.y > 0){
                        currentItem.frame = CGRectMake(currentItem.frame.origin.x, FTImageViewerScreenHeight, currentItem.frame.size.width, currentItem.frame.size.height)
                    }else{
                        currentItem.frame = CGRectMake(currentItem.frame.origin.x, -FTImageViewerScreenHeight, currentItem.frame.size.width, currentItem.frame.size.height)
                    }

                    self.tabBar.frame = CGRectMake(0, FTImageViewerScreenHeight, FTImageViewerScreenWidth, FTImageViewBarHeight)
                    }) { (finished: Bool) -> Void in
                        if  (finished == true){
                            self.backgroundView.removeFromSuperview()
                        }
                }
            }else{
                UIView.animateWithDuration(FTImageViewerAnimationDuriation, animations: { () -> Void in
                    self.backgroundView.backgroundColor = FTImageViewerBackgroundColor
                    currentItem.frame = CGRectMake(currentItem.frame.origin.x, 0, currentItem.frame.size.width, currentItem.frame.size.height)
                    self.tabBar.frame = CGRectMake(0, FTImageViewerScreenHeight-FTImageViewBarHeight, FTImageViewerScreenWidth, FTImageViewBarHeight)
                    }) { (finished: Bool) -> Void in

                }
            }
        }
    }
    

    //MARK: - scrollViewDidEndDecelerating -

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        let page = NSInteger(scrollView.contentOffset.x / FTImageViewerScreenWidth)
        tabBar.countLabel.text = "\(page+1)/\(imageUrlArray.count)"
    }

    //MARK: - animationOut -

    private func animationOut(){
        let page = NSInteger(scrollView.contentOffset.x / FTImageViewerScreenWidth)
        
        for img in scrollView.subviews{
            if (img is FTImageView) && ((img as! FTImageView).tag == page) {
                if ((img as! FTImageView).imageView.image != nil) {
                    self.beginAnimationView.image = (img as! FTImageView).imageView.image
                    break
                }
            }
        }
        self.beginAnimationView.hidden = false
        UIView.animateWithDuration(FTImageViewerAnimationDuriation, animations: { () -> Void in
            self.beginAnimationView.frame = self.fromSenderRectArray[page]
            self.scrollView.alpha = 0
            self.backgroundView.backgroundColor = UIColor.clearColor();
            self.tabBar.frame = CGRectMake(0, FTImageViewerScreenHeight, FTImageViewerScreenWidth, FTImageViewBarHeight)
            }) { (finished: Bool) -> Void in
                if  (finished == true){
                    self.beginAnimationView.hidden = true
                    self.backgroundView.removeFromSuperview()
                }
        }
    }

    //MARK: - saveCurrentImage -

    private func saveCurrentImage(){
        let page = NSInteger(scrollView.contentOffset.x / FTImageViewerScreenWidth)
        
        for img in scrollView.subviews{
            if (img is FTImageView) && ((img as! FTImageView).tag == page) {
                if ((img as! FTImageView).imageView.image != nil) {
                    UIImageWriteToSavedPhotosAlbum((img as! FTImageView).imageView.image!, nil, nil, nil)
                    self.tabBar.countLabel.text = "Save image done."
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        let page = NSInteger(self.scrollView.contentOffset.x / FTImageViewerScreenWidth)
                        self.tabBar.countLabel.text = "\(page+1)/\(self.imageUrlArray.count)"
                    })
                }
            }
        }
    }

    

}


//MARK: - FTImageView -

/**
 FTImageView
 */

public class FTImageView: UIScrollView, UIScrollViewDelegate{
    
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    var FTImageViewHandleTap: (() -> ())?
    var singleTap : UITapGestureRecognizer!
    var doubleTap : UITapGestureRecognizer!
    var panGesture : UIPanGestureRecognizer!
    
    
    //MARK: - FTImageViewBar -

    internal init(frame : CGRect, imageURL : String, atIndex : NSInteger){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        self.delegate = self
        self.tag = atIndex
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake((frame.width - FTImageViewBarHeight)/2, (frame.height - FTImageViewBarHeight)/2, FTImageViewBarHeight, FTImageViewBarHeight))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.addSubview(activityIndicator)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.sd_setImageWithURL(NSURL(string: imageURL)) { (image, error, _, _) -> Void in
            if (image != nil){
                self.activityIndicator.hidden = true
            }
        }
        self.addSubview(imageView)
        


        //gesture
        singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.delaysTouchesBegan = true
        self.addGestureRecognizer(singleTap)
        
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true
        self.addGestureRecognizer(doubleTap)

        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        panGesture = UIPanGestureRecognizer()
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)


    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?{
        return imageView
    }
    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat){
        let ws = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right
        let hs = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let w = imageView.frame.size.width
        let h = imageView.frame.size.height
        var rct = imageView.frame
        rct.origin.x = (ws > w) ? (ws-w)/2 : 0
        rct.origin.y = (hs > h) ? (hs-h)/2 : 0
        imageView.frame = rct;
    }
    func handleSingleTap(sender: UITapGestureRecognizer){
        self.FTImageViewHandleTap?()
    }
    
    func handleDoubleTap(sender: UITapGestureRecognizer){
        let touchPoint = sender.locationInView(self)
        if (self.zoomScale == self.maximumZoomScale){
            self.setZoomScale(self.minimumZoomScale, animated: true)
        }else{
            self.zoomToRect(CGRectMake(touchPoint.x, touchPoint.y, 1, 1), animated: true)
        }
    }

}

/**
 FTImageViewBar
 */
//MARK: - FTImageViewBar -

public class FTImageViewBar : UIView {
    
    var closeButton : UIButton!
    var saveButton : UIButton!
    var countLabel : UILabel!
    
    var saveButtonTapBlock : (() ->())!
    var closeButtonTapBlock : (() ->())!
    
    /**
     initializer
     */
    convenience init(frame: CGRect , saveTapBlock: ()->() , closeTapBlock: ()->()) {
        self.init(frame: frame)
        self.backgroundColor = FTImageViewBarBackgroundColor
        
        saveButtonTapBlock = saveTapBlock
        closeButtonTapBlock = closeTapBlock
        

//        let bundleURL : NSString = "Frameworks/FTImageViewer.framework/ImageAssets.bundle"
//        let closeImagePath = bundleURL.stringByAppendingPathComponent("close.png")
//        let saveImagePath = bundleURL.stringByAppendingPathComponent("save.png")
        

        closeButton = UIButton(frame: CGRectMake(FTImageViewBarDefaultMargin, (frame.height-FTImageViewBarButtonWidth)/2, FTImageViewBarButtonWidth, FTImageViewBarButtonWidth))
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.contentMode = UIViewContentMode.ScaleAspectFill
        closeButton.setImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: #selector(FTImageViewBar.onCloseButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(closeButton)

        saveButton = UIButton(frame: CGRectMake(frame.width-FTImageViewBarButtonWidth-FTImageViewBarDefaultMargin, (frame.height-FTImageViewBarButtonWidth)/2, FTImageViewBarButtonWidth, FTImageViewBarButtonWidth))
        saveButton.backgroundColor = UIColor.clearColor()
        saveButton.contentMode = UIViewContentMode.ScaleAspectFill
        saveButton.setImage(UIImage(named: "save"), forState: UIControlState.Normal)
        saveButton.addTarget(self, action: #selector(FTImageViewBar.onSaveButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(saveButton)
        
        countLabel = UILabel(frame: CGRectMake(FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2, 0, frame.width-(FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2)*2, frame.height))
        countLabel.backgroundColor = UIColor.clearColor()
        countLabel.textColor = UIColor.whiteColor()
        countLabel.font = UIFont.systemFontOfSize(13)
        countLabel.textAlignment = NSTextAlignment.Center
        countLabel.text = "-/-"
        self.addSubview(countLabel)
    }

    /**
     onCloseButtonTapped
     */
    func onCloseButtonTapped(){
        self.closeButtonTapBlock();
    }
    
    /**
     onSaveButtonTapped
     */
    func onSaveButtonTapped(){
        self.saveButtonTapBlock();
    }
}


//MARK: - FTImageGridView -

public class FTImageGridView: UIView{
    
    var FTImageGridViewTapBlock : ((buttonArray: [UIButton] , buttonIndex : NSInteger) ->())?
    var buttonArray : [UIButton] = []
    
    //MARK: - internal init frame imageArray tapBlock -

    /**
     internal init frame imageArray tapBlock
     
     - parameter frame:        frame
     - parameter withImgArray: withImgArray
     - parameter tapBlock:     FTImageGridViewTapBlock
     
     - returns: FTImageGridView
     */
    
    convenience init(frame : CGRect, imageArray : [String] , tapBlock : ((buttonsArray: [UIButton] , buttonIndex : NSInteger) ->())){
        self.init(frame: frame)
        
        self.showWithImageArray(imageArray, tapBlock: tapBlock)
        
    }
    
    public func showWithImageArray(imageArray : [String] , tapBlock : ((buttonsArray: [UIButton] , buttonIndex : NSInteger) ->())) {
        
        buttonArray = []
        
        for views in self.subviews {
            if views.isKindOfClass(UIButton.classForCoder()){
                views.removeFromSuperview();
            }
        }
        
        if imageArray.count > 0 {
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
        

    }
    
    
    
    
    //MARK: - get Height With Width -

    /**
     get Height With Width
     
     - parameter width:    width
     - parameter imgCount: imgCount
     
     - returns: CGFloat Height
     */
    class func getHeightWithWidth(width: CGFloat, imgCount: Int) -> CGFloat{
        let imgHeight: CGFloat = (width - FTImageGridViewImageMargin * 2) / 3
        let photoAlbumHeight : CGFloat = imgHeight * CGFloat(ceilf(Float(imgCount) / 3)) + FTImageGridViewImageMargin * CGFloat(ceilf(Float(imgCount) / 3)-1)
        return photoAlbumHeight
    }
    
    //MARK: - onClickImage -

    /**
     onClickImage
     
     - parameter sender: UIButton
     */
    func onClickImage(sender: UIButton){
        FTImageGridViewTapBlock?(buttonArray: self.buttonArray , buttonIndex: sender.tag)
    }
    
}
