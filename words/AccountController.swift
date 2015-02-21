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
    
    var holyWaterLabel: UILabel!
    var usernameLabel: UILabel!
    var upgradeButton: UIButton!
    var passwordLabel: UILabel!
    var passwordButton: UIButton!
    var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegisterSuccess:", name: "onRegisterSuccess", object: nil)
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(4)
        self.view.backgroundColor = Color.appBackground
        
        usernameLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 200, height: 30))
        usernameLabel.text = "用户名： "
        self.view.addSubview(usernameLabel)
        
        upgradeButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 23, width: 70, height: 26))
        upgradeButton.backgroundColor = Color.gray
        upgradeButton.layer.cornerRadius = 13
        upgradeButton.setTitle("升级", forState: UIControlState.Normal)
        upgradeButton.addTarget(self, action: "goToRegisterPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(upgradeButton)
        
        holyWaterLabel = UILabel(frame: CGRect(x: 15, y: 75, width: 200, height: 30))
        holyWaterLabel.text = "圣水： 0"
        self.view.addSubview(holyWaterLabel)
        
        var holyWaterInfoButton = UIButton(frame: CGRect(x: holyWaterLabel.frame.origin.x + 100, y: 80, width: 20, height: 20))
        holyWaterInfoButton.setTitle("i", forState: UIControlState.Normal)
        holyWaterInfoButton.backgroundColor = Color.red
        holyWaterInfoButton.addTarget(self, action: "showHolyWaterInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        holyWaterInfoButton.layer.cornerRadius = 10
        
        
        self.view.addSubview(holyWaterInfoButton)
        
        var getHolyWaterButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 75, width: 70, height: 26))
        getHolyWaterButton.backgroundColor = Color.gray
        getHolyWaterButton.layer.cornerRadius = 13
        getHolyWaterButton.setTitle("获取", forState: UIControlState.Normal)
        getHolyWaterButton.addTarget(self, action: "goToBuyHolyWaterPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(getHolyWaterButton)
        
        
        passwordLabel = UILabel(frame: CGRect(x: 15, y: 125, width: 200, height: 30))
        passwordLabel.text = "密码"
        self.view.addSubview(passwordLabel)
        
        passwordButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 125, width: 70, height: 26))
        passwordButton.backgroundColor = Color.gray
        passwordButton.setTitle("修改", forState: UIControlState.Normal)
        passwordButton.layer.cornerRadius = 13
        passwordButton.addTarget(self, action: "goToChangePasswordPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(passwordButton)
        
        logoutButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height * 0.8, width: 150, height: 30))
        logoutButton.backgroundColor = Color.red
        logoutButton.setTitle("切换账户", forState: UIControlState.Normal)
        logoutButton.addTarget(self, action: "goToLoginPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoutButton)
        
        
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        if (user == nil) {
            var params = NSMutableDictionary()
            params.setValue(Util.getUDID(), forKey: "udid")
            API.instance.post("/user/trial", delegate: self, params: params)
        } else {
            self.setToView(user!)
            self.login(user!)
        }
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
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: CacheKey.USER)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.setToView(data)
    }
    
    func onRegisterSuccess(notification: NSNotification) {
        var user: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        self.setToView(user!)
    }
    
    func setToView(user: AnyObject) {
        self.usernameLabel.text = "用户名： " + (user["username"] as String)
        var isTrial = user["trial"] as Bool
        self.upgradeButton.hidden = !isTrial
        self.passwordLabel.hidden = isTrial
        self.passwordButton.hidden = isTrial
        self.logoutButton.hidden = isTrial
        
        var holyWater = user["holyWater"] as Int
        self.holyWaterLabel.text = "圣水： \(holyWater)"
    }
    
    func goToRegisterPage(sender: UIButton) {
        var registerController = RegisterController()
        self.addChildViewController(registerController)
        self.view.addSubview(registerController.view)
    }
    
    func goToChangePasswordPage(sender: UIButton) {
        var changePasswordController = ChangePasswordController()
        self.addChildViewController(changePasswordController)
        self.view.addSubview(changePasswordController.view)
    }
    
    func goToBuyHolyWaterPage(sender: UIButton) {
        var buyHolyWaterController = BuyHolyWaterController()
        self.addChildViewController(buyHolyWaterController)
        self.view.addSubview(buyHolyWaterController.view)
    }
    
    func showHolyWaterInfo(sender: UIButton) {
        var holyWaterInfoController = HolyWaterInfoController()
        self.addChildViewController(holyWaterInfoController)
        self.view.addSubview(holyWaterInfoController.view)
    }
    
    func goToLoginPage(sender: UIButton) {
        var loginController = LoginController()
        loginController.setAccountViewController(self)
        self.addChildViewController(loginController)
        self.view.addSubview(loginController.view)
    }
    
    func error(error: Error, api: String) {
        println(error.getMessage())
    }
}