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
    var delegate: ArticleForChineseDelegate!
    var articleView: UIScrollView!
    var titleView: UILabel!
    var contentView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onArticleChange:", name: EventKey.ON_ARTICLE_CHANGE, object: nil)
        self.view.backgroundColor = Color.red
        
        var topBar = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 35))
        topBar.backgroundColor = Color.red
        
        var favouriteIcon = UIView(frame: CGRect(x: self.view.frame.width / 2 - 12, y: 4, width: 24, height: 24))
        favouriteIcon.backgroundColor = UIColor(patternImage: UIImage(named: "favorite.png")!)
        favouriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapFavouriteIcon:"))
        topBar.addSubview(favouriteIcon)
        self.view.addSubview(topBar)
        
        articleView = UIScrollView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: self.view.frame.height - 55))
        articleView.backgroundColor = Color.appBackground
        
        titleView = UILabel(frame: CGRect(x: 0, y: 0, width: articleView.frame.width - 30, height: 0))
        titleView.numberOfLines = 0
        articleView.addSubview(titleView)
        
        
        contentView = UILabel(frame: CGRect(x: 0, y: 0, width: articleView.frame.width - 30, height: 0))
        contentView.numberOfLines = 0
        articleView.addSubview(contentView)
        
        
//        var image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://img2.ph.126.net/KxxzEMzDehHlaUMZIhczIw==/640637047011103652.jpg")!)!)
//        var imageView = UIImageView(frame: CGRect(x: 15, y: 10 + contentView.frame.origin.y + contentView.frame.height, width: articleView.frame.width - 30, height: image!.size.height * (articleView.frame.width - 30) / image!.size.width))
//        imageView.image = image
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        articleView.addSubview(imageView)
//        
//        var image2 = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://img0.ph.126.net/2YUuhgqNfzaKOR4oU8CJVg==/2772809995594319421.jpg")!)!)
//        var imageView2 = UIImageView(frame: CGRect(x: 15, y: 10 + imageView.frame.origin.y + imageView.frame.height, width: articleView.frame.width - 30, height: image2!.size.height * (articleView.frame.width - 30) / image2!.size.width))
//        imageView2.image = image2
//        imageView2.contentMode = UIViewContentMode.ScaleAspectFit
//        articleView.addSubview(imageView2)
        
        
        self.view.addSubview(articleView)
    }
    
    func onArticleChange(notification: NSNotification) {
        self.setToView(self.delegate!.setData())
    }
    
    func setToView(data: AnyObject) {
        titleView.text = data["titleChinese"] as? String
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
        
        contentView.text = data["chinese"] as? String
        var paragraphStyleForContent = NSMutableParagraphStyle()
        paragraphStyleForContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForContent.alignment = NSTextAlignment.Justified
        paragraphStyleForContent.paragraphSpacing = 10
        paragraphStyleForContent.lineSpacing = 5
        var attributesForContent = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForContent,
            NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(16))!,
            NSForegroundColorAttributeName: Color.gray,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        contentView.attributedText =  NSAttributedString(string: contentView.text!, attributes: attributesForContent)
        contentView.sizeToFit()
        contentView.frame = CGRect(x: 15, y: 10 + titleView.frame.origin.y + titleView.frame.height, width: articleView.frame.width - 30, height: contentView.frame.height)
        
        articleView.contentSize = CGSize(width: articleView.frame.width, height: 20 + titleView.frame.height + 40 + contentView.frame.height)
        articleView.contentOffset = CGPoint(x: 0, y: 0)

    }
    
    func onTapFavouriteIcon(sender: UIView) {
        var data: AnyObject? = self.delegate!.setData()
        if (data != nil) {
            var params = NSMutableDictionary()
            params.setValue(data!["id"] as? String, forKey: "id")
            API.instance.post("/article/favourite", delegate: self, params: params)
        }
    }
    
    func articleFavourite(data: AnyObject) {
        var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
        self.view.addSubview(view)
        SuccessView(view: view, message: "成功收藏", completion: {() in
            view.removeFromSuperview()
        })
    }
    
    func error(error: Error, api: String) {
        var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
        self.view.addSubview(view)
        ErrorView(view: view, message: error.getMessage(),completion: {() in
            view.removeFromSuperview()
        })
    }
}