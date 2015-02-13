
import Foundation
import UIKit

class RegisterController: UIViewController, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 200
    
    var username :UITextField!
    var password :UITextField!
    
    var noticeInfoLabel :UILabel!
    
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
        
        var inviteLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.23, y: 90, width: 60, height: 20))
        inviteLabel.text = "邀请者"
        self.subView.addSubview(inviteLabel)
        
        var invitor = UITextField(frame: CGRect(x: inviteLabel.frame.origin.x + inviteLabel.frame.width, y: 90, width: 120, height: 20))
        invitor.backgroundColor = Color.white
        invitor.placeholder = "(可选)邀请者的用户名"
        invitor.font = UIFont(name: invitor.font.fontName, size: CGFloat(12))
        self.subView.addSubview(invitor)
        
        var submitButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 70, y: 125, width: 60, height: 23))
        submitButton.backgroundColor = Color.gray
        submitButton.setTitle("升级", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: "onButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(submitButton)
        
        var cancelButton = UIButton(frame: CGRect(x: submitButton.frame.origin.x + submitButton.frame.width + 20, y: 125, width: 60, height: 23))
        cancelButton.backgroundColor = Color.red
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)
        
        noticeInfoLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.23, y: 160, width: 200, height: 20))
        self.subView.addSubview(noticeInfoLabel)
        
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
    
    func setAccountViewController(accountCtrl:AccountController) {
        self.accountCtrl = accountCtrl
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onButtonTapped(sender: UIButton) {
        if(self.username.text.isEmpty) {
            self.noticeInfoLabel.text="请输入用户名！"
        }
        else if(self.password.text.isEmpty) {
            self.noticeInfoLabel.text="请输入密码！"
        }
        else {
            self.noticeInfoLabel.text=nil
            LoadingDialog.showLoading()
            var params: NSMutableDictionary = NSMutableDictionary()
            params.setValue(username.text, forKey: "username")
            params.setValue(password.text, forKey: "password")
            API.instance.post("/user/register", delegate: self,  params: params)
        }
    }
    
    func error(error: Error, api: String) {
        self.noticeInfoLabel.text=error.getMessage()
        LoadingDialog.dismissLoading()
    }
    
    func userRegister(data:AnyObject) {
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(username.text, forKey: "username")
        params.setValue(password.text, forKey: "password")
        params.setValue(Util.getUDID(), forKey: "udid")
        API.instance.get("/user/login", delegate: self,  params: params)
    }
    
    func userLogin(data:AnyObject) {
        var dic :NSDictionary = data as NSDictionary
        
        CacheDataUtils.saveUserInfo(dic.valueForKey("id")!, userName: dic.valueForKey("username")!, passWord: password.text, holyWater: dic.valueForKey("holyWater")!, isTrial: false)
        
        self.accountCtrl.refreshUserInfo()
        
        LoadingDialog.dismissLoading()
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