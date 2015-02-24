//
//  TapPointView.swift
//  words
//
//  Created by shoyer on 15/2/24.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class TapPointView: UIView {
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(view: UIView, tapPoint: CGPoint, completion: (() -> Void)? = nil) {
        super.init(frame: CGRect(x: tapPoint.x - 1, y: tapPoint.y - 1, width: 2, height: 2))
        self.backgroundColor = Color.red.colorWithAlphaComponent(0)
        self.layer.cornerRadius = 1
        self.layer.shadowRadius = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = Color.red.CGColor
        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(10, 10)
            self.backgroundColor = Color.red.colorWithAlphaComponent(1)
            }) { (isDone: Bool) -> Void in
                self.removeFromSuperview()
                completion?()
        }
    }
}