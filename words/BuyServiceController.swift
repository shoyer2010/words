
import Foundation
import UIKit

class BuyServiceController: UIViewController, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 180
    var indicator: UIActivityIndicatorView!
    var item01: UIButton!
    var item02: UIButton!
    var item03: UIButton!
    var buyButton: UIButton!
    var data: NSArray = NSArray()
    var selectedIndex: Int! = -1
    var orderId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPayFailed:", name: EventKey.ON_PAY_FAILED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPaySuccess:", name: EventKey.ON_PAY_SUCCESS, object: nil)
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        
        self.subView = UIView(frame: CGRect(x: 0, y: -self.subViewHeight, width: self.view.frame.width, height: self.subViewHeight))
        self.subView.backgroundColor = Color.white.colorWithAlphaComponent(0.89)
        self.subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.subView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.subView)
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.subView.frame.width / 2 - 15, y: self.subView.frame.height / 2 - 45, width: 30, height: 30))
        indicator.color = Color.gray
        self.subView.addSubview(indicator)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
                self.loadData()
        }
        
        item01 = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 120, y: 30, width: 60, height: 60))
        item01.backgroundColor = Color.red
        item01.titleLabel?.font = UIFont.systemFontOfSize(11)
        item01.tag = 1001
        item01.addTarget(self, action: "onItemTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(item01)
        
        item02 = UIButton(frame: CGRect(x: item01.frame.origin.x + item01.frame.width + 30, y: 30, width: 60, height: 60))
        item02.backgroundColor = Color.red
        item02.titleLabel?.font = UIFont.systemFontOfSize(11)
        item02.tag = 1002
        item02.addTarget(self, action: "onItemTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(item02)
        
        item03 = UIButton(frame: CGRect(x: item02.frame.origin.x + item02.frame.width + 30, y: 30, width: 60, height: 60))
        item03.backgroundColor = Color.red
        item03.titleLabel?.font = UIFont.systemFontOfSize(11)
        item03.tag = 1003
        item03.addTarget(self, action: "onItemTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(item03)

        
        
        buyButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 120, width: 90, height: 30))
        buyButton.backgroundColor = Color.gray
        buyButton.setTitle("购 买", forState: UIControlState.Normal)
        buyButton.addTarget(self, action: "onBuyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        buyButton.userInteractionEnabled = false
        buyButton.alpha = 0.5
        self.subView.addSubview(buyButton)
        
        var cancelButton = UIButton(frame: CGRect(x: buyButton.frame.origin.x + buyButton.frame.width + 20, y: 120, width: 90, height: 30))
        cancelButton.backgroundColor = Color.red
        cancelButton.setTitle("取 消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onBuyButtonTapped(sender: UIButton) {
        if (self.selectedIndex < 0) {
            ErrorView(view: self.view, message: "请选择你想购买多久")
            return
        }
        
        self.getOrder()
    }
    
    func getOrder() {
        var service: AnyObject = self.data[self.selectedIndex]
        var params = NSMutableDictionary()
        params.setValue(service["id"] as Int, forKey: "serviceId")
        API.instance.post("/user/order", delegate: self, params: params)
    }
    
    func userOrder(data: AnyObject) {
        self.orderId = data["id"] as? String
        var orderInfo = data["stringToSign"] as String
        var sign = data["sign"] as String
        
        AlipaySDK.defaultService().payOrder("\(orderInfo)&sign=\"\(sign)\"&sign_type=\"RSA\"", fromScheme: Constant.ALIPAY_APP_SCHEME) { (result: [NSObject: AnyObject]!) -> Void in
            if (result != nil) {
                var status = result["resultStatus"] as NSObject
                if ("\(status)" == "9000") {
                    NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_PAY_SUCCESS, object: self, userInfo: nil)
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_PAY_FAILED, object: self, userInfo: nil)
                }
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_PAY_FAILED, object: self, userInfo: nil)
            }
        }
    }
    
    func onCancelTapped(sender: UIButton) {
        self.closeView()
    }
    
    func closeView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, -self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    func startLoading() {
        self.subView.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func endLoading() {
        self.indicator.stopAnimating()
    }
    
    func loadData() {
        var parmas = NSMutableDictionary()
        API.instance.get("/user/serviceList", delegate: self, params: parmas)
        self.startLoading()
    }
    
    func userServiceList(data: AnyObject) {
        self.endLoading()
        self.data = data as NSArray
        
        var item01Price = NSString(format: "%.0f", self.data[0]["price"] as Float)
        var item01Name = self.data[0]["name"] as String
        item01.setTitle("\(item01Price)元\(item01Name)", forState: UIControlState.Normal)
        
        var item02Price = NSString(format: "%.0f", self.data[1]["price"] as Float)
        var item02Name = self.data[1]["name"] as String
        item02.setTitle("\(item02Price)元\(item02Name)", forState: UIControlState.Normal)
        
        var item03Price = NSString(format: "%.0f", self.data[2]["price"] as Float)
        var item03Name = self.data[2]["name"] as String
        item03.setTitle("\(item03Price)元\(item03Name)", forState: UIControlState.Normal)
        
        buyButton.userInteractionEnabled = true
        buyButton.alpha = 1.0
    }
    
    func resetAllItem() {
        item01.backgroundColor = Color.red
        item02.backgroundColor = Color.red
        item03.backgroundColor = Color.red
    }
    
    func onItemTapped(sender: UIButton) {
        self.resetAllItem()
        sender.backgroundColor = Color.gray
        self.selectedIndex = sender.tag - 1001
    }
    
    func onPayFailed(notification: NSNotification) {
        ErrorView(view: self.view, message: "抱歉，支付失败")
        
        MobClick.event("onPayFailed")
    }
    
    func onPaySuccess(notification: NSNotification) {
        var service: AnyObject = self.data[self.selectedIndex]
        var name = service["name"] as String
        var price = service["price"] as Int
        MobClick.event("payOrder", attributes: ["name" : name], counter: Int32(price))
        
        NSNotificationCenter.defaultCenter().postNotificationName(EventKey.SHOULD_LOGIN, object: self, userInfo: nil)
        SuccessView(view: self.view, message: "恭喜，支付成功") { () -> Void in
        }
        MobClick.event("onPaySuccess")
    }
}