//
//  AppDelegate.swift
//  words
//
//  Created by shoyer on 15/1/29.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var activeTime: Int!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        println(Util.getFilePath("dfa"))
        application.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController = ApplicationController()
        self.window!.makeKeyAndVisible()
        
//        NSThread.sleepForTimeInterval(1)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        
        
        if (application.respondsToSelector("registerUserNotificationSettings:")) {
            var notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
        
        var randomTips = [
            "复习单词的时间到了哦",
            "投资自己最好的方式就是学习",
            "不积跬步，无以至千里",
            "不积小流，无以成江海",
            "日积月累，方可休成正果",
            "少壮不努力，老大徙伤悲",
            "你不努力，别人在努力",
            "不要给自己的懒惰找任何理由",
            "人生有两件事最值得投资，一件是健康，一件是学习",
            "背单词这件事，没有捷径，继续吧",
        ]
        var shouldNotifyValue = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.SHOULD_NOTIFY) as? Bool
        if (shouldNotifyValue != nil && shouldNotifyValue!) {
            var localNotification = UILocalNotification()
            localNotification.fireDate = NSDate(timeIntervalSince1970: NSTimeInterval(DateUtil.startOfThisDay() + 45000)) // 12:30提醒  慢了8个时间晚上8:30
            localNotification.repeatInterval = NSCalendarUnit.DayCalendarUnit
            localNotification.timeZone = NSTimeZone.localTimeZone()
            localNotification.alertBody = randomTips[Util.getRandomInt(from: 0, to: randomTips.count - 1)]
            localNotification.alertAction = "复习单词"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        
//        MobClick.setLogEnabled(true)
        MobClick.startWithAppkey(Settings.UMENG_APP_KEY, reportPolicy: SENDWIFIONLY, channelId: "AppStore")
        MobClick.setAppVersion(Util.getVersion())
        
        UMSocialData.setAppKey(Settings.UMENG_APP_KEY)
        
        
        UMSocialWechatHandler.setWXAppId(Settings.WEI_XIN_APP_ID, appSecret: Settings.WEI_XIN_APP_SECRET, url: Settings.WEI_XIN_URL)
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com"; TODO: app 下载地址
        // [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
        // [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
        //[UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈title";
        // [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
        
        
        UMSocialSinaHandler.openSSOWithRedirectURL(nil)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        self.activeTime = time(nil) - self.activeTime
        var totalTime: Int? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.ACTIVE_TIME) as? Int
        if (totalTime == nil) {
            NSUserDefaults.standardUserDefaults().setObject(self.activeTime, forKey: CacheKey.ACTIVE_TIME)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(self.activeTime + totalTime!, forKey: CacheKey.ACTIVE_TIME)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        var lastLoginAt: Int? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LAST_LOGIN_AT) as? Int
        
        if (lastLoginAt != nil && time(nil) - lastLoginAt! > 5 * 86400){ // make sure login in 5 days.
            NSNotificationCenter.defaultCenter().postNotificationName(EventKey.SHOULD_LOGIN, object: self, userInfo: nil)
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.activeTime = time(nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        println("app exited")
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        if (url.host != nil && RegularExpression("safepay").test(url.host!)) {
            self.parse(url, application: application)
            return true
        }
        
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if (url.host != nil && RegularExpression("safepay").test(url.host!)) {
            self.parse(url, application: application)
            return true
        }
        
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func parse(url: NSURL, application: UIApplication) {
        var result:AlixPayResult? = self.handleOpenURL(url)
        if (result != nil) {
            println(result)
            if (result!.statusCode == 9000) {
                Util.handlePayResult(result!, url: url)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_PAY_FAILED, object: self, userInfo: nil)
            }
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_PAY_FAILED, object: self, userInfo: nil)
        }
    }
    
    func handleOpenURL(url: NSURL) -> AlixPayResult? {
        var result: AlixPayResult?
        if (RegularExpression("safepay").test(url.host!)) {
            result = self.resultFromURL(url)
        }
        
        return result
    }
    
    func resultFromURL(url: NSURL) -> AlixPayResult {
        var qurey: NSString = url.query!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return AlixPayResult(string: qurey)
    }
}

