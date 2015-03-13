//
//  AccountController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class AccountController: UIViewController,APIDataDelegate {
    
    var serviceToLabel: UILabel!
    var usernameLabel: UILabel!
    var upgradeButton: UIButton!
    var passwordLabel: UILabel!
    var passwordButton: UIButton!
    var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegisterSuccess:", name: EventKey.ON_REGISTER_SUCCESS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoginSuccess:", name: EventKey.ON_LOGIN_SUCCESS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shouldLogin:", name: EventKey.SHOULD_LOGIN, object: nil)
        
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(4)
        self.view.backgroundColor = Color.appBackground
        
        usernameLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 200, height: 30))
        usernameLabel.text = "用户名： "
        self.view.addSubview(usernameLabel)
        
        upgradeButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 23, width: 70, height: 26))
        upgradeButton.backgroundColor = Color.gray
        upgradeButton.layer.cornerRadius = 13
        upgradeButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        upgradeButton.setTitle("升 级", forState: UIControlState.Normal)
        upgradeButton.addTarget(self, action: "goToRegisterPage:", forControlEvents: UIControlEvents.TouchUpInside)
        upgradeButton.addTarget(self, action: "onTouchUp:", forControlEvents: UIControlEvents.TouchUpInside | UIControlEvents.TouchDragOutside)
        upgradeButton.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(upgradeButton)
        
        serviceToLabel = UILabel(frame: CGRect(x: 15, y: 75, width: 200, height: 30))
        serviceToLabel.text = "服务到"
        self.view.addSubview(serviceToLabel)
        
        var serviceToInfoButton = UIButton(frame: CGRect(x: serviceToLabel.frame.origin.x + 170, y: 80, width: 20, height: 20))
        serviceToInfoButton.setTitle("i", forState: UIControlState.Normal)
        serviceToInfoButton.backgroundColor = Color.red
        serviceToInfoButton.addTarget(self, action: "showserviceToInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        serviceToInfoButton.layer.cornerRadius = 10
        
        
        self.view.addSubview(serviceToInfoButton)
        
        var getserviceToButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 75, width: 70, height: 26))
        getserviceToButton.backgroundColor = Color.gray
        getserviceToButton.layer.cornerRadius = 13
        getserviceToButton.setTitle("延 长", forState: UIControlState.Normal)
        getserviceToButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        getserviceToButton.addTarget(self, action: "goToBuyserviceToPage:", forControlEvents: UIControlEvents.TouchUpInside)
        getserviceToButton.addTarget(self, action: "onTouchUp:", forControlEvents: UIControlEvents.TouchUpInside | UIControlEvents.TouchDragOutside)
        getserviceToButton.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(getserviceToButton)
        
        
        passwordLabel = UILabel(frame: CGRect(x: 15, y: 125, width: 200, height: 30))
        passwordLabel.text = "密码"
        self.view.addSubview(passwordLabel)
        
        passwordButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 125, width: 70, height: 26))
        passwordButton.backgroundColor = Color.gray
        passwordButton.setTitle("修 改", forState: UIControlState.Normal)
        passwordButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        passwordButton.layer.cornerRadius = 13
        passwordButton.addTarget(self, action: "goToChangePasswordPage:", forControlEvents: UIControlEvents.TouchUpInside)
        passwordButton.addTarget(self, action: "onTouchUp:", forControlEvents: UIControlEvents.TouchUpInside | UIControlEvents.TouchDragOutside)
        passwordButton.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(passwordButton)
        
        logoutButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height - 80, width: 150, height: 32))
        logoutButton.backgroundColor = Color.gray
        logoutButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        logoutButton.setTitle("切换账户", forState: UIControlState.Normal)
        logoutButton.addTarget(self, action: "goToLoginPage:", forControlEvents: UIControlEvents.TouchUpInside)
        logoutButton.addTarget(self, action: "onTouchUp:", forControlEvents: UIControlEvents.TouchUpInside | UIControlEvents.TouchDragOutside)
        logoutButton.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(logoutButton)
        
        
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        if (user == nil) {
            var params = NSMutableDictionary()
            params.setValue(Util.getUDID(), forKey: "udid")
            
            if (Util.isSimulator()) {
                params.setValue(1, forKey: "from")
            } else {
                params.setValue(2, forKey: "from")
            }
            
            API.instance.post("/user/trial", delegate: self, params: params)
        } else {
            self.setToView(user!)
            self.login(user!)
        }
    }
    
    func onTouchDown(sender: UIButton) {
        sender.backgroundColor = Color.red
    }
    
    func onTouchUp(sender: UIButton) {
        sender.backgroundColor = Color.gray
    }
    
    func userTrial(data:AnyObject) {
        login(data)
    }
    
    func login(user: AnyObject) {
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(user["username"], forKey: "username")
        params.setValue(user["password"], forKey: "password")
        params.setValue(Util.getUDID(), forKey: "udid")
        API.instance.get("/user/login", delegate: self,  params: params)
    }
    
    func userLogin(data:AnyObject) {
        var oldUser: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        
        if (oldUser != nil && (oldUser!["id"] as String) != (data["id"] as String)) {
            Util.clearCache()
        }
        
        var user = NSMutableDictionary()
        user.setDictionary(data as NSDictionary)
        user.setValue(oldUser?["password"], forKey: "password")
        NSUserDefaults.standardUserDefaults().setObject(user as AnyObject, forKey: CacheKey.USER)
        NSUserDefaults.standardUserDefaults().setObject(time(nil), forKey: CacheKey.LAST_LOGIN_AT)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.setToView(data)
        NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_LOGIN_SUCCESS, object: self, userInfo: nil)
    }
    
    func onRegisterSuccess(notification: NSNotification) {
        var user: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        self.setToView(user!)
    }
    
    func shouldLogin(notification: NSNotification) {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        if (user != nil) {
            self.setToView(user!)
            self.login(user!)
        }
    }
    
    func onLoginSuccess(notification: NSNotification) {
        var user: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        self.setToView(user!)
        self.postActiveTime()
    }
    
    func postActiveTime() {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        var userId = user!["id"] as NSString
        
        var seconds: Int? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.ACTIVE_TIME) as? Int
        if (seconds != nil && seconds! > 0) {
            var params = NSMutableDictionary()
            params.setValue(seconds, forKey: "seconds")
            var random = ("\(time(nil))" as NSString).md5()
            var signString = NSString(string: "\(userId)\(seconds!)b79b517ce8cd6cf7c4ed8238ae4a3821\(random)")
            params.setValue(signString.md5(), forKey: "sign")
            params.setValue(random, forKey: "random")
            API.instance.post("/user/activeTime", delegate: self, params: params)
        }
    }
    
    func activeTime(data: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.ACTIVE_TIME)
    }
    
    func setToView(user: AnyObject) {
        self.usernameLabel.text = "用户名： " + (user["username"] as String)
        var isTrial = user["trial"] as Bool
        self.upgradeButton.hidden = !isTrial
        self.passwordLabel.hidden = isTrial
        self.passwordButton.hidden = isTrial
        self.logoutButton.hidden = isTrial
        
        var serviceTo = user["serviceTo"] as? Int
        if serviceTo == nil {
            serviceTo = 0
        }
        self.serviceToLabel.text = "服务到： \(DateUtil.standardDate(serviceTo!))"
    }
    
    func goToRegisterPage(sender: UIButton) {
        var registerController = RegisterController()
        self.addChildViewController(registerController)
        self.view.addSubview(registerController.view)
        MobClick.event("goToRegisterPage")
    }
    
    func goToChangePasswordPage(sender: UIButton) {
        var changePasswordController = ChangePasswordController()
        self.addChildViewController(changePasswordController)
        self.view.addSubview(changePasswordController.view)
        MobClick.event("goToChangePasswordPage")
    }
    
    func goToBuyserviceToPage(sender: UIButton) {
        var buyServiceController = BuyServiceController()
        self.addChildViewController(buyServiceController)
        self.view.addSubview(buyServiceController.view)
        MobClick.event("goToBuyserviceToPage")
    }
    
    func showserviceToInfo(sender: UIButton) {
        var serviceInfoController = ServiceInfoController()
        self.addChildViewController(serviceInfoController)
        self.view.addSubview(serviceInfoController.view)
        MobClick.event("showserviceToInfo")
    }
    
    func goToLoginPage(sender: UIButton) {
        var loginController = LoginController()
        self.addChildViewController(loginController)
        self.view.addSubview(loginController.view)
        MobClick.event("goToLoginPage")
    }
    
    func error(error: Error, api: String) {
        println(error.getMessage())
    }
}