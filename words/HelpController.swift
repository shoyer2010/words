//
//  HelpController.swift
//  words
//
//  Created by shoyer on 15/2/3.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class HelpController: UIViewController, APIDataDelegate, UIWebViewDelegate, UIScrollViewDelegate {
    var helpView: UIView!
    var webView: UIWebView!
    
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        
        self.helpView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height - 55))
        self.helpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.helpView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.helpView.backgroundColor = Color.white.colorWithAlphaComponent(0.89)
        self.view.addSubview(self.helpView)
        
        self.webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.helpView.frame.width, height: self.helpView.frame.height))
        self.webView.backgroundColor = UIColor.clearColor()
        self.helpView.addSubview(self.webView)
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.webView.frame.width / 2 - 15, y: self.webView.frame.height / 2 - 15, width: 30, height: 30))
        indicator.color = Color.red
        self.webView.addSubview(indicator)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.helpView.transform = CGAffineTransformMakeTranslation(0, 55 - self.view.frame.height)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
                var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
                var userId = user?["id"] as? NSString
                
                var request = NSURLRequest(URL: NSURL(string: Server.entry() + "/user/faq?userId=\(userId!)")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: NSTimeInterval(10))
                self.webView.delegate = self
                self.webView.scrollView.delegate = self
                self.webView.loadRequest(request)
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        if (offset < Interaction.offsetForChangePage) {
            scrollView.userInteractionEnabled = false
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.helpView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height - 55)
                self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
                }) { (isDone: Bool) -> Void in
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(700 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            })
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.webView.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.indicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.indicator.stopAnimating()
    }
}