//
//  ArticleForEnglishController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class ArticleForEnglishController: UIViewController, APIDataDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.red
        
        var topBar = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 35))
        topBar.backgroundColor = Color.red
        
        var favouriteIcon = UIView(frame: CGRect(x: 15, y: 4, width: 24, height: 24))
        favouriteIcon.backgroundColor = UIColor(patternImage: UIImage(named: "favorite.png")!)
        favouriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapFavouriteIcon:"))
        topBar.addSubview(favouriteIcon)
        self.view.addSubview(topBar)
        
        var articleView = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: self.view.frame.height - 55))
        articleView.backgroundColor = Color.appBackground
        
        var contentView = UITextView(frame: CGRect(x: 15, y: 0, width: articleView.frame.width - 30, height: articleView.frame.height))
        contentView.editable = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.backgroundColor = Color.appBackground
        
        
        contentView.text = "Jordan said Sunday it destroyed 56 targets in three days of strikes on the Islamic State group after it murdered one of its pilots, and is determined to destroy IS. \n   Air Force chief Major General Mansour al-Jobour did not specify where the strikes took place, but told reporters the air raids launched since Thursday had destroyed 20 percent of IS capabilities. \n   Jordan said Sunday it destroyed 56 targets in three days of strikes on the Islamic State group after it murdered one of its pilots, and is determined to destroy IS. \n   Air Force chief Major General Mansour al-Jobour did not specify where the strikes took place, but told reporters the air raids launched since Thursday had destroyed 20 percent of IS capabilities. \n "
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Justified
        paragraphStyle.paragraphSpacing = 10
        paragraphStyle.lineSpacing = 5
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: UIFont(name: "Times New Roman", size: CGFloat(16))!,
            NSForegroundColorAttributeName: Color.gray,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        contentView.attributedText =  NSAttributedString(string: contentView.text!, attributes: attributes)
        articleView.addSubview(contentView)
        self.view.addSubview(articleView)
    }
    
    func onTapFavouriteIcon(sender: UIView) {
        
    }
}