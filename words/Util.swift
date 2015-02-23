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
    
    class func getUDID() -> String{
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    class func getVoiceURL(path: String) -> NSURL {
        if (RegularExpression("^http:").test(path)) {
            return NSURL(string: path)!
        } else {
            return NSURL(string: Server.entry() + "/" + path)!
        }
    }
    
    class func getStringFromSeconds(seconds: Int = 0) -> String {
        var days = seconds / 86400
        var hours = (seconds % 86400) / 3600
        var minutes = (seconds % 3600) / 60
        return "\(days)天\(hours)小时\(minutes)分"
    }
    
    class func getFilePath(filename: String) -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(filename)
    }
    
    class func isFileExist(filename: String) -> Bool {
        var filePath = Util.getFilePath(filename)
        return NSFileManager.defaultManager().fileExistsAtPath(filePath)
    }
    
    class func fileSizeString(filename: String) -> String {
        var filePath = Util.getFilePath(filename)
        var filesize = NSFileManager.defaultManager().attributesOfItemAtPath(filePath, error: nil)?["NSFileSize"] as Int
        if (filesize >= 1024 * 1024) {
            return "\(filesize / (1024 * 1024)) MB"
        }
        
        if (filesize >= 1024) {
            return "\(filesize / 1024) KB"
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
}

