//
//  WebViewController.swift
//  FTImageViewerDemo
//
//  Created by liufengting on 21/11/2016.
//  Copyright © 2016 <https://github.com/liufengting>. All rights reserved.
//

import UIKit
import FTImageViewer

class WebViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // a link from my blog
        self.webView.loadRequest(URLRequest(url: URL(string: "http://liufengting.github.io/2016/08/15/Project/Project-FTIndicator/")!))

    }

    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // add js methods for image click
        let string = "function getImages(){var objs = document.getElementsByTagName('img');var imgScr = '';for(var i=0;i<objs.length;i++){imgScr = imgScr + objs[i].src + '+';};return imgScr;};"
        
        webView.stringByEvaluatingJavaScript(from: string)
        let imageUrls = webView.stringByEvaluatingJavaScript(from: "getImages()")
        var urlArray = imageUrls?.components(separatedBy: "+")
        if  (urlArray?.count)! >= 2 {
            urlArray?.removeLast()
        }
        let stringsss = "function registerImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"
        webView.stringByEvaluatingJavaScript(from: stringsss)
        webView.stringByEvaluatingJavaScript(from: "registerImageClickAction();")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if request.url?.scheme == "image-preview" {
            let prString :String = "image-preview:"
//            var imageURL : String = (request.url?.absoluteString.substring(from: prString.endIndex))! as String
            let url :String = request.url?.absoluteString ?? ""
            let index = url.firstIndex(of: Character(prString)) ?? url.endIndex
            let beginning = url[..<index]
            // beginning is "Hello"
            
            // Convert the result to a String for long-term storage.
            var imageURL = String(beginning)
            imageURL = imageURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
            
            print("the url of the web image about to show is : \(imageURL)")
            
            // i don't have the way to get the image view for now
            
            FTImageViewer.sharedInstance.showImages([imageURL], atIndex: 0, fromSenderArray: [webView])
            
            
            return false
        }
        return true
        
    }
    

}

//extension UIWebView {
//
//    var windowSize : CGSize {
//        var size = CGSize.zero
//        size.width = CGFloat(NSString(string: (self.stringByEvaluatingJavaScript(from: "window.innerWidth"))!).floatValue)
//        size.height = CGFloat(NSString(string: (self.stringByEvaluatingJavaScript(from: "window.innerHeight"))!).floatValue)
//        return size
//    }
//    var scrollOffset : CGPoint {
//        var point = CGPoint.zero
//        point.x = CGFloat(NSString(string: (self.stringByEvaluatingJavaScript(from: "window.pageXOffset"))!).floatValue)
//        point.y = CGFloat(NSString(string: (self.stringByEvaluatingJavaScript(from: "window.pageYOffset"))!).floatValue)
//        return point
//    }
//}
//



