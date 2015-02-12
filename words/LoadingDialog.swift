//
//  LoadingDialog.swift
//  words
//
//  Created by ios on 15-2-11.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

struct LoadingDialog {
    
    static var dlg : UIAlertView!
    
    static func showLoading() {
        dlg = UIAlertView()
        dlg.message="loading..."
        
        dlg.show()
    }
    
    static func dismissLoading() {
        if dlg != nil {
            dlg.dismissWithClickedButtonIndex(1, animated: false)
            dlg == nil
        }
    }
    
}