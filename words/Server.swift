//
//  Server.swift
//  words
//
//  Created by shoyer on 15/2/21.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation

struct Server {
//    static let host = "dev.coolhey.cn"
//    static let host = "server.wordholy.com"
      static let host = "121.43.228.158" // TODO: 这一版先用ip访问，等下一版域名备案下来，用域名访问
//    static let host = "localhost"
    static let port = "1337"
    
    static func entry() -> String {
        return "http://" + Server.host + ":" + Server.port
    }
}