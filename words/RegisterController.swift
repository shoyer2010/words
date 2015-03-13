
import Foundation
import UIKit

class RegisterController: UIViewController, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 165
    
    var username :UITextField!
    var password :UITextField!
    var passwordForRegister: String!
    
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
        
        var usernameLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 20, width: 60, height: 30))
        usernameLabel.text = "用户名"
        self.subView.addSubview(usernameLabel)
        
        username = UITextField(frame: CGRect(x: usernameLabel.frame.origin.x + usernameLabel.frame.width, y: 20, width: 140, height: 26))
        username.placeholder = "5-32个字符"
        username.backgroundColor = Color.white
        self.subView.addSubview(username)
        
        var passwordLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 53, width: 60, height: 30))
        passwordLabel.text = "密   码"
        self.subView.addSubview(passwordLabel)
        
        password = UITextField(frame: CGRect(x: passwordLabel.frame.origin.x + passwordLabel.frame.width, y: 55, width: 140, height: 26))
        password.placeholder = "6-32个字符"
        password.backgroundColor = Color.white
        password.secureTextEntry = true
        self.subView.addSubview(password)
        
        var submitButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 100, y: 100, width: 90, height: 30))
        submitButton.backgroundColor = Color.gray
        submitButton.setTitle("升 级", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: "onSubmitButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(submitButton)
        
        var cancelButton = UIButton(frame: CGRect(x: submitButton.frame.origin.x + submitButton.frame.width + 20, y: 100, width: 90, height: 30))
        cancelButton.backgroundColor = Color.red
        cancelButton.setTitle("取 消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)
        
        var tipsLabelWrap = UIView(frame: CGRect(x: 0, y: self.subView.frame.height - 20, width: self.subView.frame.width, height: 20))
        tipsLabelWrap.backgroundColor = Color.red.colorWithAlphaComponent(0.9)
        self.subView.addSubview(tipsLabelWrap)
        
        var tipsLabel = UILabel(frame: CGRect(x: 0, y: 4, width: self.subView.frame.width, height: 20))
        tipsLabel.text = "升级后你可以用此账号在其他设备同步数据"
        tipsLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = NSTextAlignment.Center
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: tipsLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        tipsLabel.attributedText = NSAttributedString(string: tipsLabel.text!, attributes: attributes)
        tipsLabelWrap.addSubview(tipsLabel)
    }
    
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onSubmitButtonTapped(sender: UIButton) {
        var username = self.username.text as NSString
        if (username.length < 5) {
            ErrorView(view: self.view, message: "用户名至少5个字符")
            return
        }
        
        if (username.length > 32) {
            ErrorView(view: self.view, message: "用户名不能多于32个字符")
            return
        }
        
        var password = self.password.text as NSString
        if (password.length < 6) {
            ErrorView(view: self.view, message: "密码至少6个字符")
            return
        }
        
        if (password.length > 32) {
            ErrorView(view: self.view, message: "密码不能多于32个字符")
            return
        }
        
        self.passwordForRegister = password
        
        var params = NSMutableDictionary()
        params.setValue(username, forKey: "username")
        params.setValue(password, forKey: "password")
        API.instance.post("/user/register", delegate: self, params: params)
        
        MobClick.event("registerUser")
    }
    
    func userRegister(data:AnyObject) {
        var user = NSMutableDictionary()
        user.setDictionary(NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)! as NSMutableDictionary)
        user.setValue(data["username"], forKey: "username")
        user.setValue(self.passwordForRegister.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), forKey: "password")
        user.setValue(data["trial"], forKey: "trial")
        NSUserDefaults.standardUserDefaults().setObject(user as AnyObject, forKey: CacheKey.USER)
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_REGISTER_SUCCESS, object: self, userInfo: nil)
        
        self.closeView()
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