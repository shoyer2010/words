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
    
    class func importDataToLearingProcess(dictionaryId: String, progressCallback: ((progress: Float) -> Bool)? = nil) {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        var userId = user!["id"] as String
        
        var dbTo = Database(Util.getFilePath(userId + ".db"))
        var dbSource = Database(Util.getFilePath(dictionaryId + ".db"))
        
        var total = 0
        for row in dbSource.prepare("SELECT count(rowid) FROM words") {
            total = row[0] as Int
        }
        
        if (total == 0) {
            progressCallback?(progress: 1.0)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var i = 1
            for row in dbSource.prepare("SELECT id FROM words") {
                dbTo.prepare("INSERT INTO learningProgress(dictionaryId, wordId, wordStatus, lastAppearTime, appearTimes, rightTimes, rightSeconds) VALUES(?, ?, ?, ?, ?, ?, ?)", dictionaryId, row[0] as String, 0, 0, 0, 0, "0").run()
                
                var progress = Float(i) / Float(total)
                
                if (progressCallback != nil) {
                    if(progressCallback!(progress: progress)) {
                        break
                    }
                }
                
                i++
            }
        })
    }
    
    class func deleteWordFromDictionary(dictionaryId: String, wordId: String, delegate: APIDataDelegate) {
        var dictionary: AnyObject? = DictionaryUtil.getDictionaryInfo(dictionaryId)
        
        var db = Database(Util.getFilePath(dictionaryId + ".db"))
        db.prepare("DELETE FROM words WHERE id=?", wordId).run()
        
        if (dictionary!["custom"] as Bool) {
            db.prepare("CREATE TABLE IF NOT EXISTS operationLogs(wordId, wordStatus)").run()
            db.prepare("INSERT INTO operationLogs(wordId, wordStatus) VALUES(?, ?)", wordId, Constant.DELETE).run()
            
            var params = NSMutableDictionary()
            params.setValue(wordId, forKey: "id")
            params.setValue(2, forKey: "type")
            API.instance.post("/dictionary/customWord", delegate: delegate, params: params)
        }
        
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        var userId = user!["id"] as String
        
        var dbUser = Database(Util.getFilePath(userId + ".db"))
        dbUser.prepare("DELETE FROM learningProgress WHERE dictionaryId=? and wordId=?", dictionaryId, wordId).run()
        
        NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_DICTIONARY_CHANGED, object: self, userInfo: nil)
    }
    
    class func getWordCountHaveMastered(fromTime: Int) -> Int {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        var count = 0
        if (user != nil) {
            var userId = user!["id"] as String
            if (Util.isFileExist(userId + ".db")) {
                var db = Database(Util.getFilePath(userId + ".db"))
                for row in db.prepare("SELECT count(rowid) FROM learningProgress WHERE lastAppearTime>=? AND wordStatus=6", fromTime) {
                    count = row[0] as Int
                }
            }
        }
        
        return count
    }
    
    class func getWordCountHaveReviewed(fromTime: Int) -> Int {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        
        var count = 0
        if (user != nil) {
            var userId = user!["id"] as String
            if (Util.isFileExist(userId + ".db")) {
                var db = Database(Util.getFilePath(userId + ".db"))
                for row in db.prepare("SELECT count(rowid) FROM learningProgress WHERE lastAppearTime>=? AND wordStatus IN(2,3,4,5)", fromTime) {
                    count = row[0] as Int
                }
            }
        }
        
        return count
    }
    
    class func getWordCountHaveLearned(fromTime: Int) -> Int {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        var count = 0
        if (user != nil) {
            var userId = user!["id"] as String
            if (Util.isFileExist(userId + ".db")) {
                var db = Database(Util.getFilePath(userId + ".db"))
                for row in db.prepare("SELECT count(rowid) FROM learningProgress WHERE lastAppearTime>=? AND wordStatus!=6", fromTime) {
                    count = row[0] as Int
                }
            }
        }
        
        return count
    }
}