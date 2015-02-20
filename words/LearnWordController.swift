//
//  LearnWordController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//
import Foundation
import UIKit

class LearnWordController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,  APIDataDelegate, WordDetailDelegate {
    var optionSelectedRow: Int?
    var sentenceView: UIScrollView!
    var sentencesScrollView: UIScrollView!
    var scrollIndicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initView()
    }
    
    func initView() {
        var viewLearnWordSentenceHeight = CGFloat(160)

        var learnWordScrollView = UIScrollView()
        learnWordScrollView.frame = self.view.bounds
        learnWordScrollView.showsVerticalScrollIndicator = false
        learnWordScrollView.pagingEnabled = false
        learnWordScrollView.delegate = self
        learnWordScrollView.bounces = false

        learnWordScrollView.contentSize = CGSize(width: learnWordScrollView.frame.width, height: learnWordScrollView.frame.height + viewLearnWordSentenceHeight)
        
        self.view.addSubview(learnWordScrollView)


        var sentencesCount = CGFloat(3)
        // page up
        var viewLearnWordSentence = UIView(frame: CGRect(x: 0, y: 0, width: learnWordScrollView.frame.width, height: viewLearnWordSentenceHeight))
        viewLearnWordSentence.backgroundColor = Color.blockBackground
        self.sentencesScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewLearnWordSentence.frame.width, height: viewLearnWordSentence.frame.height))
        self.sentencesScrollView.delegate = self
        self.sentencesScrollView.pagingEnabled = true
        self.sentencesScrollView.bounces = false
        self.sentencesScrollView.showsHorizontalScrollIndicator = false
        
        self.sentenceView = UIScrollView(frame: CGRect(x: 0, y: 22, width: self.sentencesScrollView.frame.width, height: self.sentencesScrollView.frame.height - 22))
        var sentenceEnglishView = UILabel(frame: CGRect(x: 15, y: 5, width: self.sentenceView.frame.width - 30, height: 0))
        sentenceEnglishView.numberOfLines = 0
        sentenceEnglishView.text = "Jordan said Sunday it destroyed 56 targets in three days of strikes Jordan said "
        var paragraphStyleForEnglish = NSMutableParagraphStyle()
        paragraphStyleForEnglish.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForEnglish.alignment = NSTextAlignment.Justified
        paragraphStyleForEnglish.paragraphSpacing = 1
        paragraphStyleForEnglish.lineSpacing = 1
        var attributesForEnglish = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForEnglish,
            NSFontAttributeName: UIFont(name: "Times New Roman", size: CGFloat(16))!,
            NSForegroundColorAttributeName: Color.red,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        sentenceEnglishView.attributedText =  NSAttributedString(string: sentenceEnglishView.text!, attributes: attributesForEnglish)
        sentenceEnglishView.sizeToFit()
        sentenceEnglishView.frame = CGRect(x: 15, y: 5, width: self.sentenceView.frame.width - 30, height: sentenceEnglishView.frame.height)
        self.sentenceView.addSubview(sentenceEnglishView)
        
        var sentenceChineseView = UILabel(frame: CGRect(x: 15, y: 10 + sentenceEnglishView.frame.origin.y + sentenceEnglishView.frame.height, width: self.sentenceView.frame.width - 30, height: 0))
        sentenceChineseView.numberOfLines = 0
        sentenceChineseView.text = "国家主席习近平应约同美国总统奥巴马通电话。据新华社报道，两国领导人同意在新的一年使。"
        var paragraphStyleForChinese = NSMutableParagraphStyle()
        paragraphStyleForChinese.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForChinese.alignment = NSTextAlignment.Justified
        paragraphStyleForChinese.paragraphSpacing = 1
        paragraphStyleForChinese.lineSpacing = 3
        var attributesForChinese = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForChinese,
            NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(15))!,
            NSForegroundColorAttributeName: Color.lightGray,
            NSStrokeWidthAttributeName: NSNumber(float: -1.5)
            ])
        sentenceChineseView.attributedText =  NSAttributedString(string: sentenceChineseView.text!, attributes: attributesForChinese)
        sentenceChineseView.sizeToFit()
        sentenceChineseView.frame = CGRect(x: 15, y: 10 + sentenceEnglishView.frame.origin.y + sentenceEnglishView.frame.height, width: self.sentenceView.frame.width - 30, height: sentenceChineseView.frame.height)
        self.sentenceView.addSubview(sentenceChineseView)
        
        var sentenceFromView = UILabel(frame: CGRect(x: 15, y: 10 + sentenceChineseView.frame.origin.y + sentenceChineseView.frame.height, width: self.sentenceView.frame.width - 30, height: 0))
        sentenceFromView.numberOfLines = 0
        sentenceFromView.text = "来自：英语百科"
        var paragraphStyleForFrom = NSMutableParagraphStyle()
        paragraphStyleForFrom.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleForFrom.alignment = NSTextAlignment.Right
        var attributesForFrom = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForFrom,
            NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(12))!,
            NSForegroundColorAttributeName: Color.lightGray,
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        sentenceFromView.attributedText =  NSAttributedString(string: sentenceFromView.text!, attributes: attributesForFrom)
        sentenceFromView.sizeToFit()
        sentenceFromView.frame = CGRect(x: 15, y: 10 + sentenceChineseView.frame.origin.y + sentenceChineseView.frame.height, width: self.sentenceView.frame.width - 30, height: sentenceFromView.frame.height)
        self.sentenceView.addSubview(sentenceFromView)

        self.sentenceView.contentSize = CGSize(width: self.sentenceView.frame.width, height: 5 + sentenceEnglishView.frame.height + 10 + sentenceChineseView.frame.height + 10 + sentenceFromView.frame.height)
        self.sentencesScrollView.addSubview(self.sentenceView)
        
        self.sentencesScrollView.contentSize = CGSize(width: self.sentencesScrollView.frame.width * sentencesCount, height: sentencesScrollView.frame.height)
        
        self.scrollIndicator = UIView(frame: CGRect(x: 0, y: self.sentencesScrollView.frame.height - 2, width: self.sentencesScrollView.frame.width / sentencesCount, height: 2))
        self.scrollIndicator.backgroundColor = Color.red
        viewLearnWordSentence.addSubview(self.scrollIndicator)
        viewLearnWordSentence.addSubview(self.sentencesScrollView)
        learnWordScrollView.addSubview(viewLearnWordSentence)
        
        // page down
        var viewLearnWordPage = UIView()
        viewLearnWordPage.backgroundColor = Color.appBackground
        viewLearnWordPage.frame = CGRectMake(0, viewLearnWordSentenceHeight, learnWordScrollView.frame.width, learnWordScrollView.frame.height)
        
        var wordLabel = UILabel(frame: CGRect(x: 0, y: viewLearnWordPage.frame.height * 0.1, width: viewLearnWordPage.frame.width, height: 40))
        wordLabel.textAlignment = NSTextAlignment.Center
        wordLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(40))
        wordLabel.text = "what"
        wordLabel.textColor = Color.gray
        viewLearnWordPage.addSubview(wordLabel)
        
        var wordPhoneticButton = UIButton(frame: CGRect(x: 0, y: wordLabel.frame.origin.y + wordLabel.frame.height + 6, width: 24, height: 24))
        wordPhoneticButton.backgroundColor = Color.red
        wordPhoneticButton.layer.cornerRadius = 12
        wordPhoneticButton.setTitle("us", forState: UIControlState.Normal)
        
        var wordPhoneticSymbolLabel = UILabel(frame: CGRect(x: 0, y: wordLabel.frame.origin.y + wordLabel.frame.height + 3, width: 0, height: 0))
        wordPhoneticSymbolLabel.numberOfLines = 0
        wordPhoneticSymbolLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(22))
        wordPhoneticSymbolLabel.text = "[wa:t]"
        wordPhoneticSymbolLabel.textColor = Color.lightGray
        wordPhoneticSymbolLabel.sizeToFit()
        
        wordPhoneticButton.frame = CGRect(x: viewLearnWordPage.frame.width / 2 - (wordPhoneticButton.frame.width + wordPhoneticSymbolLabel.frame.width) / 2, y: wordPhoneticButton.frame.origin.y, width: wordPhoneticButton.frame.width, height: wordPhoneticButton.frame.height)
        viewLearnWordPage.addSubview(wordPhoneticButton)
        
        wordPhoneticSymbolLabel.frame = CGRect(x: wordPhoneticButton.frame.origin.x + wordPhoneticButton.frame.width, y: wordPhoneticSymbolLabel.frame.origin.y, width: wordPhoneticSymbolLabel.frame.width, height: wordPhoneticSymbolLabel.frame.height)
        viewLearnWordPage.addSubview(wordPhoneticSymbolLabel)
        
        var tableViewWrap = UIView(frame: CGRect(x: 15, y: viewLearnWordPage.frame.height * 0.3, width: self.view.frame.width - 30, height: 171))
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
        tableViewWrap.addSubview(tableView)
        
        viewLearnWordPage.addSubview(tableViewWrap)
        
        var knowButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width / 2 - 50, y: tableViewWrap.frame.origin.y + tableViewWrap.frame.height + 40, width: 100, height: 100))
        knowButton.backgroundColor = UIColor(patternImage: UIImage(named: "startLearn.png")!)
        knowButton.layer.cornerRadius = 50
        knowButton.layer.masksToBounds = true
        
        var knowButtonLabel = UILabel(frame: CGRect(x: 35, y: 2, width: 100, height: 80))
        knowButtonLabel.text = "认识"
        knowButtonLabel.font = UIFont(name: knowButtonLabel.font.fontName, size: CGFloat(15))
        knowButtonLabel.textColor = Color.red
        knowButtonLabel.layer.shadowColor = UIColor.redColor().CGColor
        knowButtonLabel.layer.shadowOpacity = 0.3
        knowButtonLabel.layer.shadowRadius = 2
        knowButtonLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        knowButton.addSubview(knowButtonLabel)
        viewLearnWordPage.addSubview(knowButton)
//        
//        var wordLabel = UILabel(frame: CGRect(x: 0, y: 60, width: viewLearnWordPage.frame.width, height: 40))
//        wordLabel.textAlignment = NSTextAlignment.Center
//        wordLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(40))
//        wordLabel.text = "what"
//        viewLearnWordPage.addSubview(wordLabel)
//        
//        var wordPhoneticSymbolLabel = UILabel(frame: CGRect(x: 0, y: 105, width: viewLearnWordPage.frame.width, height: 20))
//        wordPhoneticSymbolLabel.textAlignment = NSTextAlignment.Center
//        wordPhoneticSymbolLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(20))
//        wordPhoneticSymbolLabel.text = "英[wa:t]"
//        viewLearnWordPage.addSubview(wordPhoneticSymbolLabel)
//        
//        var optionsTableView = UITableView(frame: CGRect(x: 15, y: 130, width: viewLearnWordPage.frame.width - 30, height: viewLearnWordPage.frame.height - 280), style: UITableViewStyle.Plain)
//        optionsTableView.backgroundColor = UIColor.whiteColor()
//        optionsTableView.dataSource = self
//        optionsTableView.delegate = self
//        viewLearnWordPage.addSubview(optionsTableView)
//        
//        var knowButton = UIButton(frame: CGRect(x: 15, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
//        knowButton.backgroundColor = UIColor.purpleColor()
//        knowButton.layer.cornerRadius = 30
//        knowButton.layer.masksToBounds = true
//        knowButton.tintColor = UIColor.whiteColor()
//        knowButton.setTitle("认识", forState: UIControlState.Normal)
//        viewLearnWordPage.addSubview(knowButton)
//        
//        var unknowButton = UIButton(frame: CGRect(x: 80, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
//        unknowButton.backgroundColor = UIColor.purpleColor()
//        unknowButton.layer.cornerRadius = 30
//        unknowButton.layer.masksToBounds = true
//        unknowButton.tintColor = UIColor.whiteColor()
//        unknowButton.setTitle("不认识", forState: UIControlState.Normal)
//        viewLearnWordPage.addSubview(unknowButton)
//        
//        var nextButton = UIButton(frame: CGRect(x: 150, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
//        nextButton.backgroundColor = UIColor.purpleColor()
//        nextButton.layer.cornerRadius = 30
//        nextButton.layer.masksToBounds = true
//        nextButton.tintColor = UIColor.whiteColor()
//        nextButton.setTitle("下一个", forState: UIControlState.Normal)
//        viewLearnWordPage.addSubview(nextButton)
//        
//        var removeButton = UIButton(frame: CGRect(x: 220, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
//        removeButton.backgroundColor = UIColor.purpleColor()
//        removeButton.layer.cornerRadius = 30
//        removeButton.layer.masksToBounds = true
//        removeButton.tintColor = UIColor.whiteColor()
//        removeButton.setTitle("删除", forState: UIControlState.Normal)
//        viewLearnWordPage.addSubview(removeButton)
        
        learnWordScrollView.addSubview(viewLearnWordPage)

        learnWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView == self.sentencesScrollView) {
            var x = CGFloat(scrollView.contentOffset.x / scrollView.frame.width) * self.scrollIndicator.frame.width
            var offset = x - self.scrollIndicator.frame.origin.x
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.scrollIndicator.transform = CGAffineTransformMakeTranslation(x, 0)
                }) { (isDone: Bool) -> Void in
                    self.scrollIndicator.frame = CGRect(x: x, y: self.scrollIndicator.frame.origin.y, width: self.scrollIndicator.frame.width, height: self.scrollIndicator.frame.height)
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var selectedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        selectedView.tag = 999
        selectedView.backgroundColor = UIColor.clearColor()
        cell.addSubview(selectedView)
        
        var optionLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        optionLabel.backgroundColor = Color.listIconBackground
        switch (indexPath.row) {
        case 0:
            optionLabel.text = "A"
        case 1:
            optionLabel.text = "B"
        case 2:
            optionLabel.text = "C"
        case 3:
            optionLabel.text = "D"
        default:
            break
        }
        optionLabel.textColor = Color.white
        optionLabel.textAlignment = NSTextAlignment.Center
        optionLabel.font = UIFont(name: optionLabel.font.fontName, size: CGFloat(15))
        optionLabel.layer.cornerRadius = 15
        optionLabel.layer.masksToBounds = true
        cell.addSubview(optionLabel)
        
        var answerLabel = UILabel(frame: CGRect(x: 50, y: 1, width: (tableView.frame.width - 50), height: 39))
        switch (indexPath.row) {
        case 0:
            answerLabel.text = "什么，中国人，什么，中国人，什么，中国人"
        case 1:
            answerLabel.text = "昨天"
        case 2:
            answerLabel.text = "一会儿"
        case 3:
            answerLabel.text = "在哪里"
        default:
            break
        }
        answerLabel.textColor = Color.gray
        answerLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(18))
        answerLabel.textAlignment = NSTextAlignment.Left
        cell.addSubview(answerLabel)
        
        if (indexPath.row == self.optionSelectedRow) {
            selectedView.backgroundColor = Color.green // if right use Color.green, if wrong use Color.red
            answerLabel.textColor = Color.white
        } else {
            selectedView.backgroundColor = UIColor.clearColor()
            answerLabel.textColor = Color.gray
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.optionSelectedRow = indexPath.row
        tableView.reloadData()
    }
    
    func frameOfView() -> CGRect {
        return CGRect(x: 0, y: 32, width: self.view.frame.width, height: self.view.frame.height - 32)
    }
    
    func searchWord() -> String {
        return ""
    }
    
    func shoudRegisterNotification() -> Bool {
        return true
    }
}