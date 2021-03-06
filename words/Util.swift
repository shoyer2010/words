//
//  Util.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    class func isWiFi() -> Bool {
        var reachablity = Reachability.reachabilityForLocalWiFi()
        var status = reachablity.currentReachabilityStatus()
        
        return status.value == ReachableViaWiFi.value
    }
    
    class func createImageWithColor(color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
    
        let rect: CGRect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(rect.size);
        let context: CGContextRef = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
    class func getUDID() -> String {
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    class func isSimulator() -> Bool {
        return RegularExpression("Simulator").test(UIDevice.currentDevice().model)
    }
    
    class func getVersion() -> String {
        var info = NSBundle.mainBundle().infoDictionary! as NSDictionary
        return info.objectForKey("CFBundleShortVersionString") as String
    }
    
    class func getVoiceURL(path: String) -> NSURL {
        var url = path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if (RegularExpression("^http:").test(path)) {
            return NSURL(string: url)!
        } else {
            return NSURL(string: Server.entry() + "/" + url)!
        }
    }
    
    class func getStringFromSeconds(seconds: Int = 0) -> String {
        var hours = Int(seconds / 3600)
        var minutes = (seconds % 3600) / 60
        return "\(hours)小时\(minutes)分"
    }
    
    class func getFilePath(filename: String) -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(filename)
    }
    
    class func isFileExist(filename: String) -> Bool {
        var filePath = Util.getFilePath(filename)
        return NSFileManager.defaultManager().fileExistsAtPath(filePath)
    }
    
    class func getCachePath() -> String {
        var cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        var path = cachePath + "/words_app_cache_path"
        var exists = NSFileManager.defaultManager().fileExistsAtPath(path)
        if (!exists) {
            NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        
        return path
    }
    
    class func getCacheFilePath(filename: String) -> String {
        return Util.getCachePath() + "/" + filename
    }
    
    class func fileSizeString(filename: String) -> String {
        var filePath = Util.getFilePath(filename)
        var filesize = NSFileManager.defaultManager().attributesOfItemAtPath(filePath, error: nil)?["NSFileSize"] as Int
        if (filesize >= 1024 * 1024) {
            return NSString(format: "%.1f MB", Float(filesize) / (1024.0 * 1024.0))
        }
        
        if (filesize >= 1024) {
            return NSString(format: "%.1f KB", Float(filesize) / 1024.0)
        }
        
        return "\(filesize) B"
    }
    
    class func deleteFile(filename: String) {
        var filePath = Util.getFilePath(filename)
        NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
    }
    
    class func learningString() -> String {
        var customDictionary = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_CUSTOM_DICTIONARY) as? String
        var learningDictionary = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_DICTIONARY) as? String
        
        var string = ""
        if(learningDictionary != nil) {
            var dictionary: AnyObject? = Util.getDictionaryInfo(learningDictionary! as String)
            if (dictionary != nil) {
                string += dictionary!["name"] as String
            }
        }
        
        if (customDictionary != nil) {
            if (learningDictionary == nil) {
                string += "生词本"
            } else {
                string += " + 生词本"
            }
        }
        
        if (learningDictionary == nil && customDictionary == nil) {
            string = "请选择你想学习的词库"
        }
        
        return string
    }
    
    class func getDictionaryInfo(dictionaryId: String) -> AnyObject? {
        var dictionaryList = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.DICTIONARY_LIST) as? NSArray
        var dictionary: AnyObject?
        if (dictionaryList != nil) {
            for item in dictionaryList! {
                if ((item["id"] as String) == dictionaryId) {
                    dictionary = item
                    break
                }
            }
        }
        
        return dictionary
    }
    
    class func recognizeWord(view: UILabel, recognizer: UITapGestureRecognizer) -> String? {
        var matchWord: String?
        
        var tapPoint:CGPoint = recognizer.locationInView(view)
        
        var textStorage = NSTextStorage(attributedString: view.attributedText)
        var layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        var textContainer = NSTextContainer(size: CGSize(width: view.frame.width, height: view.frame.height + 2000))
        textContainer.lineFragmentPadding  = 0;
        layoutManager.addTextContainer(textContainer)
        
        var characterIndex = layoutManager.characterIndexForPoint(tapPoint, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if (characterIndex < textStorage.length) {
            
            var startIndex = characterIndex
            for ( ; startIndex > 0; startIndex--) {
                var char = view.attributedText.attributedSubstringFromRange(NSRange(location: startIndex, length: 1))
                if (!RegularExpression("[A-Za-z]").test(char.string)) {
                    if (startIndex < textStorage.length - 1) {
                        startIndex++
                    }
                    
                    break;
                }
            }
            
            var endIndex = characterIndex >= view.attributedText.length - 1 ? characterIndex : characterIndex + 1
            for ( ; endIndex < textStorage.length - 1; endIndex++) {
                var char = view.attributedText.attributedSubstringFromRange(NSRange(location: endIndex, length: 1))
                if (!RegularExpression("[A-Za-z]").test(char.string)) {
                    break;
                }
            }
            
            var word = view.attributedText.attributedSubstringFromRange(NSRange(location: startIndex, length: endIndex - startIndex + 1))
            matchWord = word.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if (!RegularExpression("[A-Za-z]").test(matchWord!)) {
                matchWord = nil
            }
        }
        
        return matchWord
    }
    
    class func getRandomInt(from: Int = 0, to: Int = 10000) -> Int {
        return from + (Int(arc4random() % (to - from + 1)))
    }
    
    class func clearCache() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.USER)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.LEARNING_CUSTOM_DICTIONARY)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.LEARNING_DICTIONARY)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.DICTIONARY_LIST)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.ACTIVE_TIME)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.SYNC_TIME)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.WRONG_WORD_POST_TIME)
    }
    
    class func isServiceAvailable() -> Bool {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        
        if (user == nil) {
            return true
        }
        
        var serviceTo = user!["serviceTo"] as Int
        var serverTime = user!["serverTime"] as Int
        if (serviceTo <= serverTime) {
            return false
        } else {
            return true
        }
    }
    
    class func appURL() -> NSString? {
        return NSUserDefaults.standardUserDefaults().valueForKey(CacheKey.APP_URL) as? NSString
    }
}

