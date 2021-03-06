//
//  ArticleForEnglishController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class ArticleForEnglishController: UIViewController, APIDataDelegate, SearchWordResultDelegate, ArticleForChineseDelegate {
    var articleView: UIScrollView!
    var titleView: UILabel!
    var contentView: UILabel!
    var matchWord: String?
    var articleId: String!
    var delegate: ArticleForEnglishDelegate!
    var data: AnyObject!
    var indicator: UIActivityIndicatorView!
    var favouriteIcon: UIView!
    var isFavourite: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: EventKey.ON_PAGE_CHAGNE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onFavouriteChange:", name: EventKey.ON_FAVOURITE_CHANGE, object: nil)
        
        var applicationController = self.parentViewController as ApplicationController
        applicationController.articleForChineseController.delegate = self
        
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

        titleView = UILabel(frame: CGRect(x: 15, y: 15, width: articleView.frame.width - 30, height: 0))
        titleView.userInteractionEnabled = true
        titleView.numberOfLines = 0
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTappedTitleView:"))
        articleView.addSubview(titleView)
        
        contentView = UILabel(frame: CGRect(x: 15, y: 20 + titleView.frame.origin.y + titleView.frame.height, width: articleView.frame.width - 30, height: 0))
        contentView.userInteractionEnabled = true
        contentView.numberOfLines = 0
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTappedContentView:"))
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
    
//    func onTappedContentView222(recognizer: UITapGestureRecognizer) {
//        var tapPoint:CGPoint = recognizer.locationInView(contentView)
//        var framesetter:CTFramesetter = CTFramesetterCreateWithAttributedString(self.contentView.attributedText)
//        var path:CGMutablePath = CGPathCreateMutable();
//        CGPathAddRect(path, nil, CGRectMake(0, 0, self.contentView.frame.width, 10000)); // height must big enough.
//        var textFrame:CTFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,0), path, nil);
//        
//        var lines = CTFrameGetLines(textFrame)
//        var origins = UnsafeMutablePointer<CGPoint>.alloc(CFArrayGetCount(lines))
//        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
//        
//        println("taotal: \(CFArrayGetCount(lines)) lines")
//        for (var i = 0; i < CFArrayGetCount(lines); i++) {
//            var origin:CGPoint = origins[i]
//            var path:CGPath = CTFrameGetPath(textFrame)
//            var rect:CGRect = CGPathGetBoundingBox(path);
//            
//            var y:CGFloat = rect.origin.y + rect.size.height - origin.y + 9  - CGFloat(i);
//            println("i is: \(i) tap y: \(tapPoint.y)   origin y: \(origin.y)  after offset is \(y)")
//            if (tapPoint.y <= y) { // 15 is the offset to make sure the bottom of the line can be deal correctly.
//                println(i)
//                var tappedLine = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), CTLine.self)
//                println(tappedLine)
//                
////                var ascent:UnsafeMutablePointer<CGFloat>
////                var descent:UnsafeMutablePointer<CGFloat>
////                var leading:UnsafeMutablePointer<CGFloat>
////                CTLineGetTypographicBounds(tappedLine, ascent, descent, leading);
////                var index:CFIndex = CTLineGetStringIndexForPosition(tappedLine, tapPoint);
////                println(index)
////                var string = self.contentView.attributedText
////                println(string.string)
////                println(string.length)
//                
////                println(a)
////                lineOrigin = origin;
//                break;
//            }
//        }
//        
//        
//        origins.destroy()
//
////        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
//        
////
////        //获取每行的原点坐标
////        CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
////        CTLineRef line = NULL;
////        CGPoint lineOrigin = CGPointZero;
//    }
    
    func onTappedTitleView(recognizer: UITapGestureRecognizer) {
        var tapPoint:CGPoint = recognizer.locationInView(titleView)
        self.matchWord = Util.recognizeWord(titleView, recognizer: recognizer)
        
        TapPointView(view: titleView, tapPoint: tapPoint, completion: { () -> Void in
            if (self.matchWord != nil) {
                var searchWordResultController = SearchWordResultController()
                searchWordResultController.delegate = self
                self.addChildViewController(searchWordResultController)
                self.view.addSubview(searchWordResultController.view)
                MobClick.event("tapEnglishWord", attributes: ["page": "onTappedTitleView"])
            }
        })
    }
    
    func onTappedContentView(recognizer: UITapGestureRecognizer) {
        var tapPoint:CGPoint = recognizer.locationInView(contentView)
        self.matchWord = Util.recognizeWord(contentView, recognizer: recognizer)
        
        TapPointView(view: contentView, tapPoint: tapPoint, completion: { () -> Void in
            if (self.matchWord != nil) {
                NSUserDefaults.standardUserDefaults().setObject(true, forKey: CacheKey.GUIDE_HAVE_CLICKED_WORD)
                NSUserDefaults.standardUserDefaults().synchronize()
                var searchWordResultController = SearchWordResultController()
                searchWordResultController.delegate = self
                self.addChildViewController(searchWordResultController)
                self.view.addSubview(searchWordResultController.view)
                MobClick.event("tapEnglishWord", attributes: ["page": "onTappedContentView"])
            }
        })
    }
    
    func onPageChange(notification: NSNotification) {
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.ArticleForEnglish) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                self.loadData()
            })
        }
    }
    
    func loadData() {
        var articleId = self.delegate!.setArticleId()
        
        if (articleId != nil && self.articleId != articleId!) {
            var params = NSMutableDictionary()
            params.setValue(articleId!, forKey: "id")
            self.articleId = articleId!
            API.instance.get("/article/detail", delegate: self, params: params)
            self.startLoading()
            
            var haveToPageChinese = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.GUIDE_HAVE_TO_PAGE_CHINESE) as? Bool
            
            if (haveToPageChinese == nil) {
                var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
                self.view.addSubview(view)
                SuccessView(view: view, message: "右滑显示译文", completion: {() in
                    view.removeFromSuperview()
                    self.guideClickWord()
                })
            } else {
                self.guideClickWord()
            }
        }
    }
    
    func guideClickWord() {
        var haveClickedWord = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.GUIDE_HAVE_CLICKED_WORD) as? Bool
        if (haveClickedWord == nil) {
            var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
            self.view.addSubview(view)
            SuccessView(view: view, message: "点击不认识的单词，其意立现", completion: {() in
                view.removeFromSuperview()
            })
        }
    }
    
    func articleDetail(data:AnyObject) {
        self.data = data
        self.setToView(self.data) // TODO: 这里需要优化， 当大段文本加载的时候会性能差的机子会卡住UI
        var info = NSMutableDictionary()
        NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_ARTICLE_CHANGE, object: self)
        self.endLoading()
    }
    
    func startLoading() {
        self.titleView.text = ""
        self.contentView.text = ""
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func endLoading() {
        self.indicator.stopAnimating()
    }
    
    func setToView(data: AnyObject) {
        self.isFavourite = data["isFavourite"] as Bool
        self.setFavouriteIcon()
        
        self.titleView.text = data["titleEnglish"] as? String
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
        
        self.contentView.text = data["english"] as? String
        var paragraphStyleForContent = NSMutableParagraphStyle()
        paragraphStyleForContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForContent.alignment = NSTextAlignment.Justified
        paragraphStyleForContent.paragraphSpacing = 8
        paragraphStyleForContent.lineSpacing = 5
        var attributesForContent = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForContent,
            NSFontAttributeName: UIFont(name: "Times New Roman", size: CGFloat(17))!,
            NSForegroundColorAttributeName: Color.gray,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        contentView.attributedText =  NSAttributedString(string: contentView.text!, attributes: attributesForContent)
        contentView.sizeToFit()
        contentView.frame = CGRect(x: 15, y: 20 + titleView.frame.origin.y + titleView.frame.height, width: articleView.frame.width - 30, height: contentView.frame.height)
        
        articleView.contentSize = CGSize(width: articleView.frame.width, height: 15 + titleView.frame.height + 40 + contentView.frame.height)
        articleView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func searchWord() -> String {
        return self.matchWord!
    }
    
    func setData() -> AnyObject? {
        if (self.data != nil) {
            return self.data
        } else {
            return nil
        }
    }
    
    func onTapFavouriteIcon(sender: UIView) {
        if (self.data != nil) {
            var data: AnyObject = self.data
            var params = NSMutableDictionary()
            params.setValue(data["id"] as? String, forKey: "id")
            
            if (self.isFavourite!) {
                self.isFavourite = false
                API.instance.post("/article/cancelFavourite", delegate: self, params: params)
            } else {
                self.isFavourite = true
                API.instance.post("/article/favourite", delegate: self, params: params)
            }
            
            var userInfo = NSMutableDictionary()
            userInfo.setValue(self.isFavourite, forKey: "isFavourite")
            userInfo.setValue(data["id"], forKey: "id")
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
    
    func error(error: Error, api: String) {
        var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
        self.view.addSubview(view)
        ErrorView(view: view, message: error.getMessage(),completion: {() in
            view.removeFromSuperview()
        })
    }
}