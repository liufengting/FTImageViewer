//
//  DetialViewController.swift
//  FTImageViewerDemo
//
//  Created by liufengting on 2016/10/27.
//  Copyright © 2016年 liufengting. All rights reserved.
//

import UIKit

class DetialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        let resource : FTImageResource = FTImageResource(image: sender.currentBackgroundImage, imageURLstring:nil)
        FTImageViewer.sharedInstance.showImages([resource], atIndex: 0, fromSenderArray: [sender])
    }

}
