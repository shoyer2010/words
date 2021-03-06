//
//  FavouriteArticleController.swift
//  words
//
//  Created by shoyer on 15/2/3.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class FavouriteArticleController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIDataDelegate, ArticleForEnglishDelegate {
    var contentView: UIView!
    var selectedRow: Int?
    var previousX = CGFloat(0)
    var data: NSMutableArray!
    var indicator: UIActivityIndicatorView!
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onFavouriteChange:", name: EventKey.ON_FAVOURITE_CHANGE, object: nil)
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60))
        indicator.color = Color.red
        self.view.addSubview(indicator)
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        var tapView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 55))
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        self.view.addSubview(tapView)
        
        self.contentView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height - 55))
        self.contentView.backgroundColor = Color.white.colorWithAlphaComponent(0.9)
        self.contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onPanTableView:"))
        self.view.addSubview(self.contentView)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.contentView.transform = CGAffineTransformMakeTranslation(0, 55 - self.view.frame.height)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
                self.loadData()
        }
    }

    func loadData() {
        var params = NSMutableDictionary()
        API.instance.get("/article/favouriteList", delegate: self, params: params)
        self.startLoading()
    }
    
    func startLoading() {
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func endLoading() {
        self.indicator.stopAnimating()
    }
    
    func articleFavouriteList(data: AnyObject) {
        self.data = data as NSMutableArray

        var tableViewWrap = UIView(frame: CGRect(x: 15, y: 15, width: self.contentView.frame.width - 30, height: self.contentView.frame.height - 30))
        tableViewWrap.backgroundColor = Color.blockBackground
        tableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        tableViewWrap.layer.shadowOffset = Layer.shadowOffset
        tableViewWrap.layer.shadowColor = Layer.shadowColor
        tableViewWrap.layer.shadowRadius = Layer.shadowRadius
        tableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        tableView = UITableView(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 12))
        tableView.backgroundColor = Color.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0,  bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsetsZero

        if (tableView.respondsToSelector("setLayoutMargins:")) {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        
        tableViewWrap.addSubview(tableView)
        self.contentView.addSubview(tableViewWrap)
        self.endLoading()
        
        if (self.data.count == 0) {
            var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
            self.view.addSubview(view)
            ErrorView(view: view, message: "您还没有收藏过文章",completion: {() in
                view.removeFromSuperview()
            })
        }
    }
    
    func onPanTableView(recognizer: UIPanGestureRecognizer) {
        if (self.selectedRow == nil) {
            return
        }
        
        if (recognizer.state == UIGestureRecognizerState.Began) {
            self.previousX = 0
        }
        
        var point = recognizer.translationInView(self.contentView)
        var homeController = self.parentViewController as HomeController
        var applicationController = homeController.parentViewController as ApplicationController
        var offset = applicationController.scrollView.contentOffset
        
        if (point.x < 0) {
            if (offset.x % self.view.frame.width != 0) {
                if ((offset.x % self.view.frame.width) < self.view.frame.width / 2) {
                    applicationController.scrollToPage(page: 1)
                } else {
                    applicationController.scrollToPage(page: 2)
                }
            }
            
            return
        }
        
        var dx = point.x - self.previousX
        var newOffset = CGPoint(x: offset.x - dx, y: offset.y)
        if (newOffset.x > self.view.frame.width * 2) {
            if ((newOffset.x % self.view.frame.width) < self.view.frame.width / 2) {
                applicationController.scrollToPage(page: 1)
            } else {
                applicationController.scrollToPage(page: 2)
            }
            
            return
        }
        
        applicationController.scrollView.setContentOffset(newOffset, animated: false)
        self.previousX = point.x
        
        if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled) {
            if ((newOffset.x % self.view.frame.width) < self.view.frame.width / 2) {
                applicationController.scrollToPage(page: 1)
            } else {
                applicationController.scrollToPage(page: 2)
            }
        }
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        if (offset < Interaction.offsetForChangePage) {
            scrollView.userInteractionEnabled = false
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.contentView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height - 55)
                self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
                }) { (isDone: Bool) -> Void in
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(700 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            })
        }
    }
    
    func closeView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.contentView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height - 55)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        var englishLabelTag = 1000
        var chineseLabelTag = 1001

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell!.separatorInset = UIEdgeInsetsZero
            
            if (cell!.respondsToSelector("setLayoutMargins:")) {
                cell!.layoutMargins = UIEdgeInsetsZero
            }
            
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            var selectedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            selectedView.tag = 999
            cell!.addSubview(selectedView)
            
            var recommendView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))

            var englishLabel = UILabel(frame: CGRect(x: 10, y: 3, width: recommendView.frame.width - 20, height: recommendView.frame.height / 2))
            englishLabel.tag = englishLabelTag
            englishLabel.text = ""
            englishLabel.numberOfLines = 1
            englishLabel.font = UIFont(name: "Cochin", size: CGFloat(16))
            recommendView.addSubview(englishLabel)

            var chineseLabel = UILabel(frame: CGRect(x: 10, y: recommendView.frame.height / 2 + 2, width: recommendView.frame.width - 20, height: recommendView.frame.height / 2))
            chineseLabel.tag = chineseLabelTag
            chineseLabel.text = ""
            chineseLabel.numberOfLines = 1
            chineseLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
            recommendView.addSubview(chineseLabel)
            cell!.addSubview(recommendView)
        }
        
        
        var englishColor = Color.red
        var chineseColor = Color.lightGray
        
        var selectedView = cell!.viewWithTag(999)
        if (self.selectedRow == indexPath.row) {
            selectedView?.backgroundColor = Color.red
            englishColor = Color.white
            chineseColor = Color.white
        } else {
            selectedView?.backgroundColor = UIColor.clearColor()
            englishColor = Color.red
            chineseColor = Color.lightGray
        }
        
        var englishLabel = cell!.viewWithTag(englishLabelTag) as UILabel
        englishLabel.text = self.data[indexPath.row]["titleEnglish"] as? String
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.lineSpacing = 5
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: englishLabel.font,
            NSForegroundColorAttributeName: englishColor,
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        englishLabel.attributedText = NSAttributedString(string: englishLabel.text!, attributes: attributes)
        
        var chineseLabel = cell!.viewWithTag(chineseLabelTag) as UILabel
        chineseLabel.text = self.data[indexPath.row]["titleChinese"] as? String
        var paragraphStyleForChinese = NSMutableParagraphStyle()
        paragraphStyleForChinese.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyleForChinese.lineSpacing = 7
        var attributesForChinese = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForChinese,
            NSFontAttributeName: chineseLabel.font,
            NSForegroundColorAttributeName: chineseColor,
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        chineseLabel.attributedText = NSAttributedString(string: chineseLabel.text!, attributes: attributesForChinese)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        tableView.reloadData()
        var homeController = self.parentViewController as HomeController
        var applicationController = homeController.parentViewController as ApplicationController
        applicationController.articleForEnglishController.delegate = self
        applicationController.scrollToPage(page: 1)
    }
    
    func setArticleId() -> String? {
        if (self.selectedRow != nil) {
            return self.data[self.selectedRow!]["id"] as? String
        } else {
            return nil
        }
    }
    
    func onFavouriteChange(notification: NSNotification) {
        self.selectedRow = nil
        var articleId = notification.userInfo!["id"] as String
        for item in self.data {
            if (item["id"] as String) == articleId {
                self.data.removeObject(item)
                self.tableView.reloadData()
                break
            }
        }
    }
    
    func error(error: Error, api: String) {
        var view = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 25))
        self.view.addSubview(view)
        ErrorView(view: view, message: error.getMessage(),completion: {() in
            view.removeFromSuperview()
        })
    }
}