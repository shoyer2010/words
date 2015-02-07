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
        self.view.backgroundColor = Color.appBackground
        
        var segment = UISegmentedControl(frame: CGRect(x: self.view.frame.width / 2 - 55, y: 15, width: 110, height: 26))
        segment.backgroundColor = UIColor.whiteColor()
        segment.tintColor = Color.red
        segment.insertSegmentWithTitle("活跃度", atIndex: 0, animated: false)
        segment.insertSegmentWithTitle("单词量", atIndex: 1, animated: false)
        segment.addTarget(self, action: "onSegmentTapped:", forControlEvents: UIControlEvents.ValueChanged)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        var activeRankTableViewWrap = UIView(frame: CGRect(x: 15, y: 55, width: self.view.frame.width - 30, height: self.view.frame.height - 85))
        activeRankTableViewWrap.backgroundColor = Color.blockBackground
        activeRankTableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        activeRankTableViewWrap.layer.shadowOffset = Layer.shadowOffset
        activeRankTableViewWrap.layer.shadowColor = Layer.shadowColor
        activeRankTableViewWrap.layer.shadowRadius = Layer.shadowRadius
        activeRankTableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        var activeRankTableView = UITableView(frame: CGRect(x: 5, y: 5, width: activeRankTableViewWrap.frame.width - 10, height: activeRankTableViewWrap.frame.height - 10), style: UITableViewStyle.Plain)
        activeRankTableView.dataSource = self
        activeRankTableView.delegate = self
        activeRankTableView.layer.cornerRadius = Layer.cornerRadius
        activeRankTableView.separatorInset = UIEdgeInsets(top: 0, left: 0,  bottom: 0, right: 15)
        activeRankTableViewWrap.addSubview(activeRankTableView)
        self.view.addSubview(activeRankTableViewWrap)
        
        
        var myActiveRankLabelWrap = UIView(frame: CGRectMake(15, self.view.frame.height - 22, self.view.frame.width - 30, 22))
        myActiveRankLabelWrap.layer.shadowOpacity = Layer.shadowOpacity
        myActiveRankLabelWrap.layer.shadowOffset = Layer.shadowOffset
        myActiveRankLabelWrap.layer.shadowColor = Layer.shadowColor
        myActiveRankLabelWrap.layer.shadowRadius = Layer.shadowRadius
        myActiveRankLabelWrap.layer.cornerRadius = Layer.cornerRadius
        myActiveRankLabelWrap.backgroundColor = Color.red

        var myActiveRankLabel = UILabel(frame: CGRect(x: 5, y: 4, width: myActiveRankLabelWrap.frame.width, height: myActiveRankLabelWrap.frame.height))
        myActiveRankLabel.text = "我的活跃时间2323小时，当前排名2323"
        myActiveRankLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.lineSpacing = 7
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: myActiveRankLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        myActiveRankLabel.attributedText = NSAttributedString(string: myActiveRankLabel.text!, attributes: attributes)
        myActiveRankLabelWrap.addSubview(myActiveRankLabel)
        self.view.addSubview(myActiveRankLabelWrap)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 注意，实际数据填充的时候，这里要用可复用的cell， 资料；http://www.cnblogs.com/smileEvday/archive/2012/06/28/tableView.html
        
        var tableCell = UITableViewCell()
        
        var rankNumberLabel = UILabel(frame: CGRect(x: 15, y: 3, width: 24, height: 24))
        rankNumberLabel.backgroundColor = Color.listIconBackground
        rankNumberLabel.text = String(indexPath.row + 1)
        rankNumberLabel.textColor = UIColor.whiteColor()
        rankNumberLabel.textAlignment = NSTextAlignment.Center
        rankNumberLabel.layer.cornerRadius = 12
        rankNumberLabel.layer.masksToBounds = true
        rankNumberLabel.font = UIFont(name: rankNumberLabel.font.fontName, size: CGFloat(12))
        tableCell.contentView.addSubview(rankNumberLabel)
        
        var usernameLable = UILabel(frame: CGRect(x: tableView.frame.width * 0.27 , y: 4, width: tableView.frame.width * 0.33, height: 20))
        usernameLable.text = "username"
        usernameLable.font = UIFont(name: usernameLable.font.fontName, size: CGFloat(15))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.Center
        var attributesForUsername = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: usernameLable.font,
            NSForegroundColorAttributeName: Color.listIconBackground,
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        usernameLable.attributedText = NSAttributedString(string: usernameLable.text!, attributes: attributesForUsername)
        tableCell.contentView.addSubview(usernameLable)
        
        var timeLable = UILabel(frame: CGRect(x: tableView.frame.width * 0.7 , y: 5, width: tableView.frame.width * 0.3 - 15, height: 20))
        timeLable.text = "2小时10分"
        timeLable.font = UIFont(name: timeLable.font.fontName, size: CGFloat(13))
        var paragraphStyleForTime = NSMutableParagraphStyle()
        paragraphStyleForTime.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyleForTime.alignment = NSTextAlignment.Right
        var attributesForTime = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForTime,
            NSFontAttributeName: timeLable.font,
            NSForegroundColorAttributeName: Color.listIconBackground,
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        timeLable.attributedText = NSAttributedString(string: timeLable.text!, attributes: attributesForTime)
        tableCell.contentView.addSubview(timeLable)
        
        tableCell.userInteractionEnabled = false
        
        return tableCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(30)
    }
    
    func onSegmentTapped(sender: UISegmentedControl) {
        println(sender.selectedSegmentIndex)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var homeController = self.parentViewController as HomeController
        
        if (offset < -70) {
            homeController.scrollToPageUpAndDown(page: 0)
        }
    }
}

