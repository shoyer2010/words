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
        let imgView : UITextView = UITextView()
        imgView.frame = CGRect(x: dlg.center.x, y: dlg.center.y, width: 224, height: 224)

        imgView.text = "......"
        imgView.textColor = Color.red
        dlg.addSubview(imgView)
        dlg.bringSubviewToFront(imgView)
        
        dlg.show()
    }
    
    static func dismissLoading() {
        if dlg != nil {
            dlg.dismissWithClickedButtonIndex(1, animated: false)
            dlg == nil
        }
    }
}