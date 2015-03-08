
import Foundation
import UIKit

class ServiceInfoController: UIViewController, APIDataDelegate, UIWebViewDelegate {
    var subView: UIView!
    var webView: UIWebView!
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        var subViewHeight: CGFloat = self.view.frame.height - 120
        
        self.subView = UIView(frame: CGRect(x: 0, y: -subViewHeight, width: self.view.frame.width, height: subViewHeight))
        self.subView.backgroundColor = Color.white.colorWithAlphaComponent(0.89)
        self.subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.subView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.subView)
        
        self.webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.subView.frame.width, height: self.subView.frame.height))
        self.webView.backgroundColor = UIColor.clearColor()
        self.subView.addSubview(self.webView)
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.webView.frame.width / 2 - 15, y: self.webView.frame.height / 2 - 15, width: 30, height: 30))
        indicator.color = Color.red
        self.webView.addSubview(indicator)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
                var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
                var userId = user?["id"] as? NSString
                
                var request = NSURLRequest(URL: NSURL(string: Server.entry() + "/user/serviceInfo?userId=\(userId!)")!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: NSTimeInterval(10))
                self.webView.delegate = self
                self.webView.loadRequest(request)
        }
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onButtonTapped(sender: UIButton) {
        self.closeView()
    }
    
    func onCancelTapped(sender: UIButton) {
        self.closeView()
    }
    
    func closeView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, -(self.view.frame.height - 120))
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
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