//
//  ViewController.swift
//  words
//
//  Created by shoyer on 15/1/29.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import UIKit

class RankController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, APIDataDelegate {
    var indicator: UIActivityIndicatorView!
    var rankTableView: UITableView!
    var myRankLabel: UILabel!
    
    var activeRankData: AnyObject!
    var wordRankData: AnyObject!
    
    var selectedSegmentIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: EventKey.ON_PAGE_CHAGNE, object: nil)
        
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(0)
        self.view.backgroundColor = Color.appBackground
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60))
        indicator.color = Color.red
        self.view.addSubview(indicator)
        
        var segment = UISegmentedControl(frame: CGRect(x: self.view.frame.width / 2 - 55, y: 15, width: 110, height: 26))
        segment.backgroundColor = UIColor.whiteColor()
        segment.tintColor = Color.red
        segment.insertSegmentWithTitle("活跃度", atIndex: 0, animated: false)
        segment.insertSegmentWithTitle("单词量", atIndex: 1, animated: false)
        segment.addTarget(self, action: "onSegmentTapped:", forControlEvents: UIControlEvents.ValueChanged)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        var rankTableViewWrap = UIView(frame: CGRect(x: 15, y: 55, width: self.view.frame.width - 30, height: self.view.frame.height - 85))
        rankTableViewWrap.backgroundColor = Color.blockBackground
        rankTableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        rankTableViewWrap.layer.shadowOffset = Layer.shadowOffset
        rankTableViewWrap.layer.shadowColor = Layer.shadowColor
        rankTableViewWrap.layer.shadowRadius = Layer.shadowRadius
        rankTableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        rankTableView = UITableView(frame: CGRect(x: 6, y: 6, width: rankTableViewWrap.frame.width - 12, height: rankTableViewWrap.frame.height - 12), style: UITableViewStyle.Plain)
        rankTableView.dataSource = self
        rankTableView.delegate = self
        rankTableView.layer.cornerRadius = Layer.cornerRadius
        rankTableView.separatorInset = UIEdgeInsets(top: 0, left: 0,  bottom: 0, right: 15)
        rankTableViewWrap.addSubview(rankTableView)
        self.view.addSubview(rankTableViewWrap)
        
        
        var myRankLabelWrap = UIView(frame: CGRectMake(15, self.view.frame.height - 22, self.view.frame.width - 30, 22))
        myRankLabelWrap.layer.shadowOpacity = Layer.shadowOpacity
        myRankLabelWrap.layer.shadowOffset = Layer.shadowOffset
        myRankLabelWrap.layer.shadowColor = Layer.shadowColor
        myRankLabelWrap.layer.shadowRadius = Layer.shadowRadius
        myRankLabelWrap.layer.cornerRadius = Layer.cornerRadius
        myRankLabelWrap.backgroundColor = Color.red

        myRankLabel = UILabel(frame: CGRect(x: 5, y: 4, width: myRankLabelWrap.frame.width, height: myRankLabelWrap.frame.height))
        myRankLabel.text = ""
        myRankLabelWrap.addSubview(myRankLabel)
        self.view.addSubview(myRankLabelWrap)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.selectedSegmentIndex == 0 && self.activeRankData != nil) {
            return (self.activeRankData!["rankList"] as NSArray).count
        }
        
        if (self.selectedSegmentIndex == 1 && self.wordRankData != nil) {
            return (self.wordRankData!["rankList"] as NSArray).count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var rankNumberLabelTag = 1000
        var usernameLableTag = 1001
        var timeLableTag = 1002
        var countLabelTag = 1003
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("rankCell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "rankCell")
            
            var rankNumberLabel = UILabel(frame: CGRect(x: 15, y: 3, width: 24, height: 24))
            rankNumberLabel.tag = rankNumberLabelTag
            rankNumberLabel.backgroundColor = Color.listIconBackground
            rankNumberLabel.text = ""
            rankNumberLabel.textColor = UIColor.whiteColor()
            rankNumberLabel.textAlignment = NSTextAlignment.Center
            rankNumberLabel.layer.cornerRadius = 12
            rankNumberLabel.layer.masksToBounds = true
            rankNumberLabel.font = UIFont(name: rankNumberLabel.font.fontName, size: CGFloat(12))
            cell!.contentView.addSubview(rankNumberLabel)
            
            var usernameLable = UILabel(frame: CGRect(x: tableView.frame.width * 0.25 , y: 4, width: tableView.frame.width * 0.4, height: 20))
            usernameLable.tag = usernameLableTag
            usernameLable.text = ""
            usernameLable.font = UIFont(name: usernameLable.font.fontName, size: CGFloat(17))
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            paragraphStyle.alignment = NSTextAlignment.Center
            var attributesForUsername = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: usernameLable.font,
                NSForegroundColorAttributeName: Color.listIconBackground,
                NSStrokeWidthAttributeName: NSNumber(float: -2.0)
                ])
            usernameLable.attributedText = NSAttributedString(string: usernameLable.text!, attributes: attributesForUsername)
            cell!.contentView.addSubview(usernameLable)
            
            var timeLable = UILabel(frame: CGRect(x: tableView.frame.width - 100 , y: 5, width: 85, height: 20))
            timeLable.tag = timeLableTag
            timeLable.text = ""
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
            cell!.contentView.addSubview(timeLable)
            
            var countLable = UILabel(frame: CGRect(x: tableView.frame.width - 55, y: 5, width: 55, height: 20))
            countLable.tag = countLabelTag
            countLable.text = ""
            countLable.font = UIFont(name: countLable.font.fontName, size: CGFloat(13))
            var paragraphStyleForCount = NSMutableParagraphStyle()
            paragraphStyleForCount.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            paragraphStyleForCount.alignment = NSTextAlignment.Right
            var attributesForCount = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyleForCount,
                NSFontAttributeName: countLable.font,
                NSForegroundColorAttributeName: Color.listIconBackground,
                NSStrokeWidthAttributeName: NSNumber(float: -1.0)
                ])
            countLable.attributedText = NSAttributedString(string: countLable.text!, attributes: attributesForCount)
            cell!.contentView.addSubview(countLable)
            
            cell!.userInteractionEnabled = false
        }
        
        
        if (self.selectedSegmentIndex == 0 && self.activeRankData != nil) {
            var dataArray = self.activeRankData!["rankList"] as NSArray
            (cell!.viewWithTag(rankNumberLabelTag) as UILabel).text = String(indexPath.row + 1)
            (cell!.viewWithTag(usernameLableTag) as UILabel).text = dataArray[indexPath.row]["username"] as? String
            var timeLabel = cell!.viewWithTag(timeLableTag) as UILabel
            timeLabel.text = Util.getStringFromSeconds(seconds: dataArray[indexPath.row]["seconds"] as Int)
            timeLabel.hidden = false
            
            var countLabel = cell!.viewWithTag(countLabelTag) as UILabel
            countLabel.hidden = true
        }
        
        if (self.selectedSegmentIndex == 1 && self.wordRankData != nil) {
            var dataArray = self.wordRankData!["rankList"] as NSArray
            (cell!.viewWithTag(rankNumberLabelTag) as UILabel).text = String(indexPath.row + 1)
            (cell!.viewWithTag(usernameLableTag) as UILabel).text = dataArray[indexPath.row]["username"] as? String
            var count = dataArray[indexPath.row]["count"] as Int
            var countLabel = cell!.viewWithTag(countLabelTag) as UILabel
            countLabel.text = "\(count)个"
            countLabel.hidden = false
            
            var timeLabel = cell!.viewWithTag(timeLableTag) as UILabel
            timeLabel.hidden = true
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(30)
    }
    
    func onSegmentTapped(sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        self.rankTableView.reloadData()
        self.reloadRankLabel()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var homeController = self.parentViewController as HomeController
        
        if (offset < Interaction.offsetForChangePage) {
            homeController.scrollToPageUpAndDown(page: 0)
        }
    }
    
    func onPageChange(notification: NSNotification) {
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.Rank) {
            loadData()
        }
    }
    
    func loadData() {
        if (self.activeRankData == nil) {
            var params = NSMutableDictionary()
            API.instance.get("/rank/active", delegate: self, params: params)
            self.startLoading()
        }
        
        if (self.wordRankData == nil) {
            var params = NSMutableDictionary()
            API.instance.get("/rank/masteredWords", delegate: self, params: params)
            self.startLoading()
        }
    }
    
    func rankActive(data: AnyObject) {
        self.activeRankData = data
        self.rankTableView.reloadData()
        self.reloadRankLabel()
        self.endLoading()
    }
    
    func rankMasteredWords(data: AnyObject) {
        self.wordRankData = data
        self.rankTableView.reloadData()
        self.reloadRankLabel()
        self.endLoading()
    }
    
    func reloadRankLabel() {
        if (self.selectedSegmentIndex == 0 && self.activeRankData != nil) {
            var mySeconds = self.activeRankData!.valueForKeyPath("myRank.seconds") as Int
            var myRank = self.activeRankData!.valueForKeyPath("myRank.rank") as Int
            self.myRankLabel.text = "我已活跃\(Util.getStringFromSeconds(seconds: mySeconds))，当前排名\(myRank)"
            myRankLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            paragraphStyle.lineSpacing = 7
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: myRankLabel.font,
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeWidthAttributeName: NSNumber(float: -2.0)
                ])
            myRankLabel.attributedText = NSAttributedString(string: myRankLabel.text!, attributes: attributes)
        }
        
        if (self.selectedSegmentIndex == 1 && self.wordRankData != nil) {
            var myCount = self.wordRankData!.valueForKeyPath("myRank.count") as Int
            var myRank = self.wordRankData!.valueForKeyPath("myRank.rank") as Int
            self.myRankLabel.text = "我已掌握\(myCount)个单词，当前排名\(myRank)"
            myRankLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            paragraphStyle.lineSpacing = 7
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: myRankLabel.font,
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeWidthAttributeName: NSNumber(float: -2.0)
                ])
            myRankLabel.attributedText = NSAttributedString(string: myRankLabel.text!, attributes: attributes)
        }
    }
    
    func error(error: Error, api: String) {
        println(error.getMessage())
        self.endLoading()
    }
    
    func startLoading() {
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func endLoading() {
        self.indicator.stopAnimating()
    }
}

