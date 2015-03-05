//
//  SettingsController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UIViewController, APIDataDelegate, UIAlertViewDelegate {
    var upgradeButton: UIButton!
    var encourageUsButton: UIButton!
    var cachedLabel: UILabel!
    var upgradeUrl: NSURL!
    var appUrl: NSURL!
    
    var alertViewForClearCache: UIAlertView!
    var alertViewForVersionCheck: UIAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoginSuccess:", name: EventKey.ON_LOGIN_SUCCESS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: EventKey.ON_PAGE_CHAGNE, object: nil)
        
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(3)
        self.view.backgroundColor = Color.appBackground
        
        var shouldNotifyLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 200, height: 30))
        shouldNotifyLabel.text = "学习提醒"
        self.view.addSubview(shouldNotifyLabel)
        
        var shouldNotify = UISwitch(frame: CGRect(x: self.view.frame.width - 65, y: 17, width: 100, height: 20))
        shouldNotify.onTintColor = Color.red
        shouldNotify.addTarget(self, action: "onShouldNotify:", forControlEvents: UIControlEvents.TouchUpInside)
        var shouldNotifyValue = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.SHOULD_NOTIFY) as? Bool
        if (shouldNotifyValue == nil) {
            shouldNotifyValue = true
        }
        shouldNotify.setOn(shouldNotifyValue!, animated: true)
        NSUserDefaults.standardUserDefaults().setObject(shouldNotifyValue!, forKey: CacheKey.SHOULD_NOTIFY)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.view.addSubview(shouldNotify)
        
        var wordShouldAutoVoiceLabel = UILabel(frame: CGRect(x: 15, y: 85, width: 200, height: 20))
        wordShouldAutoVoiceLabel.text = "单词自动发音"
        self.view.addSubview(wordShouldAutoVoiceLabel)
        
        var wordShouldAutoVoice = UISwitch(frame: CGRect(x: self.view.frame.width - 65, y: 77, width: 100, height: 20))
        wordShouldAutoVoice.onTintColor = Color.red
        wordShouldAutoVoice.addTarget(self, action: "onShouldAutoVoice:", forControlEvents: UIControlEvents.TouchUpInside)
        var shouldAutoVoiceValue = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.WORD_AUTO_VOICE) as? Bool
        if (shouldAutoVoiceValue == nil) {
            shouldAutoVoiceValue = true
        }
        wordShouldAutoVoice.setOn(shouldAutoVoiceValue!, animated: true)
        NSUserDefaults.standardUserDefaults().setObject(shouldAutoVoiceValue!, forKey: CacheKey.WORD_AUTO_VOICE)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.view.addSubview(wordShouldAutoVoice)
        
        var sentenceShouldAutoVoiceLabel = UILabel(frame: CGRect(x: 15, y: 145, width: 200, height: 20))
        sentenceShouldAutoVoiceLabel.text = "例句自动发音"
        self.view.addSubview(sentenceShouldAutoVoiceLabel)
        
        var sentenceShouldAutoVoice = UISwitch(frame: CGRect(x: self.view.frame.width - 65, y: 137, width: 100, height: 20))
        sentenceShouldAutoVoice.onTintColor = Color.red
        sentenceShouldAutoVoice.addTarget(self, action: "onSentenceShouldAutoVoice:", forControlEvents: UIControlEvents.TouchUpInside)
        var sentenceShouldAutoVoiceValue = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.SENTENCE_AUTO_VOICE) as? Bool
        if (sentenceShouldAutoVoiceValue == nil) {
            sentenceShouldAutoVoiceValue = true
        }
        sentenceShouldAutoVoice.setOn(sentenceShouldAutoVoiceValue!, animated: true)
        NSUserDefaults.standardUserDefaults().setObject(shouldAutoVoiceValue!, forKey: CacheKey.SENTENCE_AUTO_VOICE)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.view.addSubview(sentenceShouldAutoVoice)
        
        cachedLabel = UILabel(frame: CGRect(x: 15, y: 200, width: 150, height: 20))
        cachedLabel.text = "缓存占用: " + self.getCacheFileSize()
        self.view.addSubview(cachedLabel)
        
        var clearButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 193, width: 70, height: 30))
        clearButton.backgroundColor = Color.gray
        clearButton.setTitle("清理", forState: UIControlState.Normal)
        clearButton.layer.cornerRadius = 15
        clearButton.addTarget(self, action: "onTapDown:", forControlEvents: UIControlEvents.TouchDown)
        clearButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpInside)
        clearButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        clearButton.addTarget(self, action: "clearCache:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(clearButton)
        
        var versionLabel = UILabel(frame: CGRect(x: 15, y: 255, width: 150, height: 20))
        versionLabel.text = "当前版本:" + Util.getVersion()
        self.view.addSubview(versionLabel)
        
        upgradeButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 248, width: 70, height: 30))
        upgradeButton.backgroundColor = Color.gray
        upgradeButton.hidden = true
        upgradeButton.setTitle("升级", forState: UIControlState.Normal)
        upgradeButton.layer.cornerRadius = 15
        upgradeButton.addTarget(self, action: "onTapDown:", forControlEvents: UIControlEvents.TouchDown)
        upgradeButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpInside)
        upgradeButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        upgradeButton.addTarget(self, action: "upgradeApp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(upgradeButton)
        
        encourageUsButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height * 0.8, width: 150, height: 30))
        encourageUsButton.setTitle("求个好评", forState: UIControlState.Normal)
        encourageUsButton.backgroundColor = Color.gray
        self.refreshEncourageUsButton()
        encourageUsButton.addTarget(self, action: "onTapDown:", forControlEvents: UIControlEvents.TouchDown)
        encourageUsButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpInside)
        encourageUsButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        encourageUsButton.addTarget(self, action: "goToAppstore:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(encourageUsButton)
    }
    
    func onTapDown(sender: UIButton) {
        sender.backgroundColor = Color.red
    }
    
    func onTapUp(sender: UIButton) {
        sender.backgroundColor = Color.gray
    }
    
    func onShouldAutoVoice(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setObject(sender.on, forKey: CacheKey.WORD_AUTO_VOICE)
        NSUserDefaults.standardUserDefaults().synchronize()
        MobClick.event("onShouldAutoVoice", attributes: ["on": sender.on])
    }
    
    func onSentenceShouldAutoVoice(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setObject(sender.on, forKey: CacheKey.SENTENCE_AUTO_VOICE)
        NSUserDefaults.standardUserDefaults().synchronize()
        MobClick.event("onSentenceShouldAutoVoice", attributes: ["on": sender.on])
    }
    
    func onShouldNotify(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setObject(sender.on, forKey: CacheKey.SHOULD_NOTIFY)
        NSUserDefaults.standardUserDefaults().synchronize()
        MobClick.event("onShouldNotify", attributes: ["on": sender.on])
    }
    
    func onPageChange(notification: NSNotification) {
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.Settings) {
            cachedLabel.text = "缓存占用: " + self.getCacheFileSize()
        }
    }
    
    func clearCache(sender: UIButton) {
        alertViewForClearCache = UIAlertView(title: "清理缓存", message: "缓存中存的不是太重要的文件，但还是有用的，比如单词和例句的发音之类的，清理后，下次使用的时候如果发现没有，会重新下载，不清理，能省流量，离线无网络照样能使用，Are we clear？", delegate: self, cancelButtonTitle: "不清理，省流量")
        alertViewForClearCache.addButtonWithTitle("释放空间")
        alertViewForClearCache.delegate = self
        alertViewForClearCache.show()
        MobClick.event("clearCache")
    }
    
    func getCacheFileSize() -> NSString {
        var size = 0
        var files: NSArray? = NSFileManager.defaultManager().subpathsAtPath(Util.getCachePath())
        if (files != nil) {
            for filename in files! {
                var filesize = NSFileManager.defaultManager().attributesOfItemAtPath(Util.getCacheFilePath(filename as String), error: nil)?["NSFileSize"] as Int
                size += filesize
            }
        }
        
        return NSString(format: "%.1f MB", Float(size) / (1024.0 * 1024.0))
    }
    
    func upgradeApp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(self.upgradeUrl)
        MobClick.event("upgradeApp")
    }
    
    func goToAppstore(sender: UIButton) {
        UIApplication.sharedApplication().openURL(self.appUrl)
        MobClick.event("goToAppstore")
    }
    
    func onLoginSuccess(notification: NSNotification) {
        var params = NSMutableDictionary()
        params.setValue(1, forKey: "platform")
        params.setValue(Util.getVersion(), forKey: "version")
        API.instance.get("/version/check", delegate: self, params: params)
        
        var url: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.APP_URL)
        if (url == nil) {
            API.instance.get("/version/url", delegate: self, params: params)
        }
    }
    
    func versionCheck(data: AnyObject) {
        if (data["version"] != nil) {
            self.upgradeButton.hidden = false
            self.upgradeUrl = NSURL(string: data["url"] as String)
            if (data["force"] as Bool) {
                alertViewForVersionCheck = UIAlertView(title: "好消息！", message: "亲，我们不建议您继续使用此版本，好吧，这不是建议，请升级至最新版本", delegate: self, cancelButtonTitle: "被迫升级")
                alertViewForVersionCheck.show()
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if (alertView == alertViewForVersionCheck?) {
            if (buttonIndex == 0) {
                UIApplication.sharedApplication().openURL(self.upgradeUrl)
            }
        }
        
        if (alertView == self.alertViewForClearCache?) {
            if (buttonIndex == 0) {
                return
            }
            
            if (buttonIndex == 1) {
                var path = Util.getCachePath()
                var files: NSArray? = NSFileManager.defaultManager().subpathsAtPath(path)
                if (files != nil) {
                    for filename in files! {
                        NSFileManager.defaultManager().removeItemAtPath(path + "/" + (filename as String), error: nil)
                    }
                }
                
                cachedLabel.text = "缓存占用: " + self.getCacheFileSize()
            }
        }
    }
    
    func versionUrl(data: AnyObject) {
        if (data["url"] != nil) {
            NSUserDefaults.standardUserDefaults().setObject(data["url"] as String, forKey: CacheKey.APP_URL)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.refreshEncourageUsButton()
        }
    }
    
    func refreshEncourageUsButton() {
        var url: String? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.APP_URL) as? String
        if (url == nil) {
            encourageUsButton.hidden = true
        } else {
            encourageUsButton.hidden = false
            self.appUrl = NSURL(string: url!)
        }
    }
}