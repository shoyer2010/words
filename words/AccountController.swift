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
        
        var usernameLabel = UILabel(frame: CGRect(x: 15, y: 20, width: 200, height: 20))
        usernameLabel.text = "用户名： shoyer"
        self.view.addSubview(usernameLabel)
        
        var holyWaterLabel = UILabel(frame: CGRect(x: 15, y: 60, width: 200, height: 20))
        holyWaterLabel.text = "圣水： 2323"
        self.view.addSubview(holyWaterLabel)
        
        var getHolyWaterButton = UIButton(frame: CGRect(x: self.view.frame.width - 75, y: 60, width: 60, height: 20))
        getHolyWaterButton.backgroundColor = Color.gray
        getHolyWaterButton.setTitle("获取", forState: UIControlState.Normal)
        self.view.addSubview(getHolyWaterButton)
        
        
        var passwordLabel = UILabel(frame: CGRect(x: 15, y: 100, width: 200, height: 20))
        passwordLabel.text = "密码"
        self.view.addSubview(passwordLabel)
        
        var passwordButton = UIButton(frame: CGRect(x: self.view.frame.width - 75, y: 100, width: 60, height: 20))
        passwordButton.backgroundColor = Color.gray
        passwordButton.setTitle("修改", forState: UIControlState.Normal)
        self.view.addSubview(passwordButton)
        
        var logoutButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 80, y: self.view.frame.height - 60, width: 160, height: 30))
        logoutButton.backgroundColor = UIColor.redColor()
        logoutButton.setTitle("退出", forState: UIControlState.Normal)
        self.view.addSubview(logoutButton)
        
        self.view.backgroundColor = UIColor.lightGrayColor()
    }
}