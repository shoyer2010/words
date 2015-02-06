//
//  AccountController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class AccountController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(4)
        self.view.backgroundColor = Color.appBackground
        
        var usernameLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 200, height: 30))
        usernameLabel.text = "用户名： shoyer"
        self.view.addSubview(usernameLabel)
        
        var holyWaterLabel = UILabel(frame: CGRect(x: 15, y: 75, width: 200, height: 30))
        holyWaterLabel.text = "圣水： 2323"
        self.view.addSubview(holyWaterLabel)
        
        var getHolyWaterButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 75, width: 70, height: 26))
        getHolyWaterButton.backgroundColor = Color.gray
        getHolyWaterButton.layer.cornerRadius = 13
        getHolyWaterButton.setTitle("获取", forState: UIControlState.Normal)
        getHolyWaterButton.addTarget(self, action: "goToBuyHolyWaterPage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(getHolyWaterButton)
        
        
        var passwordLabel = UILabel(frame: CGRect(x: 15, y: 125, width: 200, height: 30))
        passwordLabel.text = "密码"
        self.view.addSubview(passwordLabel)
        
        var passwordButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 125, width: 70, height: 26))
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
        self.view.addSubview(logoutButton)
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
}