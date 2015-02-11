//
//  LocalDataUtils.swift
//  words
//
//  Created by ios on 15-2-4.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import SQLite

class LocalDatUtils :APIDataDelegate {
    
    init() {
        

    }
    
    
    
    func saveLocalData(key: String, value:AnyObject) {
        var data:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        data.setObject(value, forKey: key)
    }
    
    func getLocalData(key: String) -> AnyObject {
        var data:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return data.objectForKey(key)!
    }
    
    ///////////////////////////
    
    func test() {
        
        saveLocalData("test", value: ["t1","t2"])
        var sArr: [String] = getLocalData("test") as [String]
        
        LogUtils.log(sArr[0])
        
        
        var dir :NSString = NSHomeDirectory()
        
        LogUtils.log("dir=\(dir)")
        
        var fileManager : NSFileManager = NSFileManager.defaultManager()
        
        getDicDbFile()
    }
    
    func getDicDbFile() {

        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue("54ca0c3983875bc918c6f5a1", forKey: "id")

        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("54ca0c3983875bc918c6f5a1.db")
        var data: NSData? = NSData(contentsOfFile: path)
    
        API.instance.get("/dictionary/download", delegate: self,  params: params)

    }
    
    func dictionaryDownloadDictionary(filePath: AnyObject, progress: Float) {
        LogUtils.log("filePath=\(filePath)")
        testSqlite(filePath as String)
    }
    
    func testSqlite(dbPath:String) {
        let db = Database(dbPath)

        db.execute(
            "CREATE TABLE users (" +
                "id INTEGER PRIMARY KEY, " +
                "email TEXT NOT NULL UNIQUE, " +
                "age INTEGER, " +
                "admin BOOLEAN NOT NULL DEFAULT 0 CHECK (admin IN (0, 1)), " +
                "manager_id INTEGER, " +
                "FOREIGN KEY(manager_id) REFERENCES users(id)" +
            ")"
        )
        
        let stmt = db.prepare("INSERT INTO users (email, admin) VALUES (?, ?)")
        for (email, admin) in ["alice@acme.com": true, "betsy@acme.com": false] {
            stmt.run(email, admin)
        }
        
        db.totalChanges
        db.lastChanges
        db.lastID
        
        for row in db.prepare("SELECT id, email FROM users") {
            println("id: \(row[0]), email: \(row[1])")
        }

    }

    
    
}