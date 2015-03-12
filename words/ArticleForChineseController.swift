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
    var articleId: String?
    
    var indicator: UIActivityIndicatorView!
    
    var favouriteIcon: UIView!
    var isFavourite: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onArticleChange:", name: EventKey.ON_ARTICLE_CHANGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: EventKey.ON_PAGE_CHAGNE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onFavouriteChange:", name: EventKey.ON_FAVOURITE_CHANGE, object: nil)
        
        self.view.backgroundColor = Color.red
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15, y: self.view.frame.height / 2 - 15, width: 30, height: 30))
        indicator.color = Color.red
        self.view.addSubview(indicator)
        
        var topBar = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 35))
        topBar.backgroundColor = Color.red
        
        favouriteIcon = UIView(frame: CGRect(x: self.view.frame.width / 2 - 12, y: 4, width: 24, height: 24))
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
    
    func onPageChange(notification: NSNotification) {
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.ArticleForChinese) {
            self.setToView(self.delegate!.setData())
            self.endLoading()
        }
    }
    
    func onArticleChange(notification: NSNotification) {
        self.clearData()
    }
    
    func clearData() {
        titleView.text = ""
        contentView.text = ""
        self.startLoading()
    }
    
    func setToView(data: AnyObject?) {
        if (data == nil) {
            return
        }
        
        var id = data!["id"] as String
        if (self.articleId == id) {
            return
        } else {
            self.articleId = id
        }
        
        self.isFavourite = data!["isFavourite"] as Bool
        self.setFavouriteIcon()
        
        titleView.text = data!["titleChinese"] as? String
        var paragraphStyleForTitle = NSMutableParagraphStyle()
        paragraphStyleForTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForTitle.alignment = NSTextAlignment.Justified
        paragraphStyleForTitle.paragraphSpacing = 1
        paragraphStyleForTitle.lineSpacing = 8
        var attributesForTitle = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForTitle,
            NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(21))!,
            NSForegroundColorAttributeName: Color.black,
            NSStrokeWidthAttributeName: NSNumber(float: -2.5)
            ])
        titleView.attributedText =  NSAttributedString(string: titleView.text!, attributes: attributesForTitle)
        titleView.sizeToFit()
        titleView.frame = CGRect(x: 15, y: 20, width: articleView.frame.width - 30, height: titleView.frame.height)
        
        contentView.text = data!["chinese"] as? String
        var paragraphStyleForContent = NSMutableParagraphStyle()
        paragraphStyleForContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForContent.alignment = NSTextAlignment.Justified
        paragraphStyleForContent.paragraphSpacing = 10
        paragraphStyleForContent.lineSpacing = 5
        var attributesForContent = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForContent,
            NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(17))!,
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
            
            if (self.isFavourite!) {
                self.isFavourite = false
                API.instance.post("/article/cancelFavourite", delegate: self, params: params)
                
            } else {
                self.isFavourite = true
                API.instance.post("/article/favourite", delegate: self, params: params)
            }
            
            var userInfo = NSMutableDictionary()
            userInfo.setValue(self.isFavourite, forKey: "isFavourite")
            userInfo.setValue(data!["id"], forKey: "id")
            NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_FAVOURITE_CHANGE, object: self, userInfo: userInfo)
        }
    }
    
    func articleCancelFavourite(data: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
            self.view.addSubview(view)
            SuccessView(view: view, message: "已取消收藏", completion: {() in
                view.removeFromSuperview()
            })
        })
    }
    
    func onFavouriteChange(notification: NSNotification) {
        self.isFavourite = notification.userInfo!["isFavourite"] as Bool
        self.setFavouriteIcon()
    }
    
    func setFavouriteIcon() {
        if (self.isFavourite!) {
            favouriteIcon.backgroundColor = UIColor(patternImage: UIImage(named: "favorited.png")!)
        } else {
            favouriteIcon.backgroundColor = UIColor(patternImage: UIImage(named: "favorite.png")!)
        }
    }
    
    func articleFavourite(data: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
            self.view.addSubview(view)
            SuccessView(view: view, message: "成功收藏", completion: {() in
                view.removeFromSuperview()
            })
        })
    }
    
    func startLoading() {
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func endLoading() {
        self.indicator.stopAnimating()
    }
    
    func error(error: Error, api: String) {
        var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
        self.view.addSubview(view)
        ErrorView(view: view, message: error.getMessage(),completion: {() in
            view.removeFromSuperview()
        })
    }
}