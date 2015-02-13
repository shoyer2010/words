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
    
    var holyWaterLabel :UILabel!
    var usernameLabel  :UILabel!
    var upgradeButton :UIButton!
    var passwordButton :UIButton!
    
    var dictionaryController:DictionaryController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(4)
        self.view.backgroundColor = Color.appBackground
        
        usernameLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 200, height: 30))
        usernameLabel.text = "用户名： shoyer"
        self.view.addSubview(usernameLabel)
        
        upgradeButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 23, width: 70, height: 26))
        upgradeButton.backgroundColor = Color.gray
        upgradeButton.layer.cornerRadius = 13
        upgradeButton.setTitle("升级", forState: UIControlState.Normal)
        upgradeButton.addTarget(self, action: "goToRegisterPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(upgradeButton)
        
        holyWaterLabel = UILabel(frame: CGRect(x: 15, y: 75, width: 200, height: 30))
        holyWaterLabel.text = "圣水： 2323"
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
        
        
        var passwordLabel = UILabel(frame: CGRect(x: 15, y: 125, width: 200, height: 30))
        passwordLabel.text = "密码"
        self.view.addSubview(passwordLabel)
        
        passwordButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 125, width: 70, height: 26))
        passwordButton.backgroundColor = Color.gray
        passwordButton.setTitle("修改", forState: UIControlState.Normal)
        passwordButton.layer.cornerRadius = 13
        passwordButton.addTarget(self, action: "goToChangePasswordPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(passwordButton)
        
        
        var encourageUsButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height * 0.8, width: 150, height: 30))
        encourageUsButton.backgroundColor = Color.gray
        encourageUsButton.setTitle("求个好评", forState: UIControlState.Normal)
        encourageUsButton.addTarget(self, action: "onTapDown:", forControlEvents: UIControlEvents.TouchDown)
        encourageUsButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpInside)
        encourageUsButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        self.view.addSubview(encourageUsButton)
        
        var logoutButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height * 0.8, width: 150, height: 30))
        logoutButton.backgroundColor = Color.red
        logoutButton.setTitle("切换账户", forState: UIControlState.Normal)
        logoutButton.addTarget(self, action: "goToLoginPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoutButton)
        
        autoLogin()
    }
    
    func refreshUserInfo() {
        if(CacheDataUtils.isHasAnUser()) {
            var userInfo :NSDictionary = CacheDataUtils.getUserInfo()! as NSDictionary
            
            var userName = userInfo.valueForKey("userName")! as String
            self.usernameLabel.text = "用户名： \(userName)"
            
            var holyWater = userInfo.valueForKey("holyWater")! as Int
            self.holyWaterLabel.text = "圣水 ： \(holyWater)"
            
            self.upgradeButton.hidden  = !CacheDataUtils.isUserTrial()
            self.passwordButton.hidden = CacheDataUtils.isUserTrial()
            
            self.dictionaryController.refreshDictionaryData()
        }
    }
    
    func autoLogin() {
        LoadingDialog.showLoading()
        
        if(CacheDataUtils.isHasAnUser()) {
            var userInfo :NSDictionary = CacheDataUtils.getUserInfo()! as NSDictionary
            
            var userName = userInfo.valueForKey("userName")! as String
            
            var params: NSMutableDictionary = NSMutableDictionary()
            params.setValue(userName, forKey: "username")
            
            var isTrial = CacheDataUtils.isUserTrial()
            LogUtils.log("isTrial=\(isTrial)")
            
            if(isTrial) {
                params.setValue("", forKey: "password")
                params.setValue(Util.getUDID(), forKey: "udid")
            }else {
                var passWord = userInfo.valueForKey("passWord")! as String
                params.setValue(passWord, forKey: "password")
            }
            
            API.instance.get("/user/login", delegate: self,  params: params)
        }
        else {
            var params: NSMutableDictionary = NSMutableDictionary()
            params.setValue(Util.getUDID(), forKey: "udid")
            API.instance.post("/user/trial", delegate: self,  params: params)
        }
    }
    
    func userTrial(data:AnyObject) {
        var trialDic :NSDictionary = data as NSDictionary
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(trialDic.valueForKey("username"), forKey: "username")
        params.setValue("", forKey: "password")
        params.setValue(Util.getUDID(), forKey: "udid")
        API.instance.get("/user/login", delegate: self,  params: params)
    }
    
    func userLogin(data:AnyObject) {
        //API.instance.get("/dictionary/list", delegate: self)
        
        var userDic :NSDictionary = data as NSDictionary
        
        var isTrial = userDic.valueForKey("trial") as Bool
        if(isTrial) {
            CacheDataUtils.saveUserInfo(userDic.valueForKey("id")!, userName: userDic.valueForKey("username")!, passWord: nil, holyWater: userDic.valueForKey("holyWater")!, isTrial: isTrial)
        }
        refreshUserInfo()
        
        LoadingDialog.dismissLoading()
    }
    
    func setDictionaryViewController(dictionaryController:DictionaryController) {
        self.dictionaryController = dictionaryController
    }
    
    func goToRegisterPage(sender: UIButton) {
        var registerController = RegisterController()
        registerController.setAccountViewController(self)
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
}