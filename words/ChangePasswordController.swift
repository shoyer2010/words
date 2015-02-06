
import Foundation
import UIKit

class ChangePasswordController: UIViewController, APIDataDelegate {
    var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        
        self.subView = UIView(frame: CGRect(x: 0, y: -150, width: self.view.frame.width, height: 150))
        self.subView.backgroundColor = Color.white.colorWithAlphaComponent(0.89)
        self.subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.subView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.subView)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, 150)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
        }
        
        var oldPassword = UILabel(frame: CGRect(x: self.view.frame.width * 0.23, y: 20, width: 60, height: 20))
        oldPassword.text = "原密码"
        self.subView.addSubview(oldPassword)
        
        var oldPasswordInput = UITextField(frame: CGRect(x: oldPassword.frame.origin.x + oldPassword.frame.width, y: 20, width: 120, height: 20))
        oldPasswordInput.backgroundColor = Color.white
        oldPasswordInput.secureTextEntry = true
        self.subView.addSubview(oldPasswordInput)
        
        var newPassword = UILabel(frame: CGRect(x: self.view.frame.width * 0.23, y: 55, width: 60, height: 20))
        newPassword.text = "新密码"
        self.subView.addSubview(newPassword)
        
        var newPasswordInput = UITextField(frame: CGRect(x: newPassword.frame.origin.x + newPassword.frame.width, y: 55, width: 120, height: 20))
        newPasswordInput.backgroundColor = Color.white
        newPasswordInput.secureTextEntry = true
        self.subView.addSubview(newPasswordInput)
        
        var submitButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 70, y: 100, width: 60, height: 23))
        submitButton.backgroundColor = Color.gray
        submitButton.setTitle("修改", forState: UIControlState.Normal)
        self.subView.addSubview(submitButton)
        
        var cancelButton = UIButton(frame: CGRect(x: submitButton.frame.origin.x + submitButton.frame.width + 20, y: 100, width: 60, height: 23))
        cancelButton.backgroundColor = Color.red
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(cancelButton)
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
            self.subView.transform = CGAffineTransformMakeTranslation(0, -150)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
}