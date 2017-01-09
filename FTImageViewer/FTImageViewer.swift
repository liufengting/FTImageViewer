//
//  FTImageViewer.swift
//  FTImageViewer
//
//  Created by liufengting on 15/12/17.
//  Copyright © 2015年 liufengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: Settings

public let FTImageColumnCount: Int = 3

//MARK: - Marcros -

private let FTImageViewerAnimationDuriation : TimeInterval =  0.3
private let FTImageViewerBackgroundColor =  UIColor.black
private let FTImageViewBarBackgroundColor =  UIColor.black.withAlphaComponent(0.3)
private let FTImageViewBarHeight : CGFloat =  40.0
private let FTImageViewBarButtonWidth : CGFloat =  30.0
private let FTImageViewBarDefaultMargin : CGFloat =  5.0
private let FTImageGridViewImageMargin : CGFloat = 2.0
private let KCOLOR_BACKGROUND_WHITE = UIColor(red:241/255.0, green:241/255.0, blue:241/255.0, alpha:1.0)
private var FTImageViewerScreenWidth : CGFloat { return UIScreen.main.bounds.width }
private var FTImageViewerScreenHeight : CGFloat { return UIScreen.main.bounds.height }


//MARK: - FTImageViewer -

public class FTImageViewer: NSObject, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    private var beginAnimationView: UIImageView!
    private var fromRect: CGRect!
    private var fromIndex: NSInteger = 0
    private var imageUrlArray: [String]!
    private var fromSenderRectArray: [CGRect] = []
    private var isPanRecognize: Bool = false


    //MARK: - sharedInstance

    public class var sharedInstance : FTImageViewer {
        struct Static {
            static let instance : FTImageViewer = FTImageViewer()
        }
        return Static.instance
    }
    
    //MARK: - showImages

    public func showImages(_ images : [String] , atIndex : NSInteger , fromSenderArray: [UIView]){
        
        fromSenderRectArray = []
        
        for i in 0 ... fromSenderArray.count-1 {
            let rect : CGRect = fromSenderArray[i].superview!.convert(fromSenderArray[i].frame, to:UIApplication.shared.keyWindow)
            fromSenderRectArray.append(rect)
        }

        fromIndex = atIndex
        imageUrlArray = images
        fromRect = fromSenderRectArray[atIndex]

        backgroundView.backgroundColor = FTImageViewerBackgroundColor
        UIApplication.shared.keyWindow?.addSubview(backgroundView);
        backgroundView.addSubview(scrollView)
        backgroundView.addSubview(tabBar)
        
        beginAnimationView = UIImageView(frame : fromRect)
        beginAnimationView.clipsToBounds = true
        beginAnimationView.isUserInteractionEnabled = false
        beginAnimationView.contentMode = UIViewContentMode.scaleAspectFit
        beginAnimationView.backgroundColor = UIColor.clear;
        backgroundView.addSubview(beginAnimationView)
        beginAnimationView.kf.setImage(with: URL(string: images[atIndex])!)

        UIView.animate(withDuration: FTImageViewerAnimationDuriation,
            animations: { () -> Void in
                self.beginAnimationView.layer.frame = UIScreen.main.bounds;
            }, completion: { (finished) -> Void in
                if (finished == true){
                    self.setupView(shouldAnimate: true)
                }
        }) 
    }

    fileprivate lazy var backgroundView : UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        return view
    }()

    fileprivate lazy var scrollView : UIScrollView = {
        let sView = UIScrollView(frame: UIScreen.main.bounds)
        sView.backgroundColor = UIColor.clear
        sView.isPagingEnabled = true
        sView.alpha = 0.0
        sView.bounces = true
        sView.showsHorizontalScrollIndicator = false
        sView.showsVerticalScrollIndicator = false
        sView.alwaysBounceHorizontal = true
        sView.delegate = self
        return sView
    }()

    fileprivate lazy var tabBar : FTImageViewBar = {
        let view = FTImageViewBar(frame: CGRect(x: 0 ,  y: FTImageViewerScreenHeight ,  width: FTImageViewerScreenWidth, height: FTImageViewBarHeight) ,
                                           saveTapBlock: {
                                            self.saveCurrentImage();
        },
                                           closeTapBlock: {
                                            self.animationOut()
        })
        view.alpha = 0
        return view
    }()
    
    //MARK: - setupView

    fileprivate func setupView(shouldAnimate: Bool){

        backgroundView.frame = UIScreen.main.bounds
        scrollView.frame = UIScreen.main.bounds
        tabBar.frame = CGRect(x: 0 ,  y: FTImageViewerScreenHeight ,  width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)


        
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        for i in 0 ..< imageUrlArray.count {
            let imageView: FTImageView = FTImageView(frame: CGRect(x: FTImageViewerScreenWidth * CGFloat(i), y: 0, width: FTImageViewerScreenWidth, height: FTImageViewerScreenHeight), imageURL: imageUrlArray[i], atIndex: i)
            imageView.FTImageViewHandleTap = {
                self.animationOut()
            }
            imageView.panGesture.delegate = self;
            imageView.panGesture.addTarget(self, action: #selector(self.panGestureRecognized(_:)))
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(imageUrlArray.count), height: UIScreen.main.bounds.height)
        scrollView.scrollRectToVisible(CGRect(x: FTImageViewerScreenWidth*CGFloat(fromIndex), y: 0, width: FTImageViewerScreenWidth, height: FTImageViewerScreenHeight), animated: false)
        tabBar.countLabel.text = "\(fromIndex+1)/\(imageUrlArray.count)"
        
        if shouldAnimate {
            self.show()
        }else{
            self.scrollView.alpha = 1.0
            self.tabBar.alpha = 1
            self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight-FTImageViewBarHeight, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
            self.tabBar.layoutIfNeeded()
        }
    }
    
    func show() {
        
        self.addOrientationChangeNotification()
        
        UIView.animate(withDuration: FTImageViewerAnimationDuriation, animations: { () -> Void in
            self.scrollView.alpha = 1.0
            self.tabBar.alpha = 1
            self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight-FTImageViewBarHeight, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
        }, completion: { (finished: Bool) -> Void in
            self.beginAnimationView.isHidden = true
        })
    }
    
    
    //MARK: - gestureRecognizerShouldBegin

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view!.isKind(of: FTImageView.self)){
            let translatedPoint = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
            return fabs(translatedPoint.y) > fabs(translatedPoint.x);
        }
        return true
    }
    
    //MARK: - panGestureRecognized

    func panGestureRecognized(_ gesture : UIPanGestureRecognizer){
        let currentItem : UIView = gesture.view!
        let translatedPoint = gesture.translation(in: currentItem)
        let newAlpha = CGFloat(1 - fabsf(Float(translatedPoint.y/FTImageViewerScreenHeight)))

        if (gesture.state == UIGestureRecognizerState.began || gesture.state == UIGestureRecognizerState.changed){
            scrollView.isScrollEnabled = false
            currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: translatedPoint.y, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
            self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight-FTImageViewBarHeight*newAlpha, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
            backgroundView.backgroundColor = FTImageViewerBackgroundColor.withAlphaComponent(newAlpha)
        }else if (gesture.state == UIGestureRecognizerState.ended ){
            
            scrollView.isScrollEnabled = true
            if (fabs(translatedPoint.y) >= FTImageViewerScreenHeight*0.2){
                UIView.animate(withDuration: FTImageViewerAnimationDuriation, animations: { () -> Void in
                    self.backgroundView.backgroundColor = UIColor.clear
                    if (translatedPoint.y > 0){
                        currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: FTImageViewerScreenHeight, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
                    }else{
                        currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: -FTImageViewerScreenHeight, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
                    }

                    self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
                    }, completion: { (finished: Bool) -> Void in
                        if  (finished == true){
                            self.removeOrientationChangeNotification()
                            self.scrollView.removeFromSuperview()
                            self.tabBar.removeFromSuperview()
                            self.backgroundView.removeFromSuperview()
                        }
                }) 
            }else{
                UIView.animate(withDuration: FTImageViewerAnimationDuriation, animations: { () -> Void in
                    self.backgroundView.backgroundColor = FTImageViewerBackgroundColor
                    currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: 0, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
                    self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight-FTImageViewBarHeight, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
                    }, completion: { (finished: Bool) -> Void in

                }) 
            }
        }
    }
    

    //MARK: - UIScrollViewDelegate

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let page = NSInteger(scrollView.contentOffset.x / FTImageViewerScreenWidth)
        tabBar.countLabel.text = "\(page+1)/\(imageUrlArray.count)"
    }

    //MARK: - animationOut

    fileprivate func animationOut(){
        
        self.removeOrientationChangeNotification()
        
        let page = NSInteger(scrollView.contentOffset.x / FTImageViewerScreenWidth)
        
        for img in scrollView.subviews{
            if (img is FTImageView) && ((img as! FTImageView).tag == page) {
                if ((img as! FTImageView).imageView.image != nil) {
                    self.beginAnimationView.image = (img as! FTImageView).imageView.image
                    break
                }
            }
        }
        self.beginAnimationView.isHidden = false
        UIView.animate(withDuration: FTImageViewerAnimationDuriation, animations: { () -> Void in
            self.beginAnimationView.frame = self.fromSenderRectArray[page]
            self.scrollView.alpha = 0
            self.backgroundView.backgroundColor = UIColor.clear;
            self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
            }, completion: { (finished: Bool) -> Void in
                if  (finished == true){
                    self.beginAnimationView.isHidden = true
                    self.scrollView.removeFromSuperview()
                    self.tabBar.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                }
        }) 
    }

    //MARK: - saveCurrentImage

    fileprivate func saveCurrentImage(){
        let page = NSInteger(scrollView.contentOffset.x / FTImageViewerScreenWidth)
        var imageToSave : UIImage? = nil;
        
        for img in scrollView.subviews{
            if (img is FTImageView) && ((img as! FTImageView).tag == page) {
                if ((img as! FTImageView).imageView.image != nil) {
                    imageToSave = (img as! FTImageView).imageView.image!
                }
            }
        }
        if imageToSave != nil {
            UIImageWriteToSavedPhotosAlbum(imageToSave!, self, #selector(self.saveImageDone(_:error:context:)), nil)
        }
    }

    //MARK: - saveImageDone

    @objc func saveImageDone(_ image : UIImage, error: Error, context: UnsafeMutableRawPointer?) {
        self.tabBar.countLabel.text = NSLocalizedString("Save image done.", comment: "Save image done.")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            let page = NSInteger(self.scrollView.contentOffset.x / FTImageViewerScreenWidth)
            self.tabBar.countLabel.text = "\(page+1)/\(self.imageUrlArray.count)"
        })
    }
    

}
extension FTImageViewer {
    
    fileprivate func addOrientationChangeNotification() {
        NotificationCenter.default.addObserver(self,selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                                               name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
                                               object: nil)
        
    }
    
    fileprivate func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func onChangeStatusBarOrientationNotification(notification : Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.setupView(shouldAnimate: false)
        })
    }
    
}

//MARK: - FTImageView -

/**
 FTImageView
 */

open class FTImageView: UIScrollView, UIScrollViewDelegate{
    
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    var FTImageViewHandleTap: (() -> ())?
    var singleTap : UITapGestureRecognizer!
    var doubleTap : UITapGestureRecognizer!
    var panGesture : UIPanGestureRecognizer!
    
    
    //MARK: - FTImageViewBar

    internal init(frame : CGRect, imageURL : String, atIndex : NSInteger){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        self.delegate = self
        self.tag = atIndex
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (frame.width - FTImageViewBarHeight)/2, y: (frame.height - FTImageViewBarHeight)/2, width: FTImageViewBarHeight, height: FTImageViewBarHeight))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.kf.setImage(with: URL(string: imageURL)!,
                              placeholder: nil,
                              options: nil,
                              progressBlock: { (done, total) in
                                
        }) { (image, error, cashType, url) in
            if image != nil && error == nil {
                self.activityIndicator.stopAnimating()
            }
        }

        self.addSubview(imageView)

        self.setupGestures()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupGestures() {
        //gesture
        singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.delaysTouchesBegan = true
        self.addGestureRecognizer(singleTap)
        
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true
        self.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
        panGesture = UIPanGestureRecognizer()
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
    }
    
    //MARK: - UIScrollViewDelegate
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return imageView
    }
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
        let ws = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right
        let hs = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let w = imageView.frame.size.width
        let h = imageView.frame.size.height
        var rct = imageView.frame
        rct.origin.x = (ws > w) ? (ws-w)/2 : 0
        rct.origin.y = (hs > h) ? (hs-h)/2 : 0
        imageView.frame = rct;
    }

    //MARK: - handleSingleTap

    func handleSingleTap(_ sender: UITapGestureRecognizer){
        self.FTImageViewHandleTap?()
    }
    
    //MARK: - handleDoubleTap
    
    func handleDoubleTap(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: self)
        if (self.zoomScale == self.maximumZoomScale){
            self.setZoomScale(self.minimumZoomScale, animated: true)
        }else{
            self.zoom(to: CGRect(x: touchPoint.x, y: touchPoint.y, width: 1, height: 1), animated: true)
        }
    }

}

//MARK: - FTImageViewBar -

open class FTImageViewBar : UIView {

    var saveButtonTapBlock : (() ->())!
    var closeButtonTapBlock : (() ->())!

    fileprivate lazy var closeButton : UIButton = {
        let button = UIButton(frame: CGRect(x: FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth))
        button.backgroundColor = UIColor.clear
        button.contentMode = UIViewContentMode.scaleAspectFill
        button.addTarget(self, action: #selector(FTImageViewBar.onCloseButtonTapped), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    
    fileprivate lazy var saveButton : UIButton = {
        let button = UIButton(frame: CGRect(x: self.frame.width-FTImageViewBarButtonWidth-FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth))
        button.backgroundColor = UIColor.clear
        button.contentMode = UIViewContentMode.scaleAspectFill
        button.addTarget(self, action: #selector(FTImageViewBar.onSaveButtonTapped), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    fileprivate lazy var countLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2, y: 0, width: self.frame.width-(FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2)*2, height: self.frame.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.text = "-/-"
        return label
    }()
    
    //MARK: - convenience init

    public convenience init(frame: CGRect , saveTapBlock: @escaping ()->() , closeTapBlock: @escaping ()->()) {
        self.init(frame: frame)
        self.backgroundColor = FTImageViewBarBackgroundColor
        
        saveButtonTapBlock = saveTapBlock
        closeButtonTapBlock = closeTapBlock
        
        var imageBundle : Bundle = Bundle.main
        
        if let bundleURL : String = Bundle(for: FTImageViewer.classForCoder()).path(forResource: "FTResource", ofType: "bundle") {
            if let bundle : Bundle = Bundle(path: bundleURL){
                imageBundle = bundle;
            }
        }
        closeButton.setImage(UIImage(named: "close", in: imageBundle, compatibleWith: nil), for: UIControlState())
        self.addSubview(closeButton)
        
        saveButton.setImage(UIImage(named: "save", in: imageBundle, compatibleWith: nil), for: UIControlState())
        self.addSubview(saveButton)

        self.addSubview(countLabel)
    }

    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.closeButton.frame = CGRect(x: FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth)
        self.saveButton.frame = CGRect(x: self.frame.width-FTImageViewBarButtonWidth-FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth)
        self.countLabel.frame = CGRect(x: FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2, y: 0, width: self.frame.width-(FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2)*2, height: self.frame.height)
    }
    
    //MARK: - onCloseButtonTapped

    func onCloseButtonTapped(){
        self.closeButtonTapBlock();
    }

    //MARK: - onSaveButtonTapped

    func onSaveButtonTapped(){
        self.saveButtonTapBlock();
    }
}


//MARK: - FTImageGridView -

open class FTImageGridView: UIView {
    
    var FTImageGridViewTapBlock : ((_ buttonArray: [UIButton] , _ buttonIndex : NSInteger) ->())?
    var buttonArray : [UIButton] = []
    
    //MARK: - internal init frame imageArray tapBlock

    public convenience init(frame : CGRect, imageArray : [String] , tapBlock : @escaping ((_ buttonsArray: [UIButton] , _ buttonIndex : NSInteger) ->())){
        self.init(frame: frame)
        
        self.showWithImageArray(imageArray, tapBlock: tapBlock)
        
    }
    
    open func showWithImageArray(_ imageArray : [String] , tapBlock : @escaping ((_ buttonsArray: [UIButton] , _ buttonIndex : NSInteger) ->())) {
        
        buttonArray = []
        
        for views in self.subviews {
            if views.isKind(of: UIButton.classForCoder()){
                views.removeFromSuperview();
            }
        }
        
        if imageArray.count > 0 {
            FTImageGridViewTapBlock = tapBlock
            let imgHeightFullRow : CGFloat = (frame.size.width - FTImageGridViewImageMargin * CGFloat((FTImageColumnCount - 1))) / CGFloat(FTImageColumnCount)
            let remainImagesCount = imageArray.count % FTImageColumnCount
            let minIndexRemainImages = imageArray.count - remainImagesCount - 1

            var x : CGFloat
            var y : CGFloat
            var imgHeight : CGFloat

            for i in 0 ... imageArray.count-1 {
                // the last remain images has different size
                if (remainImagesCount > 0 && i > minIndexRemainImages) {
                    imgHeight = frame.size.width / CGFloat(remainImagesCount)

                    x = CGFloat(i % remainImagesCount) * (imgHeight + FTImageGridViewImageMargin)
                    y = CGFloat(i / FTImageColumnCount) * (imgHeightFullRow + FTImageGridViewImageMargin)
                } else {
                    imgHeight = imgHeightFullRow

                    x = CGFloat(i % FTImageColumnCount) * (imgHeight + FTImageGridViewImageMargin)
                    y = CGFloat(i / FTImageColumnCount) * (imgHeight + FTImageGridViewImageMargin)
                }
                let imageButton  = UIButton()
                imageButton.frame = CGRect(x: x, y: y, width: imgHeight, height: imgHeight)
                imageButton.backgroundColor = KCOLOR_BACKGROUND_WHITE
                imageButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                imageButton.kf.setImage(with: URL(string: imageArray[i])!, for: UIControlState.normal)
                
                imageButton.tag = i
                imageButton.clipsToBounds = true
                imageButton.addTarget(self, action: #selector(FTImageGridView.onClickImage(_:)), for: UIControlEvents.touchUpInside)
                self.addSubview(imageButton)
                
                self.buttonArray.append(imageButton)
            }
        }
        

    }

    //MARK: - get Height With Width

    open class func getHeightWithWidth(_ width: CGFloat, imgCount: Int) -> CGFloat{
        var photoAlbumHeight : CGFloat = 0
        let imgHeight: CGFloat = (width - FTImageGridViewImageMargin * (CGFloat(FTImageColumnCount) - 1)) / CGFloat(FTImageColumnCount)
        let remainImagesCount = imgCount % FTImageColumnCount

        // If we have not filled row
        if (remainImagesCount > 0) {

            // Add height of full rows if at least one fullfilled row exist
            if (imgCount >= FTImageColumnCount) {
                let filledRows = floor(CGFloat(imgCount) / CGFloat(FTImageColumnCount))
                photoAlbumHeight = imgHeight * CGFloat(filledRows) + FTImageGridViewImageMargin * CGFloat(filledRows)
            }

            // Add height of remain images height

            let remainImagesHeight  = width / CGFloat(remainImagesCount)

            photoAlbumHeight = photoAlbumHeight + remainImagesHeight

        } else {
            // Rows are filled by FTImageColumnCount in each row
            photoAlbumHeight = CGFloat(imgHeight) * (ceil(CGFloat(imgCount / FTImageColumnCount))) +
            CGFloat(FTImageGridViewImageMargin) * (ceil(CGFloat(imgCount / FTImageColumnCount) - 1))
        }

        return photoAlbumHeight
    }
    
    //MARK: - onClickImage

    func onClickImage(_ sender: UIButton){
        FTImageGridViewTapBlock?(self.buttonArray , sender.tag)
    }
    
}
