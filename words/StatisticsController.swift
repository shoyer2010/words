//
//  StatisticsController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIkit

class StatisticsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(1)
        
        self.view.backgroundColor = Color.appBackground
        
        var tableViewWrap = UIView(frame: CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: 131))
        tableViewWrap.backgroundColor = Color.blockBackground
        tableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        tableViewWrap.layer.shadowOffset = Layer.shadowOffset
        tableViewWrap.layer.shadowColor = Layer.shadowColor
        tableViewWrap.layer.shadowRadius = Layer.shadowRadius
        tableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        var tableView = UITableView(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 12))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = Layer.cornerRadius
        tableView.layer.masksToBounds = true
        tableView.scrollEnabled = false
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.userInteractionEnabled = false
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var tableHeader = UIView(frame: CGRect(x: 15, y: 20, width: tableView.frame.width, height: 30))
        tableHeader.backgroundColor = Color.red.colorWithAlphaComponent(0.9)
        var learingLabel = UILabel(frame: CGRect(x:  60, y: 0, width: (tableHeader.frame.width - 60) * 0.33, height: 30))
        learingLabel.text = "已学习"
        learingLabel.font = UIFont(name: learingLabel.font.fontName, size: CGFloat(14))
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: learingLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
        ])
        learingLabel.attributedText = NSAttributedString(string: learingLabel.text!, attributes: attributes)
        tableHeader.addSubview(learingLabel)
        
        var haveLearnedLabel = UILabel(frame: CGRect(x: 60 + (tableHeader.frame.width - 60) * 0.33, y: 0, width: (tableHeader.frame.width - 60) * 0.33, height: 30))
        haveLearnedLabel.text = "已复习"
        haveLearnedLabel.font = UIFont(name: haveLearnedLabel.font.fontName, size: CGFloat(14))
        var attributesForHaveLearnedLabel = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: haveLearnedLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        haveLearnedLabel.attributedText = NSAttributedString(string: haveLearnedLabel.text!, attributes: attributesForHaveLearnedLabel)
        tableHeader.addSubview(haveLearnedLabel)
        
        var haveMasteredLabel = UILabel(frame: CGRect(x: 60 + (tableHeader.frame.width - 60) * 0.66, y: 0, width: (tableHeader.frame.width - 60) * 0.33, height: 30))
        haveMasteredLabel.text = "已掌握"
        haveMasteredLabel.font = UIFont(name: haveMasteredLabel.font.fontName, size: CGFloat(14))
        var attributesForHaveMasteredLabel = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: haveMasteredLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        haveMasteredLabel.attributedText = NSAttributedString(string: haveMasteredLabel.text!, attributes: attributesForHaveMasteredLabel)
        tableHeader.addSubview(haveMasteredLabel)
        tableView.tableHeaderView = tableHeader
        tableViewWrap.addSubview(tableView)
        
        self.view.addSubview(tableViewWrap)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(30)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        var todayLabel = UILabel(frame: CGRect(x: 25, y: 3, width: 24, height: 24))
        todayLabel.backgroundColor = Color.listIconBackground
        switch (indexPath.row) {
        case 0:
            todayLabel.text = "今日"
        case 1:
            todayLabel.text = "本周"
        case 2:
            todayLabel.text = "本月"
        default:
            break
        }
        todayLabel.textColor = Color.white
        todayLabel.textAlignment = NSTextAlignment.Center
        todayLabel.font = UIFont(name: todayLabel.font.fontName, size: CGFloat(11))
        todayLabel.layer.cornerRadius = 12
        todayLabel.layer.masksToBounds = true
        cell.addSubview(todayLabel)
        
        var learnLabel = UILabel(frame: CGRect(x: 60, y: 0, width: (tableView.frame.width - 60) * 0.33, height: 30))
        switch (indexPath.row) {
        case 0:
            learnLabel.text = "23"
        case 1:
            learnLabel.text = "324"
        case 2:
            learnLabel.text = "2323"
        default:
            break
        }
        learnLabel.textColor = Color.gray
        learnLabel.font = UIFont(name: learnLabel.font.fontName, size: CGFloat(14))
        learnLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(learnLabel)
        
        var relearnLabel = UILabel(frame: CGRect(x: 60 + (tableView.frame.width - 60) * 0.33, y: 0, width: (tableView.frame.width - 60) * 0.33, height: 30))
        switch (indexPath.row) {
        case 0:
            relearnLabel.text = "43"
        case 1:
            relearnLabel.text = "545"
        case 2:
            relearnLabel.text = "5656"
        default:
            break
        }
        relearnLabel.textColor = Color.gray
        relearnLabel.font = UIFont(name: relearnLabel.font.fontName, size: CGFloat(14))
        relearnLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(relearnLabel)
        
        var masterLabel = UILabel(frame: CGRect(x: 60 + (tableView.frame.width - 60) * 0.66, y: 0, width: (tableView.frame.width - 60) * 0.33, height: 30))
        switch (indexPath.row) {
        case 0:
            masterLabel.text = "12"
        case 1:
            masterLabel.text = "343"
        case 2:
            masterLabel.text = "565"
        default:
            break
        }
        masterLabel.textColor = Color.gray
        masterLabel.font = UIFont(name: masterLabel.font.fontName, size: CGFloat(14))
        masterLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(masterLabel)

        return cell
    }
}