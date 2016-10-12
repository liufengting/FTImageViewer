//
//  ViewController.swift
//  FTImageViewerDemo
//
//  Created by liufengting https://github.com/liufengting on 16/5/21.
//  Copyright © 2016年 liufengting. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var data : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [
            ["http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff6csucjj20gt0aijrh.jpg",
                "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg"],
            ["http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg"],
            ["http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg"],
            ["http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff6csucjj20gt0aijrh.jpg",
                "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg"],
            ["http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff6csucjj20gt0aijrh.jpg",
                "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg"],
            ["http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff6csucjj20gt0aijrh.jpg",
                "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg"]]
        
        data.append(contentsOf: data)
        data.append(contentsOf: data)
        data.append(contentsOf: data)


        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DemoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCellIdentifier", for: indexPath) as! DemoTableViewCell
        cell.name = "Person \((indexPath as NSIndexPath).row)"
        cell.content = "Person \((indexPath as NSIndexPath).row) said this is a great demo, if you like it, please give me a 'star' or fork the project. I will continue making some more Liberary for you."
        
        cell.imageArray = data[(indexPath as NSIndexPath).row]

        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

