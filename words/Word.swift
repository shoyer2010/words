//
//  Word.swift
//  words
//
//  Created by shoyer on 15/2/24.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation

class Word {
    class func addToCustomDictionary(word: AnyObject) {
        var db = Database(Util.getFilePath(DictionaryUtil.customDictionaryId() + ".db"))
        var statement = db.prepare("INSERT INTO words(id, word, phoneticSymbolUS, usPronunciation, phoneticSymbolUK, ukPronunciation, chinese) VALUES (?, ?, ?, ?, ?, ?, ?)")
        
        var id = word["id"] as? String
        var wordString = word["word"] as? String
        var phoneticSymbolUS = word["phoneticSymbolUS"] as? String
        var usPronunciation = word["usPronunciation"] as? String
        var phoneticSymbolUK = word["phoneticSymbolUK"] as? String
        var ukPronunciation = word["ukPronunciation"] as? String
        
        var chinese: String?
        if (word["chinese"] != nil) {
            var data = NSJSONSerialization.dataWithJSONObject(word["chinese"]!!, options: NSJSONWritingOptions.allZeros, error: nil)
            if (data != nil) {
                chinese = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            }
        }
        
        statement.run(id, wordString, phoneticSymbolUS, usPronunciation, phoneticSymbolUK, ukPronunciation, chinese)
        
        DictionaryUtil.importDataToLearingProcess(DictionaryUtil.customDictionaryId())
    }
}