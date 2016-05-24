//
//  ViewController.swift
//  FTImageViewerDemo
//
//  Created by liufengting on 16/5/21.
//  Copyright © 2016年 liufengting. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var data : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [["http://ww3.sinaimg.cn/mw600/005vbOHfgw1f45hydho90j30h80q043l.jpg","http://ww3.sinaimg.cn/mw600/6cca1403jw1f45gvsjmvuj20bo0gnq3e.jpg","http://ww4.sinaimg.cn/mw600/005WRDhNjw1f44bhkr2u9j30g40c33z2.jpg","http://ww1.sinaimg.cn/mw600/9ec19de8gw1f3qn4fh0jhj20p10zk7ck.jpg"],
                ["http://ww3.sinaimg.cn/mw600/005vbOHfgw1f45hydho90j30h80q043l.jpg","http://ww3.sinaimg.cn/mw600/6cca1403jw1f45gvsjmvuj20bo0gnq3e.jpg","http://ww4.sinaimg.cn/mw600/005WRDhNjw1f44bhkr2u9j30g40c33z2.jpg"],
                ["http://ww3.sinaimg.cn/mw600/005vbOHfgw1f45hydho90j30h80q043l.jpg","http://ww3.sinaimg.cn/mw600/6cca1403jw1f45gvsjmvuj20bo0gnq3e.jpg","http://ww4.sinaimg.cn/mw600/005WRDhNjw1f44bhkr2u9j30g40c33z2.jpg","http://ww1.sinaimg.cn/mw600/9ec19de8gw1f3qn4fh0jhj20p10zk7ck.jpg","http://ww3.sinaimg.cn/mw600/9ec19de8gw1f14kw90rcmj20p10zkn3u.jpg","http://ww2.sinaimg.cn/mw600/006fVPCvjw1f43gg54kmnj31kw11xtj1.jpg","http://ww3.sinaimg.cn/mw600/005WRDhNjw1f4391wuf2qj30ia0c6gmt.jpg"],
                ["http://ww3.sinaimg.cn/mw600/005vbOHfgw1f45hydho90j30h80q043l.jpg","http://ww3.sinaimg.cn/mw600/6cca1403jw1f45gvsjmvuj20bo0gnq3e.jpg","http://ww4.sinaimg.cn/mw600/005WRDhNjw1f44bhkr2u9j30g40c33z2.jpg","http://ww1.sinaimg.cn/mw600/9ec19de8gw1f3qn4fh0jhj20p10zk7ck.jpg","http://ww3.sinaimg.cn/mw600/9ec19de8gw1f14kw90rcmj20p10zkn3u.jpg","http://ww2.sinaimg.cn/mw600/006fVPCvjw1f43gg54kmnj31kw11xtj1.jpg","http://ww3.sinaimg.cn/mw600/005WRDhNjw1f4391wuf2qj30ia0c6gmt.jpg"],
                ["http://ww3.sinaimg.cn/mw600/005vbOHfgw1f45hydho90j30h80q043l.jpg","http://ww3.sinaimg.cn/mw600/6cca1403jw1f45gvsjmvuj20bo0gnq3e.jpg","http://ww4.sinaimg.cn/mw600/005WRDhNjw1f44bhkr2u9j30g40c33z2.jpg","http://ww1.sinaimg.cn/mw600/9ec19de8gw1f3qn4fh0jhj20p10zk7ck.jpg","http://ww3.sinaimg.cn/mw600/9ec19de8gw1f14kw90rcmj20p10zkn3u.jpg","http://ww2.sinaimg.cn/mw600/006fVPCvjw1f43gg54kmnj31kw11xtj1.jpg","http://ww3.sinaimg.cn/mw600/005WRDhNjw1f4391wuf2qj30ia0c6gmt.jpg","http://ww2.sinaimg.cn/mw600/cd7861dcgw1f437w0fx03j20hs0t10v8.jpg","http://ww2.sinaimg.cn/mw600/005vbOHfgw1f436eq9buvj30v318g42w.jpg"]]

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : DemoTableViewCell = tableView.dequeueReusableCellWithIdentifier("DemoTableViewCellIdentifier", forIndexPath: indexPath) as! DemoTableViewCell

        cell.imageArray = data[indexPath.row]
        
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}

