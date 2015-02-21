//
//  WordDetailDelegate.swift
//  words
//
//  Created by shoyer on 15/2/18.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

@objc protocol WordDetailDelegate {
    func frameOfView() -> CGRect
    
    func searchWord() -> String
    
    optional func shoudRegisterNotification() -> Bool
}