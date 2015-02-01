//
//  LogUtil.swift
//  words
//
//  Created by ios on 15-1-31.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation

struct LogUtil {
    
    
    static func log(data : AnyObject) {
        if Config.IS_OPEN_LOG {
            println(data)
        }
    }
}