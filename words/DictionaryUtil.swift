//
//  Dictionary.swift
//  words
//
//  Created by shoyer on 15/2/24.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation

class DictionaryUtil {
    class func customDictionaryId() -> String {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        return user!.objectForKey("customDictionaryId") as String
    }
}