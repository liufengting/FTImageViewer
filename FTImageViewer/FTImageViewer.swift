//
//  FTImageViewer.swift
//  FTImageViewer
//
//  Created by liufengting on 15/12/17.
//  Copyright © 2015年 liufengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit
import Kingfisher

//MARK: - Marcros -

private let FTImageViewerAnimationDuriation: TimeInterval =  0.3
private let FTImageViewerBackgroundColor =  UIColor.black
private let FTImageViewBarBackgroundColor =  UIColor.black.withAlphaComponent(0.3)
private let FTImageViewBarHeight: CGFloat =  60.0 // for iPhoneX layout issue
private let FTImageViewBarButtonWidth: CGFloat =  30.0
private let FTImageViewBarDefaultMargin: CGFloat =  5.0
private let FTImageGridViewImageMargin: CGFloat = 2.0
private let KCOLOR_BACKGROUND_WHITE = UIColor(red:241/255.0, green:241/255.0, blue:241/255.0, alpha:1.0)
private var FTImageViewerScreenWidth: CGFloat { return UIScreen.main.bounds.width }
private var FTImageViewerScreenHeight: CGFloat { return UIScreen.main.bounds.height }

protocol FTImageResourceProtocol {
    var image: UIImage? { get }
    var imageURLString: String? { get }
}

public struct FTImageResource: FTImageResourceProtocol {
    var image: UIImage?
    var imageURLString: String?
    
    public init(image: UIImage?, imageURLString: String?) {
        self.image = image
        self.imageURLString = imageURLString
    }
}

//MARK: - FTImageViewer extension -

public extension FTImageViewer {
    
    //MARK: - showImages with images (supports both images and url strings)
    
    static func showImages(_ images: [FTImageResource], atIndex: NSInteger, fromSenderArray: [UIView]){
        self.sharedInstance.showImages(images, atIndex: atIndex, fromSenderArray: fromSenderArray)
    }
    
    //MARK: - showImages with image url strings
    
    static func showImages(_ images: [String], atIndex: NSInteger, fromSenderArray: [UIView]) {
        self.sharedInstance.showImages(images, atIndex: atIndex, fromSenderArray: fromSenderArray);
    }
}

//MARK: - FTImageViewer -

public class FTImageViewer: NSObject, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    private var fromRect: CGRect!
    private var currenIndex: NSInteger = 0
    private var imageUrlArray: [FTImageResource]!
    private var fromSenderRectArray: [CGRect] = []
    private var isPanRecognize: Bool = false


    //MARK: - sharedInstance

    public class var sharedInstance: FTImageViewer {
        struct Static {
            static let instance: FTImageViewer = FTImageViewer()
        }
        return Static.instance
    }

    //MARK: - showImages with images (supports both images and url strings)
    
    public func showImages(_ images: [FTImageResource], atIndex: NSInteger, fromSenderArray: [UIView]){
        fromSenderRectArray = []
        
        for i in 0 ... fromSenderArray.count-1 {
            let rect: CGRect = fromSenderArray[i].superview!.convert(fromSenderArray[i].frame, to:UIApplication.shared.keyWindow)
            fromSenderRectArray.append(rect)
        }
        
        currenIndex = atIndex
        imageUrlArray = images
        fromRect = fromSenderRectArray[atIndex]

        backgroundView.backgroundColor = FTImageViewerBackgroundColor
        UIApplication.shared.keyWindow?.addSubview(backgroundView);
        backgroundView.addSubview(scrollView)
        backgroundView.addSubview(tabBar)
        
        beginAnimationView.isHidden = false
        beginAnimationView.frame = fromRect
        backgroundView.addSubview(beginAnimationView)

        if let img: UIImage = (images[atIndex]).image {
            beginAnimationView.image = img
            self.beginAnimationView.frame = self.imageFrame(image: img, fromRect: fromRect)
        }else if let imageURL: String = (images[atIndex]).imageURLString {
            beginAnimationView.kf.setImage(with: URL(string: imageURL)!, placeholder: nil, options: nil, progressBlock: nil) { result in
                if let image = try? result.get().image {
                    self.beginAnimationView.frame = self.imageFrame(image: image, fromRect: self.fromRect)
                } else {
                    return
                }
            }
        }
        
        UIView.animate(withDuration: FTImageViewerAnimationDuriation,
                       animations: { () -> Void in
                        self.beginAnimationView.layer.frame = UIScreen.main.bounds;
        }, completion: { (finished) -> Void in
            if (finished == true){
                self.setupView(shouldAnimate: true)
            }
        })
    }
    
    func imageFrame(image: UIImage, fromRect: CGRect) -> CGRect {
        let size = image.size
        var rect = CGRect.zero
        let imageRadio = size.width/size.height
        let origin = fromRect.width/fromRect.height
        if imageRadio > origin {
            rect.size.width = imageRadio * fromRect.height
            rect.size.height = fromRect.height
            rect.origin.x = (fromRect.origin.x + fromRect.size.width/2.0) - rect.size.width/2.0
            rect.origin.y = fromRect.origin.y
        } else {
            rect.size.width = fromRect.width
            rect.size.height = fromRect.width/imageRadio
            rect.origin.x = fromRect.origin.x
            rect.origin.y = (fromRect.origin.y + fromRect.size.height/2.0) - rect.size.height/2.0
        }
        return rect
    }
    
    //MARK: - showImages with image url strings

    public func showImages(_ images: [String] , atIndex: NSInteger , fromSenderArray: [UIView]) {
        var resources: [FTImageResource] = []
        for imageURL in images {
            let resource: FTImageResource = FTImageResource(image: nil, imageURLString:imageURL)
            resources.append(resource)
        }
        self.showImages(resources, atIndex: atIndex, fromSenderArray: fromSenderArray)
    }
    
    
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        return view
    }()

    fileprivate lazy var beginAnimationView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.clear;
        return imageView
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
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

    fileprivate lazy var tabBar: FTImageViewBar = {
        let view = FTImageViewBar(frame: CGRect(x: 0 , y: FTImageViewerScreenHeight, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight) ,
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
            let imageView: FTImageView = FTImageView(frame: CGRect(x: FTImageViewerScreenWidth * CGFloat(i), y: 0, width: FTImageViewerScreenWidth, height: FTImageViewerScreenHeight), imageResource: imageUrlArray[i], atIndex: i)
            imageView.FTImageViewHandleTap = {
                self.animationOut()
            }
            imageView.panGesture.delegate = self;
            imageView.panGesture.addTarget(self, action: #selector(self.panGestureRecognized(_:)))
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(imageUrlArray.count), height: UIScreen.main.bounds.height)
        scrollView.scrollRectToVisible(CGRect(x: FTImageViewerScreenWidth*CGFloat(currenIndex), y: 0, width: FTImageViewerScreenWidth, height: FTImageViewerScreenHeight), animated: false)
        tabBar.countLabel.text = "\(currenIndex+1)/\(imageUrlArray.count)"
        
        if shouldAnimate {
            self.show()
        }else{
            self.scrollView.alpha = 1.0
            self.tabBar.alpha = 1
            self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight-FTImageViewBarHeight, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
            self.tabBar.layoutIfNeeded()
        }
    }
    
    //MARK: - show

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

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view!.isKind(of: FTImageView.self)){
            let translatedPoint = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
            return abs(translatedPoint.y) > abs(translatedPoint.x);
        }
        return true
    }
    
    //MARK: - panGestureRecognized

    @objc func panGestureRecognized(_ gesture: UIPanGestureRecognizer){
        let currentItem: UIView = gesture.view!
        let translatedPoint = gesture.translation(in: currentItem)
        let newAlpha = CGFloat(1 - fabsf(Float(translatedPoint.y/FTImageViewerScreenHeight)))

        if (gesture.state == UIGestureRecognizer.State.began || gesture.state == UIGestureRecognizer.State.changed){
            scrollView.isScrollEnabled = false
            currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: translatedPoint.y, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
            self.tabBar.frame = CGRect(x: 0, y: FTImageViewerScreenHeight-FTImageViewBarHeight*newAlpha, width: FTImageViewerScreenWidth, height: FTImageViewBarHeight)
            backgroundView.backgroundColor = FTImageViewerBackgroundColor.withAlphaComponent(newAlpha)
        }else if (gesture.state == UIGestureRecognizer.State.ended ){
            scrollView.isScrollEnabled = true
            if (abs(translatedPoint.y) >= FTImageViewerScreenHeight*0.2){
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

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        currenIndex = NSInteger(scrollView.contentOffset.x / FTImageViewerScreenWidth)
        tabBar.countLabel.text = "\(currenIndex+1)/\(imageUrlArray.count)"
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
        let rect = self.fromSenderRectArray[page]
        var imageRect = rect
        if let image = self.beginAnimationView.image {
            imageRect = self.imageFrame(image: image, fromRect: rect)
        }
        UIView.animate(withDuration: FTImageViewerAnimationDuriation, animations: { () -> Void in
            self.beginAnimationView.frame = imageRect
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

    fileprivate func saveCurrentImage() {
        var imageToSave: UIImage? = nil;
        for img in scrollView.subviews{
            if (img is FTImageView) && ((img as! FTImageView).tag == currenIndex) {
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

    @objc func saveImageDone(_ image: UIImage, error: Error, context: UnsafeMutableRawPointer?) {
        self.tabBar.countLabel.text = NSLocalizedString("Save image done.", comment: "Save image done.")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.tabBar.countLabel.text = "\(self.currenIndex+1)/\(self.imageUrlArray.count)"
        })
    }

}

//MARK: - FTImageViewer extension -

extension FTImageViewer {
    
    fileprivate func addOrientationChangeNotification() {
        NotificationCenter.default.addObserver(self,selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)
    }
    
    fileprivate func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func onChangeStatusBarOrientationNotification(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.setupView(shouldAnimate: false)
        })
    }
    
}

//MARK: - FTImageView -

public class FTImageView: UIScrollView, UIScrollViewDelegate{
    
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    var FTImageViewHandleTap: (() -> ())?
    var singleTap: UITapGestureRecognizer!
    var doubleTap: UITapGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    
    public init(frame: CGRect, imageResource: FTImageResource, atIndex: NSInteger){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        self.delegate = self
        self.tag = atIndex
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (frame.width - FTImageViewBarHeight)/2, y: (frame.height - FTImageViewBarHeight)/2, width: FTImageViewBarHeight, height: FTImageViewBarHeight))
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit

        if let img: UIImage = imageResource.image {
            imageView.image = img
        }else if let imageURL: String = imageResource.imageURLString {
            imageView.kf.setImage(with: URL(string: imageURL)!, placeholder: nil, options: nil, progressBlock: nil) { result in
                if (try? result.get().image) != nil {
                    self.activityIndicator.stopAnimating()
                } else {
                    return
                }
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
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return imageView
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
        let ws = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right
        let hs = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let w = imageView.frame.size.width
        let h = imageView.frame.size.height
        var rct = imageView.frame
        rct.origin.x = (ws > w) ? (ws-w)/2: 0
        rct.origin.y = (hs > h) ? (hs-h)/2: 0
        imageView.frame = rct;
    }

    //MARK: - handleSingleTap -

    @objc func handleSingleTap(_ sender: UITapGestureRecognizer){
        self.FTImageViewHandleTap?()
    }
    
    //MARK: - handleDoubleTap -
    
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: self)
        if (self.zoomScale == self.maximumZoomScale){
            self.setZoomScale(self.minimumZoomScale, animated: true)
        }else{
            self.zoom(to: CGRect(x: touchPoint.x, y: touchPoint.y, width: 1, height: 1), animated: true)
        }
    }

}

//MARK: - FTImageViewBar -

public class FTImageViewBar: UIView {

    var saveButtonTapBlock: (() ->())!
    var closeButtonTapBlock: (() ->())!

    fileprivate lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth))
        button.backgroundColor = UIColor.clear
        button.contentMode = UIView.ContentMode.scaleAspectFill
        button.addTarget(self, action: #selector(FTImageViewBar.onCloseButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
    fileprivate lazy var saveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: self.frame.width-FTImageViewBarButtonWidth-FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth))
        button.backgroundColor = UIColor.clear
        button.contentMode = UIView.ContentMode.scaleAspectFill
        button.addTarget(self, action: #selector(FTImageViewBar.onSaveButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    fileprivate lazy var countLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2, y: 0, width: self.frame.width-(FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2)*2, height: self.frame.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.text = "-/-"
        return label
    }()
    
    //MARK: - convenience init

    public convenience init(frame: CGRect, saveTapBlock: @escaping ()->(), closeTapBlock: @escaping ()->()) {
        self.init(frame: frame)
        self.backgroundColor = FTImageViewBarBackgroundColor
        saveButtonTapBlock = saveTapBlock
        closeButtonTapBlock = closeTapBlock
        var imageBundle: Bundle = Bundle.main
        if let bundleURL: String = Bundle(for: FTImageViewer.classForCoder()).path(forResource: "FTResource", ofType: "bundle") {
            if let bundle: Bundle = Bundle(path: bundleURL){
                imageBundle = bundle;
            }
        }
        closeButton.setImage(UIImage(named: "close", in: imageBundle, compatibleWith: nil), for: UIControl.State())
        self.addSubview(closeButton)
        saveButton.setImage(UIImage(named: "save", in: imageBundle, compatibleWith: nil), for: UIControl.State())
        self.addSubview(saveButton)
        self.addSubview(countLabel)
    }

    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.closeButton.frame = CGRect(x: FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth)
        self.saveButton.frame = CGRect(x: self.frame.width-FTImageViewBarButtonWidth-FTImageViewBarDefaultMargin, y: (self.frame.height-FTImageViewBarButtonWidth)/2, width: FTImageViewBarButtonWidth, height: FTImageViewBarButtonWidth)
        self.countLabel.frame = CGRect(x: FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2, y: 0, width: self.frame.width-(FTImageViewBarButtonWidth+FTImageViewBarDefaultMargin*2)*2, height: self.frame.height)
    }
    
    //MARK: - onCloseButtonTapped

    @objc func onCloseButtonTapped(){
        self.closeButtonTapBlock();
    }

    //MARK: - onSaveButtonTapped

    @objc func onSaveButtonTapped(){
        self.saveButtonTapBlock();
    }
}


//MARK: - FTImageGridView -

public class FTImageGridView: UIView {
    
    var FTImageGridViewTapBlock: ((_ buttonArray: [UIButton], _ buttonIndex: NSInteger) ->())?
    var buttonArray: [UIButton] = []
    
    //MARK: - internal init frame imageArray tapBlock

    public convenience init(frame: CGRect, imageArray: [String], tapBlock: @escaping ((_ buttonsArray: [UIButton], _ buttonIndex: NSInteger) ->())){
        self.init(frame: frame)
        self.showWithImageArray(imageArray, tapBlock: tapBlock)
    }
    
    public func showWithImageArray(_ imageArray: [String], tapBlock: @escaping ((_ buttonsArray: [UIButton], _ buttonIndex: NSInteger) ->())) {
        buttonArray = []
        for views in self.subviews {
            if views.isKind(of: UIButton.classForCoder()){
                views.removeFromSuperview();
            }
        }
        if imageArray.count > 0 {
            FTImageGridViewTapBlock = tapBlock
            let imgHeight: CGFloat = (frame.size.width - FTImageGridViewImageMargin * 2) / 3
            for i in 0 ... imageArray.count-1 {
                let x = CGFloat(i % 3) * (imgHeight + FTImageGridViewImageMargin)
                let y = CGFloat(i / 3) * (imgHeight + FTImageGridViewImageMargin)
                let imageButton  = UIButton()
                imageButton.frame = CGRect(x: x, y: y, width: imgHeight, height: imgHeight)
                imageButton.backgroundColor = KCOLOR_BACKGROUND_WHITE
                imageButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
                imageButton.kf.setImage(with: URL(string: imageArray[i])!, for: UIControl.State.normal)
                
                imageButton.tag = i
                imageButton.clipsToBounds = true
                imageButton.addTarget(self, action: #selector(FTImageGridView.onClickImage(_:)), for: UIControl.Event.touchUpInside)
                self.addSubview(imageButton)
                self.buttonArray.append(imageButton)
            }
        }
    }

    //MARK: - get Height With Width

    public class func getHeightWithWidth(_ width: CGFloat, imgCount: Int) -> CGFloat{
        let imgHeight: CGFloat = (width - FTImageGridViewImageMargin * 2) / 3
        let photoAlbumHeight: CGFloat = imgHeight * CGFloat(ceilf(Float(imgCount) / 3)) + FTImageGridViewImageMargin * CGFloat(ceilf(Float(imgCount) / 3)-1)
        return photoAlbumHeight
    }
    
    //MARK: - onClickImage

    @objc func onClickImage(_ sender: UIButton){
        FTImageGridViewTapBlock?(self.buttonArray , sender.tag)
    }
    
}
