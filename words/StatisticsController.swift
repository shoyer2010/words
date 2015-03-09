//
//  StatisticsController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIkit

class StatisticsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate, APIDataDelegate {
    var tableView: UITableView!
    var shareButton: UIButton!
    var seconds: Int?
    var shareText: NSString!
    
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
        
        shareButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height - 80, width: 150, height: 32))
        shareButton.setTitle("分享晒晒", forState: UIControlState.Normal)
        shareButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        shareButton.backgroundColor = Color.gray
        shareButton.addTarget(self, action: "onShareButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        shareButton.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        shareButton.addTarget(self, action: "onTouchUp:", forControlEvents: UIControlEvents.TouchUpInside | UIControlEvents.TouchUpOutside)
        self.view.addSubview(shareButton)
        
        self.view.addSubview(tableViewWrap)
    }
    
    func onTouchDown(sender: UIButton) {
        sender.backgroundColor = Color.red
    }
    
    func onTouchUp(sender: UIButton) {
        sender.backgroundColor = Color.gray
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
        var randomTitles = [
            "还在为背单词发愁？《词圣》comes to rescue",
            "还在等什么，别人都又进步了",
            "你不努力，有人替你努力",
            "自从有了《词圣》,感觉自己把英语踩在了脚下",
            "看气度不凡，老夫传授一秘籍给你",
            "我看你是万中无一的奇才，拯救世界的重任就交给你了",
            "来，来，来，看看别人是怎么记单词的"
        ]
        
        var title = randomTitles[Util.getRandomInt(from: 0, to: randomTitles.count - 1)]
        UMSocialData.setAppKey(Settings.UMENG_APP_KEY)
        
        // QQ and Qzone
        UMSocialQQHandler.setQQWithAppId(Settings.QQ_APP_ID, appKey: Settings.QQ_APP_KEY, url: Util.appURL())
        UMSocialData.defaultData().extConfig.qqData.url = Util.appURL()
        UMSocialData.defaultData().extConfig.qzoneData.url = Util.appURL()
        UMSocialData.defaultData().extConfig.qqData.title = title
        UMSocialData.defaultData().extConfig.qzoneData.title = title
        UMSocialData.defaultData().extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault
        
        
        // wechat
        UMSocialWechatHandler.setWXAppId(Settings.WEI_XIN_APP_ID, appSecret: Settings.WEI_XIN_APP_SECRET, url: Settings.WEI_XIN_URL)
        UMSocialData.defaultData().extConfig.wechatSessionData.url = Util.appURL()
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = Util.appURL()
        UMSocialData.defaultData().extConfig.wechatSessionData.title = title
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = title
        
        // sina
        UMSocialSinaHandler.openSSOWithRedirectURL(nil)
        
        
        var randomTips = [
            "自从有了《词圣》，妈妈再也不用担心我背单词了，快来试试吧",
            "投资自己最好的方式就是学习",
            "不积跬步，无以至千里",
            "不积小流，无以成江海",
            "日积月累，方可休成正果",
            "少壮不努力，老大徙伤悲",
            "你不努力，别人在努力",
            "不要给自己的懒惰找任何理由",
            "人生有两件事最值得投资，一件是健康，一件是学习",
            "背单词这件事，没有捷径，继续吧",
            "学英语并不难，难的是你能记住多少个单词",
            "悄悄告诉你一个好用的app, 我不轻易告诉别人的",
            "",
        ]
        
        var appURL = Util.appURL()
        
        var shareText = randomTips[Util.getRandomInt(from: 0, to: randomTips.count - 1)]
        
        if (shareText as NSString).length < 1 {
            shareText = "今日已学习\(DictionaryUtil.getWordCountHaveLearned(DateUtil.startOfThisDay()))个单词，不服来战！"
        }
        
        if (appURL != nil) {
            shareText += "  " + appURL!
        }
        
        self.shareText = shareText
        
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: Settings.UMENG_APP_KEY, shareText: shareText, shareImage: UIImage(named: "share"), shareToSnsNames: NSArray(array: [UMShareToSms, UMShareToQQ, UMShareToQzone, UMShareToWechatTimeline, UMShareToWechatSession, UMShareToSina, UMShareToRenren, UMShareToDouban]), delegate: self)
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        
        if (response.responseCode.value == UMSResponseCodeSuccess.value) {
            self.seconds = nil
            var params = NSMutableDictionary()
            params.setValue(self.shareText, forKey: "shareText")
            API.instance.post("/user/reclaimShareService", delegate: self, params: params)
        }
    }
    
    func userReclaimShareService(data: AnyObject) {
        self.seconds = data["seconds"] as? Int
        if (seconds != nil) {
            var dayString = NSString(format: "%.1f", Float(seconds!) / Float(86400))
            SuccessView(view: self.view, message: "服务天数增加\(dayString)天")
            self.seconds = nil
        }
    }
    
    func error(error: Error, api: String) {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25))
        self.view.addSubview(view)
        ErrorView(view: view, message: error.getMessage(),completion: {() in
            view.removeFromSuperview()
        })
    }
}