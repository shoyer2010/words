//
//  BaseDataController.swift
//  words
//
//  Created by ios on 15-1-31.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation


class BaseDataService {
    
    func getNetData(params:DMNetParam, delegate:APIDataDelegate, file: NSData? = nil) {
        API.instance.post(params.httpPath, delegate:delegate, params:params, file: file)
    }
    
//    //获取缓存的数据
//    func getCacheData(key:String) ->AnyObject {
//        return ""
//    }
    
//    func getSqliteDB(filePath:String) ->Database {
//        return Data
//    }
    
    
    
}