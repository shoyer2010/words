//
//  HelpController.swift
//  words
//
//  Created by shoyer on 15/2/3.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class HelpController: UIViewController, APIDataDelegate {
    var helpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        
        self.helpView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        self.helpView.backgroundColor = Color.red
        self.helpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.helpView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.helpView)
        
        
        var button = UIButton(frame: CGRect(x:100, y: 100, width: 100, height: 100))
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(self, action: "onButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var label = UILabel(frame: CGRect(x:0, y: 0, width: 100, height: 100))
        label.text = "返回"
        button.addSubview(label)
        
        var helpLabel = UILabel(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        helpLabel.text = "帮助页面"
        self.helpView.addSubview(helpLabel)
        self.helpView.addSubview(button)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.helpView.transform = CGAffineTransformMakeTranslation(0, 55 - self.view.frame.height)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
        }
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onButtonTapped(sender: UIButton) {
        self.closeView()
    }
    
    func closeView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.helpView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height - 55)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
}