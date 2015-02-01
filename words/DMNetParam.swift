//
//  DMNetParam.swift
//  words
//
//  Created by ios on 15-1-31.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation

class  DMNetParam: BaseDataModule {
    
    var httpPath: String!
    
    var httpParams: NSMutableDictionary = NSMutableDictionary()
    
    init(httpPath: String) {
        
        self.httpPath = httpPath
    }
    
    func setHttpUrlPath(path:String) {
        httpPath = path
    }
    
    func addParamValuePair(key:String, value:AnyObject) {
        httpParams.setValue(value, forKey: key)
    }
    
}