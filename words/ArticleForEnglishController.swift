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
        
        var favouriteIcon = UIView(frame: CGRect(x: self.view.frame.width / 2 - 12, y: 4, width: 24, height: 24))
        favouriteIcon.backgroundColor = UIColor(patternImage: UIImage(named: "favorite.png")!)
        favouriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapFavouriteIcon:"))
        topBar.addSubview(favouriteIcon)
        self.view.addSubview(topBar)
        
        var articleView = UIScrollView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: self.view.frame.height - 55))
        articleView.backgroundColor = Color.appBackground

        var titleView = UILabel(frame: CGRect(x: 15, y: 15, width: articleView.frame.width - 30, height: 0))
        titleView.numberOfLines = 0
        titleView.text = "Jordan said Sunday it destroyed 56 targets in three days of strikes "
        var paragraphStyleForTitle = NSMutableParagraphStyle()
        paragraphStyleForTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForTitle.alignment = NSTextAlignment.Justified
        paragraphStyleForTitle.paragraphSpacing = 1
        paragraphStyleForTitle.lineSpacing = 1
        var attributesForTitle = NSDictionary(dictionary: [
                    NSParagraphStyleAttributeName: paragraphStyleForTitle,
                    NSFontAttributeName: UIFont(name: "Times New Roman", size: CGFloat(20))!,
                    NSForegroundColorAttributeName: Color.black,
                    NSStrokeWidthAttributeName: NSNumber(float: -2.8)
                    ])
        titleView.attributedText =  NSAttributedString(string: titleView.text!, attributes: attributesForTitle)
        titleView.sizeToFit()
        titleView.frame = CGRect(x: 15, y: 15, width: articleView.frame.width - 30, height: titleView.frame.height)
        articleView.addSubview(titleView)
        
        
        var contentView = UILabel(frame: CGRect(x: 15, y: 20 + titleView.frame.origin.y + titleView.frame.height, width: articleView.frame.width - 30, height: 0))
        contentView.numberOfLines = 0
        contentView.text = "Jordan said Sunday it destroyed 56 targets in three days of strikes on the Islamic State group after it murdered one of its pilots, and is determined to destroy IS. \n   Air Force chief Major General Mansour al-Jobour did not specify where the strikes took place, but told reporters the air raids launched since Thursday had destroyed 20 percent of IS capabilities. \n   Jordan said Sunday it destroyed 56 targets in three days of strikes on the Islamic State group after it murdered one of its pilots, and is determined to destroy IS. \n   Air Force chief Major General Mansour al-Jobour did not specify where the strikes took place, but told reporters the air raids launched since Thursday had destroyed 20 percent of IS capabilities."
        var paragraphStyleForContent = NSMutableParagraphStyle()
        paragraphStyleForContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForContent.alignment = NSTextAlignment.Justified
        paragraphStyleForContent.paragraphSpacing = 10
        paragraphStyleForContent.lineSpacing = 5
        var attributesForContent = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForContent,
            NSFontAttributeName: UIFont(name: "Times New Roman", size: CGFloat(16))!,
            NSForegroundColorAttributeName: Color.gray,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        contentView.attributedText =  NSAttributedString(string: contentView.text!, attributes: attributesForContent)
        contentView.sizeToFit()
        contentView.frame = CGRect(x: 15, y: 20 + titleView.frame.origin.y + titleView.frame.height, width: articleView.frame.width - 30, height: contentView.frame.height)
        articleView.addSubview(contentView)
        
        
        var image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://img2.ph.126.net/KxxzEMzDehHlaUMZIhczIw==/640637047011103652.jpg")!)!)
        var imageView = UIImageView(frame: CGRect(x: 15, y: 10 + contentView.frame.origin.y + contentView.frame.height, width: articleView.frame.width - 30, height: image!.size.height * (articleView.frame.width - 30) / image!.size.width))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        articleView.addSubview(imageView)
        
        var image2 = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://img0.ph.126.net/2YUuhgqNfzaKOR4oU8CJVg==/2772809995594319421.jpg")!)!)
        var imageView2 = UIImageView(frame: CGRect(x: 15, y: 10 + imageView.frame.origin.y + imageView.frame.height, width: articleView.frame.width - 30, height: image2!.size.height * (articleView.frame.width - 30) / image2!.size.width))
        imageView2.image = image2
        imageView2.contentMode = UIViewContentMode.ScaleAspectFit
        articleView.addSubview(imageView2)

        articleView.contentSize = CGSize(width: articleView.frame.width, height: 15 + titleView.frame.height + 40 + contentView.frame.height + imageView.frame.height + imageView2.frame.height)
        self.view.addSubview(articleView)
    }
    
    func onTapFavouriteIcon(sender: UIView) {
        
    }
}