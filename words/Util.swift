//
//  Util.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    class func createImageWithColor(color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
    
        let rect: CGRect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(rect.size);
        let context: CGContextRef = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
    class func getUDID() -> String{
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    class func getVoiceURL(path: String) -> NSURL {
        if (RegularExpression("^http:").test(path)) {
            return NSURL(string: path)!
        } else {
            return NSURL(string: Server.entry() + "/" + path)!
        }
    }
}

