//
//  StatisticsController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIkit

class StatisticsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate {
    var tableView: UITableView!
    var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: EventKey.ON_PAGE_CHAGNE, object: nil)
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(1)
        
        self.view.backgroundColor = Color.appBackground
        
        var tableViewWrap = UIView(frame: CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: 131))
        tableViewWrap.backgroundColor = Color.blockBackground
        tableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        tableViewWrap.layer.shadowOffset = Layer.shadowOffset
        tableViewWrap.layer.shadowColor = Layer.shadowColor
        tableViewWrap.layer.shadowRadius = Layer.shadowRadius
        tableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        tableView = UITableView(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 12))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = Layer.cornerRadius
        tableView.layer.masksToBounds = true
        tableView.scrollEnabled = false
        tableView.separatorInset = UIEdgeInsetsZero
        
        if (tableView.respondsToSelector("setLayoutMargins:")) {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        
        tableView.userInteractionEnabled = false
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var tableHeader = UIView(frame: CGRect(x: 15, y: 20, width: tableView.frame.width, height: 30))
        tableHeader.backgroundColor = Color.red.colorWithAlphaComponent(0.9)
        var learingLabel = UILabel(frame: CGRect(x:  60, y: 0, width: (tableHeader.frame.width - 60) * 0.33, height: 30))
        learingLabel.text = "已学习"
        learingLabel.font = UIFont(name: learingLabel.font.fontName, size: CGFloat(14))
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: learingLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
        ])
        learingLabel.attributedText = NSAttributedString(string: learingLabel.text!, attributes: attributes)
        tableHeader.addSubview(learingLabel)
        
        var haveLearnedLabel = UILabel(frame: CGRect(x: 60 + (tableHeader.frame.width - 60) * 0.33, y: 0, width: (tableHeader.frame.width - 60) * 0.33, height: 30))
        haveLearnedLabel.text = "已复习"
        haveLearnedLabel.font = UIFont(name: haveLearnedLabel.font.fontName, size: CGFloat(14))
        var attributesForHaveLearnedLabel = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: haveLearnedLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        haveLearnedLabel.attributedText = NSAttributedString(string: haveLearnedLabel.text!, attributes: attributesForHaveLearnedLabel)
        tableHeader.addSubview(haveLearnedLabel)
        
        var haveMasteredLabel = UILabel(frame: CGRect(x: 60 + (tableHeader.frame.width - 60) * 0.66, y: 0, width: (tableHeader.frame.width - 60) * 0.33, height: 30))
        haveMasteredLabel.text = "已掌握"
        haveMasteredLabel.font = UIFont(name: haveMasteredLabel.font.fontName, size: CGFloat(14))
        var attributesForHaveMasteredLabel = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: haveMasteredLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        haveMasteredLabel.attributedText = NSAttributedString(string: haveMasteredLabel.text!, attributes: attributesForHaveMasteredLabel)
        tableHeader.addSubview(haveMasteredLabel)
        tableView.tableHeaderView = tableHeader
        tableViewWrap.addSubview(tableView)
        
        shareButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height * 0.8, width: 150, height: 30))
        shareButton.setTitle("分享晒晒", forState: UIControlState.Normal)
        shareButton.backgroundColor = Color.gray
        shareButton.addTarget(self, action: "onShareButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(shareButton)
        
        self.view.addSubview(tableViewWrap)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(30)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        cell.separatorInset = UIEdgeInsetsZero
        
        if (cell.respondsToSelector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        
        var todayLabel = UILabel(frame: CGRect(x: 25, y: 3, width: 24, height: 24))
        todayLabel.backgroundColor = Color.listIconBackground
        switch (indexPath.row) {
        case 0:
            todayLabel.text = "今日"
        case 1:
            todayLabel.text = "本周"
        case 2:
            todayLabel.text = "本月"
        default:
            break
        }
        todayLabel.textColor = Color.white
        todayLabel.textAlignment = NSTextAlignment.Center
        todayLabel.font = UIFont(name: todayLabel.font.fontName, size: CGFloat(11))
        todayLabel.layer.cornerRadius = 12
        todayLabel.layer.masksToBounds = true
        cell.addSubview(todayLabel)
        
        var learnLabel = UILabel(frame: CGRect(x: 60, y: 0, width: (tableView.frame.width - 60) * 0.33, height: 30))
        switch (indexPath.row) {
        case 0:
            learnLabel.text = "\(DictionaryUtil.getWordCountHaveLearned(DateUtil.startOfThisDay()))"
        case 1:
            learnLabel.text = "\(DictionaryUtil.getWordCountHaveLearned(DateUtil.startOfThisWeek()))"
        case 2:
            learnLabel.text = "\(DictionaryUtil.getWordCountHaveLearned(DateUtil.startOfThisMonth()))"
        default:
            break
        }
        learnLabel.textColor = Color.gray
        learnLabel.font = UIFont(name: learnLabel.font.fontName, size: CGFloat(14))
        learnLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(learnLabel)
        
        var relearnLabel = UILabel(frame: CGRect(x: 60 + (tableView.frame.width - 60) * 0.33, y: 0, width: (tableView.frame.width - 60) * 0.33, height: 30))
        switch (indexPath.row) {
        case 0:
            relearnLabel.text = "\(DictionaryUtil.getWordCountHaveReviewed(DateUtil.startOfThisDay()))"
        case 1:
            relearnLabel.text = "\(DictionaryUtil.getWordCountHaveReviewed(DateUtil.startOfThisWeek()))"
        case 2:
            relearnLabel.text = "\(DictionaryUtil.getWordCountHaveReviewed(DateUtil.startOfThisMonth()))"
        default:
            break
        }
        relearnLabel.textColor = Color.gray
        relearnLabel.font = UIFont(name: relearnLabel.font.fontName, size: CGFloat(14))
        relearnLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(relearnLabel)
        
        var masterLabel = UILabel(frame: CGRect(x: 60 + (tableView.frame.width - 60) * 0.66, y: 0, width: (tableView.frame.width - 60) * 0.33, height: 30))
        switch (indexPath.row) {
        case 0:
            masterLabel.text = "\(DictionaryUtil.getWordCountHaveMastered(DateUtil.startOfThisDay()))"
        case 1:
            masterLabel.text = "\(DictionaryUtil.getWordCountHaveMastered(DateUtil.startOfThisWeek()))"
        case 2:
            masterLabel.text = "\(DictionaryUtil.getWordCountHaveMastered(DateUtil.startOfThisMonth()))"
        default:
            break
        }
        masterLabel.textColor = Color.gray
        masterLabel.font = UIFont(name: masterLabel.font.fontName, size: CGFloat(14))
        masterLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(masterLabel)

        return cell
    }
    
    func onPageChange(notification: NSNotification) {
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.Statistics) {
            self.tableView.reloadData()
        }
    }
    
    func onShareButtonTapped(sender: UIButton) {
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: Settings.UMENG_APP_KEY, shareText: "自从有了词圣，妈妈再也不用担心我背单词了，快来试试吧", shareImage: nil, shareToSnsNames: NSArray(array: [UMShareToSms, UMShareToEmail, UMShareToQQ, UMShareToQzone, UMShareToWechatTimeline, UMShareToWechatSession, UMShareToSina, UMShareToRenren, UMShareToDouban]), delegate: self)
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        
        if (response.responseCode.value == UMSResponseCodeSuccess.value) {
            println("分享成功")
        } else {
            println(response)
        }
    }
    
}