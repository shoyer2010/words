//
//  ViewController.swift
//  words
//
//  Created by shoyer on 15/1/29.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import UIKit

class RankController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(0)
        
        var segment = UISegmentedControl(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 15, width: 200, height: 30))
        segment.insertSegmentWithTitle("活跃时间", atIndex: 0, animated: false)
        segment.insertSegmentWithTitle("掌握单词", atIndex: 1, animated: false)
        segment.addTarget(self, action: "onSegmentTapped:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(segment)
        
        var activeRankTableView = UITableView(frame: CGRect(x: 15, y: 60, width: self.view.frame.width - 30, height: self.view.frame.height - 60 - 40), style: UITableViewStyle.Plain)
        activeRankTableView.backgroundColor = UIColor.whiteColor()
        activeRankTableView.dataSource = self
        activeRankTableView.delegate = self
        self.view.addSubview(activeRankTableView)
        
        var myActiveRankLabel = UILabel(frame: CGRectMake(15, self.view.frame.height - 30, self.view.frame.width - 30, 20))
        myActiveRankLabel.text = "我的活跃时间2323小时，当前排名2323"
        self.view.addSubview(myActiveRankLabel)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 注意，实际数据填充的时候，这里要用可复用的cell， 资料；http://www.cnblogs.com/smileEvday/archive/2012/06/28/tableView.html
        var tableCell = UITableViewCell()
        tableCell.textLabel?.text = String(indexPath.row + 1)
        
        var usernameLable = UILabel()
        usernameLable.frame = CGRectMake(60, 8, 100, 20)
        usernameLable.text = "username"
        tableCell.contentView.addSubview(usernameLable)
        
        var timeLable = UILabel()
        timeLable.frame = CGRectMake(200, 8, 100, 20)
        timeLable.text = "2小时10分"
        tableCell.contentView.addSubview(timeLable)
        
        return tableCell
    }
    
    func onSegmentTapped(sender: UISegmentedControl) {
        println(sender.selectedSegmentIndex)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var homeController = self.parentViewController as HomeController
        
        if (offset < -70) {
            homeController.homeScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

