
import Foundation
import UIKit

class LoginController: UIViewController, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 150
    
    var username:UITextField!
    var password:UITextField!
    
    var loginPassword: String!
    
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
        
        var usernameLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.23, y: 20, width: 60, height: 20))
        usernameLabel.text = "用户名"
        self.subView.addSubview(usernameLabel)
        
        username = UITextField(frame: CGRect(x: usernameLabel.frame.origin.x + usernameLabel.frame.width, y: 20, width: 120, height: 20))
        username.backgroundColor = Color.white
        self.subView.addSubview(username)
        
        var passwordLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.23, y: 55, width: 60, height: 20))
        passwordLabel.text = "密   码"
        self.subView.addSubview(passwordLabel)
        
        password = UITextField(frame: CGRect(x: passwordLabel.frame.origin.x + passwordLabel.frame.width, y: 55, width: 120, height: 20))
        password.backgroundColor = Color.white
        password.secureTextEntry = true
        self.subView.addSubview(password)
        
        var submitButton = UIButton(frame: CGRect(x: self.view.frame.width * 0.23, y: 100, width: 70, height: 23))
        submitButton.backgroundColor = Color.red
        submitButton.setTitle("登录", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: "onSubmitButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(submitButton)
        
        var cancelButton = UIButton(frame: CGRect(x: submitButton.frame.origin.x + submitButton.frame.width + 40, y: 100, width: 70, height: 23))
        cancelButton.backgroundColor = Color.gray
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)

    }
    
    func error(error: Error, api: String) {
        ErrorView(view: self.view, message: error.getMessage())
    }

    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onSubmitButtonTapped(sender: UIButton) {
        var username = self.username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as NSString
        if (username.length < 5) {
            ErrorView(view: self.view, message: "用户名至少5个字符")
            return
        }
        
        if (username.length > 32) {
            ErrorView(view: self.view, message: "用户名不能多于32个字符")
            return
        }
        
        var password = self.password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as NSString
        if (password.length < 6) {
            ErrorView(view: self.view, message: "密码至少6个字符")
            return
        }
        
        if (password.length > 32) {
            ErrorView(view: self.view, message: "密码不能多于32个字符")
            return
        }
        
        self.loginPassword = password
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(username, forKey: "username")
        params.setValue(password, forKey: "password")
        API.instance.get("/user/login", delegate: self,  params: params)
    }
    
    func userLogin(data:AnyObject) {
        var user = NSMutableDictionary()
        user.setDictionary(data as NSDictionary)
        user.setValue(self.loginPassword, forKey: "password")
        NSUserDefaults.standardUserDefaults().setObject(user as AnyObject, forKey: CacheKey.USER)
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_LOGIN_SUCCESS, object: self, userInfo: nil)
        self.closeView()
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