//
//  StatisticsController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIkit

class StatisticsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(1)
        
        self.view.backgroundColor = UIColor(red:0, green:1, blue:0, alpha: 1)
        
        var haveMasteredLabel = UILabel(frame: CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: 20))
        haveMasteredLabel.text = "已掌握单词： 2323个"
        self.view.addSubview(haveMasteredLabel)
        
        var todayHaveLearnedLabel = UILabel(frame: CGRect(x: 15, y: 80, width: self.view.frame.width - 30, height: 20))
        todayHaveLearnedLabel.text = "今日已学习单词： 23个"
        self.view.addSubview(todayHaveLearnedLabel)
        
        var todayHaveReLearnedLabel = UILabel(frame: CGRect(x: 15, y: 120, width: self.view.frame.width - 30, height: 20))
        todayHaveReLearnedLabel.text = "今日已复习单词： 24个"
        self.view.addSubview(todayHaveReLearnedLabel)
        
        var weekHaveLearnedLabel = UILabel(frame: CGRect(x: 15, y: 180, width: self.view.frame.width - 30, height: 20))
        weekHaveLearnedLabel.text = "本周已学习单词： 240个"
        self.view.addSubview(weekHaveLearnedLabel)
        
        var weekHaveReLearnedLabel = UILabel(frame: CGRect(x: 15, y: 220, width: self.view.frame.width - 30, height: 20))
        weekHaveReLearnedLabel.text = "本周已复习单词： 2400个"
        self.view.addSubview(weekHaveReLearnedLabel)
    }
}