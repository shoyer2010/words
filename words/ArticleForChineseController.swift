//
//  ArticleForChineseController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class ArticleForChineseController: UIViewController, APIDataDelegate {
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
        
        var titleView = UILabel(frame: CGRect(x: 0, y: 0, width: articleView.frame.width - 30, height: 0))
        titleView.numberOfLines = 0
        titleView.text = "历史上那些失败的军事发明史上那些失败的军事"
        var paragraphStyleForTitle = NSMutableParagraphStyle()
        paragraphStyleForTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForTitle.alignment = NSTextAlignment.Justified
        paragraphStyleForTitle.paragraphSpacing = 1
        paragraphStyleForTitle.lineSpacing = 1
        var attributesForTitle = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForTitle,
            NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(20))!,
            NSForegroundColorAttributeName: Color.black,
            NSStrokeWidthAttributeName: NSNumber(float: -2.5)
            ])
        titleView.attributedText =  NSAttributedString(string: titleView.text!, attributes: attributesForTitle)
        titleView.sizeToFit()
        titleView.frame = CGRect(x: 15, y: 20, width: articleView.frame.width - 30, height: titleView.frame.height)
        articleView.addSubview(titleView)
        
        
        var contentView = UILabel(frame: CGRect(x: 0, y: 0, width: articleView.frame.width - 30, height: 0))
        contentView.numberOfLines = 0
        contentView.text = "    在2015年里，我们仍将继续面对着纷繁复杂的全球军事态势：亚太一触即发的对峙、中东不绝于耳的炮火、动乱的乌克兰东部、蔓延全球的恐怖主义，以及虎视眈眈的美日联军，但我们同时也将继续看到中国的军力日益强大的喜悦现实。《军迷俱乐部》今后将选取网友关注度最高的最新军事动态，历史秘闻以及武器装备的“一手信息”作为栏目内容的话题，关注我们的军迷朋友可以将你最希望了解的军事信息话题告诉我们。"
        var paragraphStyleForContent = NSMutableParagraphStyle()
        paragraphStyleForContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForContent.alignment = NSTextAlignment.Justified
        paragraphStyleForContent.paragraphSpacing = 10
        paragraphStyleForContent.lineSpacing = 5
        var attributesForContent = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForContent,
            NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(15))!,
            NSForegroundColorAttributeName: Color.gray,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        contentView.attributedText =  NSAttributedString(string: contentView.text!, attributes: attributesForContent)
        contentView.sizeToFit()
        contentView.frame = CGRect(x: 15, y: 10 + titleView.frame.origin.y + titleView.frame.height, width: articleView.frame.width - 30, height: contentView.frame.height)
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
        
        articleView.contentSize = CGSize(width: articleView.frame.width, height: 20 + titleView.frame.height + 40 + contentView.frame.height + imageView.frame.height + imageView2.frame.height)
        self.view.addSubview(articleView)
    }
    
    func onTapFavouriteIcon(sender: UIView) {
        
    }

}