
import Foundation
import UIKit

class LoginController: UIViewController, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 170
    
    var username:UITextField!
    var password:UITextField!
    
    var noticeLabel:UILabel!
    
    var accountCtrl :AccountController!
    
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
        
        
        noticeLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.23, y: 85, width: 160, height: 20))
        noticeLabel.textColor = Color.red
        self.subView.addSubview(noticeLabel)
        
        var submitButton = UIButton(frame: CGRect(x: self.view.frame.width * 0.23, y: 110, width: 70, height: 23))
        submitButton.backgroundColor = Color.red
        submitButton.setTitle("登录", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: "onLoginTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(submitButton)
        
        var cancelButton = UIButton(frame: CGRect(x: submitButton.frame.origin.x + submitButton.frame.width + 40, y: 110, width: 70, height: 23))
        cancelButton.backgroundColor = Color.gray
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)

    }
    
    func setAccountViewController(accountCtrl:AccountController) {
        self.accountCtrl = accountCtrl
    }
    
    func onLoginTapped(sender: UIButton) {
        
        if(username.text==nil || username.text.isEmpty) {
           noticeLabel.text="请填写用户名！"
        }
        else if(password.text==nil || password.text.isEmpty) {
            noticeLabel.text="请填写密码！"
        }
        else {
            LoadingDialog.showLoading()
            var params: NSMutableDictionary = NSMutableDictionary()
            params.setValue(username.text, forKey: "username")
            params.setValue(password.text, forKey: "password")
            params.setValue(Util.getUDID(), forKey: "udid")
            API.instance.get("/user/login", delegate: self,  params: params)
        }
    }
    
    func userLogin(data:AnyObject) {
        var dic :NSDictionary = data as NSDictionary

        CacheDataUitls.saveUserInfo(dic.valueForKey("id")!, userName: dic.valueForKey("username")!, passWord: password.text, holyWater: dic.valueForKey("holyWater")!, isTrial: false)
        
        self.accountCtrl.refreshUserInfo()
        
        LoadingDialog.dismissLoading()
        self.closeView()
    }
    
    func error(error: Error, api: String) {
        LoadingDialog.dismissLoading()
        noticeLabel.text=error.getMessage()
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
            self.subView.transform = CGAffineTransformMakeTranslation(0, -self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
}