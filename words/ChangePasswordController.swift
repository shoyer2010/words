
import Foundation
import UIKit

class ChangePasswordController: UIViewController, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 150
    
    var oldPasswordInput :UITextField!
    var newPasswordInput :UITextField!
    
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
        
        var oldPassword = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 20, width: 60, height: 30))
        oldPassword.text = "原密码"
        self.subView.addSubview(oldPassword)
        
        oldPasswordInput = UITextField(frame: CGRect(x: oldPassword.frame.origin.x + oldPassword.frame.width, y: 20, width: 140, height: 26))
        oldPasswordInput.backgroundColor = Color.white
        oldPasswordInput.secureTextEntry = true
        self.subView.addSubview(oldPasswordInput)
        
        var newPassword = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 53, width: 60, height: 30))
        newPassword.text = "新密码"
        self.subView.addSubview(newPassword)
        
        newPasswordInput = UITextField(frame: CGRect(x: newPassword.frame.origin.x + newPassword.frame.width, y: 55, width: 140, height: 26))
        newPasswordInput.backgroundColor = Color.white
        newPasswordInput.secureTextEntry = true
        self.subView.addSubview(newPasswordInput)
        
        var submitButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 100, width: 90, height: 30))
        submitButton.backgroundColor = Color.gray
        submitButton.setTitle("修 改", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: "onSubmmitButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(submitButton)
        
        var cancelButton = UIButton(frame: CGRect(x: submitButton.frame.origin.x + submitButton.frame.width + 20, y: 100, width: 90, height: 30))
        cancelButton.backgroundColor = Color.red
        cancelButton.setTitle("取 消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onSubmmitButtonTapped(sender: UIButton) {
        var oldPassword = self.oldPasswordInput.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as NSString
        if (oldPassword.length < 6) {
            ErrorView(view: self.view, message: "密码至少6个字符")
            return
        }
        
        if (oldPassword.length > 32) {
            ErrorView(view: self.view, message: "密码不能多于32个字符")
            return
        }
        
        var newPassword = self.newPasswordInput.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as NSString
        if (newPassword.length < 6) {
            ErrorView(view: self.view, message: "密码至少6个字符")
            return
        }
        
        if (newPassword.length > 32) {
            ErrorView(view: self.view, message: "密码不能多于32个字符")
            return
        }
        
        if (oldPassword == newPassword) {
            ErrorView(view: self.view, message: "新密码和原密码不能相同")
            return
        }
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(oldPassword, forKey: "password")
        params.setValue(newPassword, forKey: "newPassword")
        API.instance.post("/user/changePassword", delegate: self,  params: params)
    }
    
    func changePassword(data :AnyObject) {
        var oldUser: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        var user = NSMutableDictionary()
        user.setDictionary(oldUser as NSDictionary)
        user.setValue(self.newPasswordInput.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), forKey: "password")
        NSUserDefaults.standardUserDefaults().setObject(user as AnyObject, forKey: CacheKey.USER)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        SuccessView(view: self.view, message: "恭喜，密码修改成功", completion: {() -> Void in
            self.closeView()
        })
    }
    
    func error(error: Error, api: String) {
        ErrorView(view: self.view, message: error.getMessage())
    }
    
    func onCancelButtonTapped(sender: UIButton) {
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