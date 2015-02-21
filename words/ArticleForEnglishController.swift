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

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: "onPageChange", object: nil)
        var applicationController = self.parentViewController as ApplicationController
        applicationController.articleForChineseController.delegate = self
        
        self.view.backgroundColor = Color.red
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60))
        indicator.color = Color.red
        self.view.addSubview(indicator)


        
        var topBar = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 35))
        topBar.backgroundColor = Color.red
        
        var favouriteIcon = UIView(frame: CGRect(x: self.view.frame.width / 2 - 12, y: 4, width: 24, height: 24))
        favouriteIcon.backgroundColor = UIColor(patternImage: UIImage(named: "favorite.png")!)
        favouriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapFavouriteIcon:"))
        topBar.addSubview(favouriteIcon)
        self.view.addSubview(topBar)
        
        articleView = UIScrollView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: self.view.frame.height - 55))
        articleView.backgroundColor = Color.appBackground

        titleView = UILabel(frame: CGRect(x: 15, y: 15, width: articleView.frame.width - 30, height: 0))
        titleView.numberOfLines = 0
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
    
    
    func onTappedContentView(recognizer: UITapGestureRecognizer) {
        var tapPoint:CGPoint = recognizer.locationInView(contentView)
        
        var textStorage = NSTextStorage(attributedString: contentView.attributedText)
        var layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        var textContainer = NSTextContainer(size: CGSize(width: contentView.frame.width, height: contentView.frame.height + 2000))
        textContainer.lineFragmentPadding  = 0;
        layoutManager.addTextContainer(textContainer)
        
        var characterIndex = layoutManager.characterIndexForPoint(tapPoint, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if (characterIndex < textStorage.length) {
            
            var startIndex = characterIndex
            for ( ; startIndex > 0; startIndex--) {
                var char = contentView.attributedText.attributedSubstringFromRange(NSRange(location: startIndex, length: 1))
                if (!RegularExpression("[A-Za-z]").test(char.string)) {
                    if (startIndex < textStorage.length - 1) {
                        startIndex++
                    }
                    
                    break;
                }
            }
            
            var endIndex = characterIndex >= contentView.attributedText.length - 1 ? characterIndex : characterIndex + 1
            for ( ; endIndex < textStorage.length - 1; endIndex++) {
                var char = contentView.attributedText.attributedSubstringFromRange(NSRange(location: endIndex, length: 1))
                if (!RegularExpression("[A-Za-z]").test(char.string)) {
                    break;
                }
            }
            
            var word = contentView.attributedText.attributedSubstringFromRange(NSRange(location: startIndex, length: endIndex - startIndex))
            self.matchWord = word.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if (!RegularExpression("[A-Za-z]").test(self.matchWord!)) {
                self.matchWord = nil
            }
            
            
            var redPoint = UIView(frame: CGRect(x: tapPoint.x - 1, y: tapPoint.y - 1, width: 2, height: 2))
            redPoint.backgroundColor = Color.red.colorWithAlphaComponent(0)
            redPoint.layer.cornerRadius = 1
            redPoint.layer.shadowRadius = 0.5
            redPoint.layer.shadowOffset = CGSize(width: 0, height: 0)
            redPoint.layer.shadowOpacity = 1
            redPoint.layer.shadowColor = Color.red.CGColor
            contentView.addSubview(redPoint)
            contentView.bringSubviewToFront(redPoint)
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                redPoint.transform = CGAffineTransformMakeScale(10, 10)
                redPoint.backgroundColor = Color.red.colorWithAlphaComponent(1)
                }) { (isDone: Bool) -> Void in
                    redPoint.removeFromSuperview()
                    
                    if (self.matchWord != nil) {
                        var searchWordResultController = SearchWordResultController()
                        searchWordResultController.delegate = self
                        self.addChildViewController(searchWordResultController)
                        self.view.addSubview(searchWordResultController.view)
                    }
            }

            
            
        }
    }
    
    func onPageChange(notification: NSNotification) {
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.ArticleForEnglish) {
            loadData()
        }
    }
    
    func loadData() {
        if (self.articleId != self.delegate!.setArticleId()) {
            var params = NSMutableDictionary()
            params.setValue(self.delegate!.setArticleId(), forKey: "id")
            self.articleId = self.delegate!.setArticleId()
            API.instance.get("/article/detail", delegate: self, params: params)
            self.startLoading()
        }
    }
    
    func articleDetail(data:AnyObject) {
        println(data)
        self.data = data
        self.setToView(self.data)
        
        var info = NSMutableDictionary()
        NSNotificationCenter.defaultCenter().postNotificationName("onArticleChange", object: self)
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
    
    func setData() -> AnyObject {
        return self.data
    }
    
    func onTapFavouriteIcon(sender: UIView) {
        var data: AnyObject = self.data
        var params = NSMutableDictionary()
        params.setValue(data["id"] as? String, forKey: "id")
        API.instance.post("/article/favourite", delegate: self, params: params)
    }

    func articleFavourite(data: AnyObject) {
//        println("成功收藏")
    }
}