//
//  SearchWordResultController.swift
//  words
//
//  Created by shoyer on 15/2/3.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class SearchWordResultController: UIViewController, APIDataDelegate, WordDetailDelegate {
    
    var contentView: UIView!
    var delegate: SearchWordResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        
        self.contentView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        self.contentView.backgroundColor = Color.red
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.contentView)
        
        var wordDetailController = WordDetailController()
        wordDetailController.delegate = self
        self.addChildViewController(wordDetailController)
        self.contentView.addSubview(wordDetailController.view)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.contentView.transform = CGAffineTransformMakeTranslation(0, 55 - self.view.frame.height)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
        }
    }
    
    func frameOfView() -> CGRect {
        return CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.view.frame.height - 55)
    }
    
    func searchWord() -> String {
        if (self.delegate != nil) {
            return self.delegate!.searchWord()
        }
        
        return ""
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        if (offset < Interaction.offsetForChangePage) {
            scrollView.userInteractionEnabled = false
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.contentView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height - 55)
                self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
                }) { (isDone: Bool) -> Void in
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(700 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            })
        }
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func closeView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.contentView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height - 55)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
}