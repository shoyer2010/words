//
//  LogUtils.swift
//  words
//
//  Created by ios on 15-2-4.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation

struct LogUtils {
    
    static var IS_OPEN_LOG: BooleanType = true
    
    static func log(data: AnyObject) {
        if IS_OPEN_LOG {
            print(data)
            print("\n")
        }
    }
    
    
}