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
        self.view.backgroundColor = Color.appBackground
        
        var shouldNotifyLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 200, height: 30))
        shouldNotifyLabel.text = "学习提醒"
        self.view.addSubview(shouldNotifyLabel)
        
        var shouldNotify = UISwitch(frame: CGRect(x: self.view.frame.width - 65, y: 17, width: 100, height: 20))
        shouldNotify.onTintColor = Color.red
        shouldNotify.setOn(true, animated: true)
        self.view.addSubview(shouldNotify)
        
        var shouldAutoVoiceLabel = UILabel(frame: CGRect(x: 15, y: 85, width: 200, height: 20))
        shouldAutoVoiceLabel.text = "自动发音"
        self.view.addSubview(shouldAutoVoiceLabel)
        
        var shouldAutoVoice = UISwitch(frame: CGRect(x: self.view.frame.width - 65, y: 77, width: 100, height: 20))
        shouldAutoVoice.onTintColor = Color.red
        self.view.addSubview(shouldAutoVoice)
        
        var cachedLabel = UILabel(frame: CGRect(x: 15, y: 140, width: 150, height: 20))
        cachedLabel.text = "缓存占用: 20M"
        self.view.addSubview(cachedLabel)
        
        var clearButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 133, width: 70, height: 30))
        clearButton.backgroundColor = Color.gray
        clearButton.setTitle("清理", forState: UIControlState.Normal)
        clearButton.layer.cornerRadius = 15
        clearButton.addTarget(self, action: "onTapDown:", forControlEvents: UIControlEvents.TouchDown)
        clearButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpInside)
        clearButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        clearButton.addTarget(self, action: "clearCache:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(clearButton)
        
        var versionLabel = UILabel(frame: CGRect(x: 15, y: 195, width: 150, height: 20))
        versionLabel.text = "当前版本：1.0.0"
        self.view.addSubview(versionLabel)
        
        var upgradeButton = UIButton(frame: CGRect(x: self.view.frame.width - 85, y: 188, width: 70, height: 30))
        upgradeButton.backgroundColor = Color.gray
        upgradeButton.setTitle("升级", forState: UIControlState.Normal)
        upgradeButton.layer.cornerRadius = 15
        upgradeButton.addTarget(self, action: "onTapDown:", forControlEvents: UIControlEvents.TouchDown)
        upgradeButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpInside)
        upgradeButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        upgradeButton.addTarget(self, action: "upgradeApp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(upgradeButton)
        
        var encourageUsButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height * 0.8, width: 150, height: 30))
        encourageUsButton.backgroundColor = Color.gray
        encourageUsButton.setTitle("求个好评", forState: UIControlState.Normal)
        encourageUsButton.addTarget(self, action: "onTapDown:", forControlEvents: UIControlEvents.TouchDown)
        encourageUsButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpInside)
        encourageUsButton.addTarget(self, action: "onTapUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        encourageUsButton.addTarget(self, action: "goToAppstore:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(encourageUsButton)
    }
    
    func onTapDown(sender: UIButton) {
        sender.backgroundColor = Color.red
    }
    
    func onTapUp(sender: UIButton) {
        sender.backgroundColor = Color.gray
    }
    
    func clearCache(sender: UIButton) {
        println("should cleaer cache here")
    }
    
    func upgradeApp(sender: UIButton) {
        println("should upgrade here")
    }
    
    func goToAppstore(sender: UIButton) {
        // TODO: should go to appstore page.
        println("should go to appstore page")
    }
}