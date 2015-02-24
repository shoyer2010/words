//
//  LearnWordController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//
import Foundation
import UIKit
import SQLite
import AVFoundation

class LearnWordController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,  APIDataDelegate, WordDetailDelegate {
    var optionSelectedRow: Int?
    var learnWordScrollView: UIScrollView!
    var sentencesScrollView: UIScrollView!
    var scrollIndicator: UIView!
    var word: AnyObject?
    var sentences: NSMutableArray! = NSMutableArray()
    var chineseString: String?
    var randomChineseArray: NSMutableArray! = NSMutableArray()
    var player: AVAudioPlayer!
    var currentSentenceIndex: Int! = 0
    
    var viewLearnWordPage: UIView!
    
    var wordLabel: UILabel!
    var wordPhoneticButton: UIButton!
    var wordPhoneticSymbolLabel: UILabel!
    var knowButton: UIButton!
    var tableViewWrap: UIView!
    var tableView: UITableView!
    
    var viewLearnWordSentenceHeight = CGFloat(150)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: EventKey.ON_PAGE_CHAGNE, object: nil)
        self.initView()
        self.setToView()
    }
    
    func initView() {
        learnWordScrollView = UIScrollView()
        learnWordScrollView.frame = self.view.bounds
        learnWordScrollView.showsVerticalScrollIndicator = false
        learnWordScrollView.pagingEnabled = false
        learnWordScrollView.delegate = self
        learnWordScrollView.bounces = false

        learnWordScrollView.contentSize = CGSize(width: learnWordScrollView.frame.width, height: learnWordScrollView.frame.height + viewLearnWordSentenceHeight)
        
        self.view.addSubview(learnWordScrollView)


        
        // page up
        var viewLearnWordSentence = UIView(frame: CGRect(x: 0, y: 0, width: learnWordScrollView.frame.width, height: viewLearnWordSentenceHeight))
        viewLearnWordSentence.backgroundColor = Color.blockBackground
        self.sentencesScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewLearnWordSentence.frame.width, height: viewLearnWordSentence.frame.height))
        self.sentencesScrollView.delegate = self
        self.sentencesScrollView.pagingEnabled = true
        self.sentencesScrollView.bounces = false
        self.sentencesScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onSentencesScrollViewTapped:"))
        self.sentencesScrollView.showsHorizontalScrollIndicator = false
        
        self.scrollIndicator = UIView()
        self.scrollIndicator.backgroundColor = Color.red
        viewLearnWordSentence.addSubview(self.scrollIndicator)
        viewLearnWordSentence.addSubview(self.sentencesScrollView)
        learnWordScrollView.addSubview(viewLearnWordSentence)
        
        // page down
        viewLearnWordPage = UIView()
        viewLearnWordPage.backgroundColor = Color.appBackground
        viewLearnWordPage.frame = CGRectMake(0, viewLearnWordSentenceHeight, learnWordScrollView.frame.width, learnWordScrollView.frame.height)
        
        wordLabel = UILabel(frame: CGRect(x: 0, y: viewLearnWordPage.frame.height * 0.1, width: viewLearnWordPage.frame.width, height: 45))
        wordLabel.textAlignment = NSTextAlignment.Center
        wordLabel.userInteractionEnabled = true
        wordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onWordLabelTapped:"))
        viewLearnWordPage.addSubview(wordLabel)
        
        wordPhoneticButton = UIButton(frame: CGRect(x: 0, y: wordLabel.frame.origin.y + wordLabel.frame.height + 10, width: 24, height: 24))
        wordPhoneticButton.hidden = true
        wordPhoneticButton.backgroundColor = Color.red
        wordPhoneticButton.layer.cornerRadius = 12
        wordPhoneticButton.addTarget(self, action: "onWordPhoneticButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        wordPhoneticSymbolLabel = UILabel(frame: CGRect(x: 0, y: wordLabel.frame.origin.y + wordLabel.frame.height + 7, width: 100, height: 24))
        wordPhoneticSymbolLabel.numberOfLines = 1
        wordPhoneticSymbolLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(22))
        wordPhoneticSymbolLabel.text = ""
        wordPhoneticSymbolLabel.textColor = Color.lightGray
        wordPhoneticSymbolLabel.userInteractionEnabled = true
        wordPhoneticSymbolLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onWordPhoneticSymbolLabelTapped:"))
        wordPhoneticSymbolLabel.sizeToFit()
        viewLearnWordPage.addSubview(wordPhoneticButton)
        viewLearnWordPage.addSubview(wordPhoneticSymbolLabel)
        
        tableViewWrap = UIView(frame: CGRect(x: 15, y: viewLearnWordPage.frame.height * 0.3, width: self.view.frame.width - 30, height: 171))
        tableViewWrap.backgroundColor = Color.blockBackground
        tableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        tableViewWrap.layer.shadowOffset = Layer.shadowOffset
        tableViewWrap.layer.shadowColor = Layer.shadowColor
        tableViewWrap.layer.shadowRadius = Layer.shadowRadius
        tableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        tableView = UITableView(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 12))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = Layer.cornerRadius
        tableView.layer.masksToBounds = true
        tableView.scrollEnabled = false
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableViewWrap.addSubview(tableView)
        
        viewLearnWordPage.addSubview(tableViewWrap)
        
        knowButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width / 2 - 50, y: tableViewWrap.frame.origin.y + tableViewWrap.frame.height + 40, width: 100, height: 100))
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
        knowButton.addTarget(self, action: "onKnowButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
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
            self.currentSentenceIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            self.playSentence()
            var x = CGFloat(scrollView.contentOffset.x / scrollView.frame.width) * self.scrollIndicator.frame.width
            var offset = x - self.scrollIndicator.frame.origin.x
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.scrollIndicator.transform = CGAffineTransformMakeTranslation(x, 0)
                }) { (isDone: Bool) -> Void in
                    self.scrollIndicator.frame = CGRect(x: x, y: self.scrollIndicator.frame.origin.y, width: self.scrollIndicator.frame.width, height: self.scrollIndicator.frame.height)
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView == self.learnWordScrollView && scrollView.contentOffset.y < 100) {
            self.loadSentences()
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
        
        if (self.randomChineseArray.count >= 3) {
            switch (indexPath.row) {
            case 0:
                answerLabel.text = self.chineseString
            case 1:
                answerLabel.text = self.randomChineseArray?[0] as? String
            case 2:
                answerLabel.text = self.randomChineseArray?[1] as? String
            case 3:
                answerLabel.text = self.randomChineseArray?[2] as? String
            default:
                break
            }
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
        if (self.word != nil) {
            return self.word!["word"] as String
        }
        
        return ""
    }
    
    func loadSentences() {
        if (self.sentences.count == 0) {
            var params = NSMutableDictionary()
            params.setValue(self.word!["id"] as String, forKey: "id")
            API.instance.get("/sentence/getByWordId", delegate: self, params: params)
        }
    }
    
    func sentenceGetByWordId(data: AnyObject) {
        self.sentences.setArray(data as NSArray)
        self.setToSentencesView()
        
        // TODO: check if auto play the sentence
        self.playSentence()
    }
    
    func clearSentencesView() {
        for view in (self.sentencesScrollView.subviews as NSArray) {
            view.removeFromSuperview()
        }
    }
    
    func setToSentencesView() {
        var sentencesCount = CGFloat(self.sentences.count)
        self.sentencesScrollView.contentSize = CGSize(width: self.sentencesScrollView.frame.width * sentencesCount, height: sentencesScrollView.frame.height)
        self.scrollIndicator.frame = CGRect(x: 0, y: self.sentencesScrollView.frame.height - 2, width: self.sentencesScrollView.frame.width / sentencesCount, height: 2)

        for(var i = 0; i < self.sentences.count; i++) {
            var sentence: AnyObject = self.sentences[i]
            var sentenceView = UIScrollView(frame: CGRect(x: CGFloat(i) * self.sentencesScrollView.frame.width, y: 22, width: self.sentencesScrollView.frame.width, height: self.sentencesScrollView.frame.height - 22))
            var sentenceEnglishView = UILabel(frame: CGRect(x: 15, y: 5, width: sentenceView.frame.width - 30, height: 0))
            sentenceEnglishView.numberOfLines = 0
            sentenceEnglishView.text = sentence["english"] as? String
            var paragraphStyleForEnglish = NSMutableParagraphStyle()
            paragraphStyleForEnglish.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyleForEnglish.alignment = NSTextAlignment.Justified
            paragraphStyleForEnglish.paragraphSpacing = 2
            paragraphStyleForEnglish.lineSpacing = 2
            var attributesForEnglish = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyleForEnglish,
                NSFontAttributeName: UIFont(name: "Times New Roman", size: CGFloat(17))!,
                NSForegroundColorAttributeName: Color.red,
                NSStrokeWidthAttributeName: NSNumber(float: -1.5)
                ])
            sentenceEnglishView.attributedText =  NSAttributedString(string: sentenceEnglishView.text!, attributes: attributesForEnglish)
            sentenceEnglishView.sizeToFit()
            sentenceEnglishView.frame = CGRect(x: 15, y: 5, width: sentenceView.frame.width - 30, height: sentenceEnglishView.frame.height)
            sentenceView.addSubview(sentenceEnglishView)
            
            var sentenceChineseView = UILabel(frame: CGRect(x: 15, y: 10 + sentenceEnglishView.frame.origin.y + sentenceEnglishView.frame.height, width: sentenceView.frame.width - 30, height: 0))
            sentenceChineseView.numberOfLines = 0
            sentenceChineseView.text = ""
            if (sentence["chinese"] as? String != nil) {
                sentenceChineseView.text = sentence["chinese"] as? String
            }
            
            var paragraphStyleForChinese = NSMutableParagraphStyle()
            paragraphStyleForChinese.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyleForChinese.alignment = NSTextAlignment.Left
            paragraphStyleForChinese.paragraphSpacing = 2
            paragraphStyleForChinese.lineSpacing = 2
            var attributesForChinese = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyleForChinese,
                NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(14))!,
                NSForegroundColorAttributeName: Color.lightGray,
                NSStrokeWidthAttributeName: NSNumber(float: -1.5)
                ])
            sentenceChineseView.attributedText =  NSAttributedString(string: sentenceChineseView.text!, attributes: attributesForChinese)
            sentenceChineseView.sizeToFit()
            sentenceChineseView.frame = CGRect(x: 15, y: 10 + sentenceEnglishView.frame.origin.y + sentenceEnglishView.frame.height, width: sentenceView.frame.width - 30, height: sentenceChineseView.frame.height)
            sentenceView.addSubview(sentenceChineseView)
            
            var sentenceFromView = UILabel(frame: CGRect(x: 15, y: 5 + sentenceChineseView.frame.origin.y + sentenceChineseView.frame.height, width: sentenceView.frame.width - 30, height: 0))
            sentenceFromView.numberOfLines = 0
            sentenceFromView.text = ""
            if (sentence["from"] as? String != nil) {
                sentenceFromView.text = "来自: " + (sentence["from"] as String)
            }
            
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
            sentenceFromView.frame = CGRect(x: 15, y: 5 + sentenceChineseView.frame.origin.y + sentenceChineseView.frame.height, width: sentenceView.frame.width - 30, height: sentenceFromView.frame.height)
            sentenceView.addSubview(sentenceFromView)
            
            sentenceView.contentSize = CGSize(width: sentenceView.frame.width, height: 25 + sentenceEnglishView.frame.height + sentenceChineseView.frame.height + sentenceFromView.frame.height)
            self.sentencesScrollView.addSubview(sentenceView)
        }
    }
    
    func wordPhoneticType() -> String {
        var type = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.WORD_PHONETIC_TYPE) as? String
        if (type == nil) {
            type = "us"
        }
        
        return type!
    }
    
    func onSentencesScrollViewTapped(recognizer: UITapGestureRecognizer) {
        if (self.player.playing) {
            self.player.stop()
        } else {
            self.playSentence()
        }
    }
    
    func onWordPhoneticButton(sender: UIButton) {
        var type = wordPhoneticButton.titleLabel!.text
        if (type == "us") {
            type = "uk"
        } else {
            type = "us"
        }
        
        println(type)
        NSUserDefaults.standardUserDefaults().setObject(type, forKey: CacheKey.WORD_PHONETIC_TYPE)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.setToView()
    }
    
    func onKnowButtonTapped(sender: UIButton) {
        self.setNextWord()
        self.setToView()
    }
    
    func onWordLabelTapped(recognizer: UITapGestureRecognizer) {
        var applicationContoller = self.parentViewController as ApplicationController
        applicationContoller.scrollToPage(page: 4)
    }
    
    func onWordPhoneticSymbolLabelTapped(recognizer: UITapGestureRecognizer) {
        var tapPoint:CGPoint = recognizer.locationInView(self.wordPhoneticSymbolLabel)
        TapPointView(view: self.wordPhoneticSymbolLabel, tapPoint: tapPoint)
        self.playVoice()
    }
    
    func shoudRegisterNotification() -> Bool {
        return true
    }
    
    func setNextWord() {
        var customDictionary = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_CUSTOM_DICTIONARY) as? String
        var learningDictionary = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_DICTIONARY) as? String
        
        if (customDictionary != nil) {
            var db = Database(Util.getFilePath((customDictionary! as String) + ".db"))
            for row in db.prepare("SELECT id, word, phoneticSymbolUS, usPronunciation, phoneticSymbolUK, ukPronunciation, chinese FROM words order by random() limit 1") {
                var id: String = ""
                if (row[0] != nil) {
                    id = row[0] as String
                }
                
                var wordString: String = ""
                if (row[1] != nil) {
                    wordString = row[1] as String
                }
                
                var phoneticSymbolUS: String = ""
                if (row[2] != nil) {
                    phoneticSymbolUS = row[2] as String
                }
                
                var usPronunciation: String = ""
                if (row[3] != nil) {
                    usPronunciation = row[3] as String
                }
                
                var phoneticSymbolUK: String = ""
                if (row[4] != nil) {
                    phoneticSymbolUK = row[4] as String
                }
                
                var ukPronunciation: String = ""
                if (row[5] != nil) {
                    ukPronunciation = row[5] as String
                }
                
                var chinese: NSDictionary! = NSDictionary()
                if (row[6] != nil) {
                    var chineseData = (row[6] as String).dataUsingEncoding(NSUTF8StringEncoding)
                    if (chineseData != nil) {
                        chinese = NSJSONSerialization.JSONObjectWithData(chineseData!, options: NSJSONReadingOptions.allZeros, error: nil) as NSDictionary
                    }
                }
                
                self.word = ["id": id, "word": wordString, "phoneticSymbolUS": phoneticSymbolUS, "usPronunciation": usPronunciation, "phoneticSymbolUK": phoneticSymbolUK, "ukPronunciation": ukPronunciation, "chinese": chinese]
            }
            
            self.randomChineseArray = NSMutableArray()
            for row in db.prepare("SELECT chinese FROM words WHERE chinese IS NOT NULL order by random() limit 3") {
                var chineseData = (row[0] as String).dataUsingEncoding(NSUTF8StringEncoding)
                var chinese: NSDictionary! = NSDictionary()
                if (chineseData != nil) {
                    chinese = NSJSONSerialization.JSONObjectWithData(chineseData!, options: NSJSONReadingOptions.allZeros, error: nil) as NSDictionary
                }
                
                var string = ""
                for (key, value) in chinese {
                    string += "\(value)，"
                }
                
                var tempString = string as NSString
                self.randomChineseArray.addObject(tempString.substringToIndex(tempString.length - 1))
            }
            
            
        }
        
//        if (learningDictionary != nil) {
//            var db = Database(Util.getFilePath((learningDictionary! as String) + ".db"))
//            for row in db.prepare("SELECT id, word, phoneticSymbolUS, usPronunciation, phoneticSymbolUK, ukPronunciation, chinese FROM words order by random() limit 1") {
//                var id: String = ""
//                if (row[0] != nil) {
//                    id = row[0] as String
//                }
//                
//                var wordString: String = ""
//                if (row[1] != nil) {
//                    wordString = row[1] as String
//                }
//                
//                var phoneticSymbolUS: String = ""
//                if (row[2] != nil) {
//                    phoneticSymbolUS = row[2] as String
//                }
//                
//                var usPronunciation: String = ""
//                if (row[3] != nil) {
//                    usPronunciation = row[3] as String
//                }
//                
//                var phoneticSymbolUK: String = ""
//                if (row[4] != nil) {
//                    phoneticSymbolUK = row[4] as String
//                }
//                
//                var ukPronunciation: String = ""
//                if (row[5] != nil) {
//                    ukPronunciation = row[5] as String
//                }
//                
//                var chineseData = (row[6] as String).dataUsingEncoding(NSUTF8StringEncoding)
//                var chinese: NSDictionary! = NSDictionary()
//                if (chineseData != nil) {
//                    chinese = NSJSONSerialization.JSONObjectWithData(chineseData!, options: NSJSONReadingOptions.allZeros, error: nil) as NSDictionary
//                }
//                
//                self.word = ["id": id, "word": wordString, "phoneticSymbolUS": phoneticSymbolUS, "usPronunciation": usPronunciation, "phoneticSymbolUK": phoneticSymbolUK, "ukPronunciation": ukPronunciation, "chinese": chinese]
//            }
//            
//            self.randomChineseArray = NSMutableArray()
//            for row in db.prepare("SELECT chinese FROM words WHERE chinese IS NOT NULL order by random() limit 3") {
//                var chineseData = (row[0] as String).dataUsingEncoding(NSUTF8StringEncoding)
//                var chinese: NSDictionary! = NSDictionary()
//                if (chineseData != nil) {
//                    chinese = NSJSONSerialization.JSONObjectWithData(chineseData!, options: NSJSONReadingOptions.allZeros, error: nil) as NSDictionary
//                }
//                
//                var string = ""
//                for (key, value) in chinese {
//                    string += "\(value)，"
//                }
//                
//                var tempString = string as NSString
//                self.randomChineseArray.addObject(tempString.substringToIndex(tempString.length - 1))
//            }
//        }
        
        if (customDictionary == nil && learningDictionary == nil) {
            self.word = nil
        }
        
        self.optionSelectedRow = nil
        self.currentSentenceIndex = 0
        self.sentencesScrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollIndicator.frame = CGRect(x: 0, y: self.scrollIndicator.frame.origin.y, width: self.scrollIndicator.frame.width, height: 2)
        self.setChineseString()
        self.sentences = NSMutableArray()
        self.clearSentencesView()
        self.setToView()
    }
    
    func setChineseString() {
        self.chineseString = ""
        if (self.word != nil) {
            for (key, value) in (self.word!["chinese"] as NSDictionary) {
                self.chineseString! += "\(value)，"
            }
            
            var tempString = self.chineseString! as NSString
            self.chineseString = tempString.substringToIndex(tempString.length - 1)
        }
    }
    
    func onPageChange(notification: NSNotification) {
        self.learnWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.LearnWord && PageCode(rawValue: notification.userInfo?["previousPage"] as Int) == PageCode.Home) {
            self.setNextWord()
        }
    }
    
    func setToView() {
        if (self.word == nil) {
            wordLabel.text = "请选择您想学习的词库"
            wordLabel.font = UIFont.systemFontOfSize(20)
            return
        }
        
        wordLabel.text = self.word!["word"] as? String
        wordLabel.textColor = Color.gray
        wordLabel.font = UIFont.systemFontOfSize(40)
        
        var type = self.wordPhoneticType()
        wordPhoneticButton.setTitle(type, forState: UIControlState.Normal)
        wordPhoneticButton.hidden = false
        if (type == "us") {
            wordPhoneticSymbolLabel.text = self.word!["phoneticSymbolUS"]? as? String
        }
        if (type == "uk") {
            wordPhoneticSymbolLabel.text = self.word!["phoneticSymbolUK"]? as? String
        }
        wordPhoneticSymbolLabel.sizeToFit()
        wordPhoneticButton.frame = CGRect(x: viewLearnWordPage.frame.width / 2 - (wordPhoneticButton.frame.width + wordPhoneticSymbolLabel.frame.width) / 2, y: wordPhoneticButton.frame.origin.y, width: wordPhoneticButton.frame.width, height: wordPhoneticButton.frame.height)
        wordPhoneticSymbolLabel.frame = CGRect(x: wordPhoneticButton.frame.origin.x + wordPhoneticButton.frame.width, y: wordPhoneticSymbolLabel.frame.origin.y, width: wordPhoneticSymbolLabel.frame.width, height: wordPhoneticSymbolLabel.frame.height)
        
        self.playVoice()
        
        self.tableView.reloadData()
    }
    
    func playVoice() {
        if (self.word == nil) {
            return
        }
        
        var type = self.wordPhoneticType()
        if (type == "us" && (self.word!["usPronunciation"]? as? String) != nil) {
            player = AVAudioPlayer(data: NSData(contentsOfURL: Util.getVoiceURL(self.word!["usPronunciation"] as String)), error: nil)
        }
        
        if (type == "uk" && self.word!["ukPronunciation"]? as? String != nil) {
            player = AVAudioPlayer(data: NSData(contentsOfURL: Util.getVoiceURL(self.word!["ukPronunciation"] as String)), error: nil)
        }
        
        player.play()
    }
    
    func playSentence() {
        if (self.sentences.count > 0) {
            var url = self.sentences![self.currentSentenceIndex]["voice"] as? String
            if (url != nil) {
                player = AVAudioPlayer(data: NSData(contentsOfURL: Util.getVoiceURL(url!)), error: nil)
                player.play()
            }
        }
    }
}