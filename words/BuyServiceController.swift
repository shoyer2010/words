
import Foundation
import UIKit

class BuyServiceController: UIViewController, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        
        self.subView = UIView(frame: CGRect(x: 0, y: -self.subViewHeight, width: self.view.frame.width, height: self.subViewHeight))
        self.subView.backgroundColor = Color.white.colorWithAlphaComponent(0.89)
        self.subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.subView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.subView)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
        }
        var item01 = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 110, y: 20, width: 60, height: 60))
        item01.backgroundColor = Color.red
        item01.setTitle("10元500滴", forState: UIControlState.Normal)
        item01.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.subView.addSubview(item01)
        
        var item02 = UIButton(frame: CGRect(x: item01.frame.origin.x + item01.frame.width + 20, y: 20, width: 60, height: 60))
        item02.backgroundColor = Color.red
        item02.setTitle("20元1500滴", forState: UIControlState.Normal)
        item02.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.subView.addSubview(item02)
        
        var item03 = UIButton(frame: CGRect(x: item02.frame.origin.x + item02.frame.width + 20, y: 20, width: 60, height: 60))
        item03.backgroundColor = Color.red
        item03.setTitle("30元3000滴", forState: UIControlState.Normal)
        item03.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.subView.addSubview(item03)

        
        
        var buyButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 70, y: 100, width: 60, height: 23))
        buyButton.backgroundColor = Color.gray
        buyButton.setTitle("购买", forState: UIControlState.Normal)
        buyButton.addTarget(self, action: "onBuyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(buyButton)
        
        var cancelButton = UIButton(frame: CGRect(x: buyButton.frame.origin.x + buyButton.frame.width + 20, y: 100, width: 60, height: 23))
        cancelButton.backgroundColor = Color.red
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onBuyButtonTapped(sender: UIButton) {
//        AlixLibService.payOrder("tsets", andScheme: "fsfadf", seletor: Selector("dfasf"), target: self)
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
}