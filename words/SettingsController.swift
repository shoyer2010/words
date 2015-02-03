//
//  SettingsController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(3)
        
        var shouldNotifyLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 200, height: 20))
        shouldNotifyLabel.text = "学习提醒"
        self.view.addSubview(shouldNotifyLabel)
        
        var shouldNotify = UISwitch(frame: CGRect(x: self.view.frame.width - 65, y: 20, width: 60, height: 20))
        self.view.addSubview(shouldNotify)
        
        var shouldAutoVoiceLabel = UILabel(frame: CGRect(x: 15, y: 75, width: 200, height: 20))
        shouldAutoVoiceLabel.text = "自动发音"
        self.view.addSubview(shouldAutoVoiceLabel)
        
        var shouldAutoVoice = UISwitch(frame: CGRect(x: self.view.frame.width - 65, y: 70, width: 60, height: 20))
        self.view.addSubview(shouldAutoVoice)
        
        var cachedLabel = UILabel(frame: CGRect(x: 15, y: 120, width: 150, height: 20))
        cachedLabel.text = "缓存占用: 20M"
        self.view.addSubview(cachedLabel)
        
        var clearButton = UIButton(frame: CGRect(x: self.view.frame.width - 75, y: 120, width: 60, height: 20))
        clearButton.backgroundColor = Color.gray
        clearButton.setTitle("清理", forState: UIControlState.Normal)
        self.view.addSubview(clearButton)
        
        self.view.backgroundColor = UIColor(red:1, green:0, blue:1, alpha: 1)
    }
}