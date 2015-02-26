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
    var nextButton: UIButton!
    var removeButton: UIButton!
    
    var wordView: UIView!
    var tableViewWrap: UIView!
    var tableView: UITableView!
    var chineseView: UILabel!
    var blurView: FXBlurView!
    var blurViewForWord: FXBlurView!
    var timer: NSTimer!
    
    
    // 0 no word to show. 
    // 1 no button, and four options to choose.
    // 2 word and right chinese , next button
    // 3 word and blured right chinese with a timecount progress, known button.
    // 4 blured word with a timecount progress, and right chinese, known button.
    var pageMode: Int! = 0
    
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
        
        removeButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width - 45, y: 32, width: 30, height: 30))
        removeButton.backgroundColor = UIColor.purpleColor()
        removeButton.layer.cornerRadius = 15
        removeButton.layer.masksToBounds = true
        removeButton.tintColor = UIColor.whiteColor()
        removeButton.setTitle("删", forState: UIControlState.Normal)
        viewLearnWordPage.addSubview(removeButton)
        
        wordView = UIView(frame: CGRect(x: 0, y: viewLearnWordPage.frame.height * 0.17, width: viewLearnWordPage.frame.width, height: 90))
        wordView.backgroundColor = Color.appBackground
        wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: wordView.frame.width, height: 45))
        wordLabel.textAlignment = NSTextAlignment.Center
        wordLabel.userInteractionEnabled = true
        wordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onWordLabelTapped:"))
        wordView.addSubview(wordLabel)
        
        
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
        wordView.addSubview(wordPhoneticButton)
        wordView.addSubview(wordPhoneticSymbolLabel)
        viewLearnWordPage.addSubview(wordView)
        
        blurViewForWord = FXBlurView(frame: CGRect(x: 0, y: 0, width: wordView.frame.width, height: wordView.frame.height))
        blurViewForWord.dynamic = false
        blurViewForWord.tintColor = UIColor.clearColor()
        blurViewForWord.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onBlurViewForWordTapped:"))
        
        var progressViewForWord = UAProgressView()
        progressViewForWord.tag = 10009
        progressViewForWord.frame = CGRect(x: blurViewForWord.frame.width / 2 - 20, y: blurViewForWord.frame.height / 2 - 20, width: 40, height: 40)
        progressViewForWord.lineWidth = 3
        progressViewForWord.tintColor = Color.red
        progressViewForWord.animationDuration = 1
        progressViewForWord.didSelectBlock = {(progressView: UAProgressView!) -> Void in
            self.hideBlurViewForWord()
        }
        blurViewForWord.addSubview(progressViewForWord)
        self.showBlurViewForWord()
        self.hideBlurViewForWord()
        wordView.addSubview(blurViewForWord)
        
        tableViewWrap = UIView(frame: CGRect(x: 15, y: wordView.frame.origin.y + wordView.frame.height + 15, width: self.view.frame.width - 30, height: 171))
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
        
        chineseView = UILabel(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 12))
        chineseView.text = ""
        chineseView.numberOfLines = 0
        chineseView.backgroundColor = Color.white
        tableViewWrap.addSubview(chineseView)
        tableViewWrap.addSubview(tableView)
        
        viewLearnWordPage.addSubview(tableViewWrap)
        
        blurView = FXBlurView(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 12))
        blurView.dynamic = false
        blurView.tintColor = UIColor.clearColor()
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onBlurViewTapped:"))
        
        var progressView = UAProgressView()
        progressView.tag = 10009
        progressView.frame = CGRect(x: blurView.frame.width / 2 - 20, y: blurView.frame.height / 2 - 20, width: 40, height: 40)
        progressView.lineWidth = 3
        progressView.tintColor = Color.red
        progressView.animationDuration = 1
        progressView.didSelectBlock = {(progressView: UAProgressView!) -> Void in
            self.hideBlurView()
        }
        blurView.addSubview(progressView)
        self.showBlurView()
        self.hideBlurView()
        tableViewWrap.addSubview(blurView)
        
        
        knowButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width / 2 - 50, y: tableViewWrap.frame.origin.y + tableViewWrap.frame.height + 20, width: 100, height: 100))
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
        knowButton.hidden = true
        viewLearnWordPage.addSubview(knowButton)
        
        nextButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width / 2 - 50, y: tableViewWrap.frame.origin.y + tableViewWrap.frame.height + 20, width: 100, height: 100))
        nextButton.backgroundColor = UIColor(patternImage: UIImage(named: "startLearn.png")!)
        nextButton.layer.cornerRadius = 50
        nextButton.layer.masksToBounds = true
        var nextButtonLabel = UILabel(frame: CGRect(x: 29, y: 2, width: 100, height: 80))
        nextButtonLabel.text = "下一个"
        nextButtonLabel.font = UIFont(name: nextButtonLabel.font.fontName, size: CGFloat(15))
        nextButtonLabel.textColor = Color.red
        nextButtonLabel.layer.shadowColor = UIColor.redColor().CGColor
        nextButtonLabel.layer.shadowOpacity = 0.3
        nextButtonLabel.layer.shadowRadius = 2
        nextButtonLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        nextButton.addSubview(nextButtonLabel)
        nextButton.addTarget(self, action: "onNextButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.hidden = true
        viewLearnWordPage.addSubview(nextButton)
        
        learnWordScrollView.addSubview(viewLearnWordPage)

        learnWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView == self.sentencesScrollView) {
            self.currentSentenceIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if (self.player != nil) {
                self.player.stop()
            }
            
            var shouldAutoVoice = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.SENTENCE_AUTO_VOICE) as Bool
            if (shouldAutoVoice) {
                self.playSentence()
            }
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
        } else {
            if (self.player != nil) {
                self.player.stop()
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
        if (self.sentences.count == 0 && self.word != nil) {
            var params = NSMutableDictionary()
            params.setValue(self.word!["id"] as String, forKey: "id")
            API.instance.get("/sentence/getByWordId", delegate: self, params: params)
        }
    }
    
    func sentenceGetByWordId(data: AnyObject) {
        self.sentences.setArray(data as NSArray)
        self.setToSentencesView()
        
        var shouldAutoVoice = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.SENTENCE_AUTO_VOICE) as Bool
        if (shouldAutoVoice) {
            self.playSentence()
        }
    }
    
    func clearSentencesView() {
        for view in (self.sentencesScrollView.subviews as NSArray) {
            view.removeFromSuperview()
        }
    }
    
    func setToSentencesView() {
        var sentencesCount = CGFloat(self.sentences.count)
        self.sentencesScrollView.contentSize = CGSize(width: self.sentencesScrollView.frame.width * sentencesCount, height: sentencesScrollView.frame.height)
        
        if (sentencesCount > 0) {
            self.scrollIndicator.frame = CGRect(x: 0, y: self.sentencesScrollView.frame.height - 2, width: self.sentencesScrollView.frame.width / sentencesCount, height: 2)
            self.scrollIndicator.hidden = false
        } else {
            self.scrollIndicator.hidden = true
        }

        for(var i = 0; i < self.sentences.count; i++) {
            var sentence: AnyObject = self.sentences[i]
            var sentenceView = UIScrollView(frame: CGRect(x: CGFloat(i) * self.sentencesScrollView.frame.width, y: 20, width: self.sentencesScrollView.frame.width, height: self.sentencesScrollView.frame.height - 20))
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
        if (self.player == nil) {
            self.playSentence()
            return
        }
        
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
        
        NSUserDefaults.standardUserDefaults().setObject(type, forKey: CacheKey.WORD_PHONETIC_TYPE)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.setWordPhonetic()
    }
    
    func onKnowButtonTapped(sender: UIButton) {
        self.setNextWord()
        self.setToView()
    }
    
    func onNextButtonTapped(sender: UIButton) {
        self.setNextWord()
        self.setToView()
    }
    
    func onBlurViewTapped(recognizer: UIGestureRecognizer) {
        self.hideBlurView()
    }
    
    func onBlurViewForWordTapped(recognizer: UIGestureRecognizer) {
        self.hideBlurViewForWord()
    }
    
    func showBlurView() {
        self.blurView.hidden = false
        self.blurView.blurRadius = 5
        var progressView = blurView.viewWithTag(10009) as UAProgressView
        progressView.setProgress(1, animated: true)
        self.blurView.updateAsynchronously(true, completion: {() in
            progressView.setProgress(0.8, animated: true)
        })
        
        if (self.timer != nil) {
            self.timer.invalidate()
        }
        
        self.timer = NSTimer(timeInterval: NSTimeInterval(1), target: self, selector: "updateProgress:", userInfo: self.blurView, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSDefaultRunLoopMode)
    }
    
    func showBlurViewForWord() {
        self.blurViewForWord.hidden = false
        self.blurViewForWord.blurRadius = 8
        var progressView = blurViewForWord.viewWithTag(10009) as UAProgressView
        progressView.setProgress(1, animated: true)
        self.blurViewForWord.updateAsynchronously(true, completion: {() in
            progressView.setProgress(0.8, animated: true)
        })
        
        if (self.timer != nil) {
            self.timer.invalidate()
        }
        
        self.timer = NSTimer(timeInterval: NSTimeInterval(1), target: self, selector: "updateProgressForWord:", userInfo: self.blurViewForWord, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSDefaultRunLoopMode)
    }
    
    
    func hideBlurView() {
        self.blurView.blurRadius = 0
        self.blurView.updateAsynchronously(true, completion: {()in
            self.blurView.hidden = true
            if (self.timer != nil) {
                self.timer.invalidate()
                self.timer = nil
            }
        })
        
        if (knowButton != nil && nextButton != nil) {
            knowButton.hidden = true
            nextButton.hidden = false
        }
    }
    
    func hideBlurViewForWord() {
        self.blurViewForWord.blurRadius = 0
        self.blurViewForWord.updateAsynchronously(true, completion: {()in
            self.blurViewForWord.hidden = true
            if (self.timer != nil) {
                self.timer.invalidate()
                self.timer = nil
            }
        })
        
        if (knowButton != nil && nextButton != nil) {
            knowButton.hidden = true
            nextButton.hidden = false
        }
    }
    
    func updateProgress(timer: NSTimer) {
        var blurView = timer.userInfo as FXBlurView
        var progressView = blurView.viewWithTag(10009) as UAProgressView
        progressView.setProgress(progressView.progress - 0.2, animated: true)
        if (progressView.progress == 0) {
            self.hideBlurView()
        }
    }
    
    func updateProgressForWord(timer: NSTimer) {
        var blurView = timer.userInfo as FXBlurView
        var progressView = blurView.viewWithTag(10009) as UAProgressView
        progressView.setProgress(progressView.progress - 0.2, animated: true)
        if (progressView.progress == 0) {
            self.hideBlurViewForWord()
        }
    }
    
    func onWordLabelTapped(recognizer: UITapGestureRecognizer) {
        if (self.word != nil) {
            var tapPoint:CGPoint = recognizer.locationInView(self.wordLabel)
            TapPointView(view: self.wordLabel, tapPoint: tapPoint, completion: {() in
                var applicationContoller = self.parentViewController as ApplicationController
                applicationContoller.scrollToPage(page: 4)
            })
        } else {
            var applicationController = self.parentViewController as ApplicationController
            var homeController = applicationController.homeController
            applicationController.scrollToPage(page: 2)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                homeController.scrollToPageUpAndDown(page: 1)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                    homeController.scrollToPage(page: 2)
                })
            })
        }
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
            self.pageMode = 0
        } else {
            self.pageMode = 1
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
        // hide all the view
        wordLabel.hidden = true
        removeButton.hidden = true
        tableViewWrap.hidden = true
        wordPhoneticButton.hidden = true
        wordPhoneticSymbolLabel.hidden = true
        knowButton.hidden = true
        nextButton.hidden = true
        tableView.hidden = true
        chineseView.hidden = true
        blurView.hidden = true
        
        removeButton.hidden = (self.pageMode == 0)
        tableViewWrap.hidden = (self.pageMode == 0)
        
        if (self.pageMode == 0) {
            wordLabel.text = "请选择您想学习的词库"
            wordLabel.font = UIFont.systemFontOfSize(20)
            wordLabel.hidden = false
            return
        } else {
            wordLabel.text = self.word!["word"] as? String
            wordLabel.textColor = Color.gray
            wordLabel.font = UIFont.systemFontOfSize(40)
            wordLabel.hidden = false
        }
        
        if (self.pageMode != 0) {
            self.setWordPhonetic()
        }
        
        if (self.pageMode == 2) { // show the chinese , and the next button
            chineseView.hidden = false
            chineseView.text = self.chineseString
            chineseView.textColor = Color.gray
            chineseView.font = UIFont(name: Fonts.kaiti, size: CGFloat(18))
            chineseView.textAlignment = NSTextAlignment.Center
        }
        
        if (self.pageMode == 3) {
            chineseView.hidden = false
            chineseView.text = self.chineseString
            chineseView.textColor = Color.gray
            chineseView.font = UIFont(name: Fonts.kaiti, size: CGFloat(18))
            chineseView.textAlignment = NSTextAlignment.Center
            self.showBlurView()
        }
        
        if (self.pageMode == 4) {
            chineseView.hidden = false
            chineseView.text = self.chineseString
            chineseView.textColor = Color.gray
            chineseView.font = UIFont(name: Fonts.kaiti, size: CGFloat(18))
            chineseView.textAlignment = NSTextAlignment.Center
            self.showBlurViewForWord()
        }
        
        knowButton.hidden = (self.pageMode == 0 || self.pageMode == 1 || self.pageMode == 2)
        nextButton.hidden = (self.pageMode == 0 || self.pageMode == 1 || self.pageMode == 3 || self.pageMode == 4)
        tableView.hidden = (self.pageMode == 0 || self.pageMode == 2 || self.pageMode == 3 || self.pageMode == 4)
        
        self.tableView.reloadData()
    }
    
    func setWordPhonetic() {
        var type = self.wordPhoneticType()
        wordPhoneticButton.setTitle(type, forState: UIControlState.Normal)
        wordPhoneticButton.hidden = false
        if (type == "us") {
            wordPhoneticSymbolLabel.text = self.word!["phoneticSymbolUS"]? as? String
            wordPhoneticSymbolLabel.hidden = false
        }
        if (type == "uk") {
            wordPhoneticSymbolLabel.text = self.word!["phoneticSymbolUK"]? as? String
            wordPhoneticSymbolLabel.hidden = false
        }
        wordPhoneticSymbolLabel.sizeToFit()
        wordPhoneticButton.frame = CGRect(x: viewLearnWordPage.frame.width / 2 - (wordPhoneticButton.frame.width + wordPhoneticSymbolLabel.frame.width) / 2, y: wordPhoneticButton.frame.origin.y, width: wordPhoneticButton.frame.width, height: wordPhoneticButton.frame.height)
        wordPhoneticSymbolLabel.frame = CGRect(x: wordPhoneticButton.frame.origin.x + wordPhoneticButton.frame.width, y: wordPhoneticSymbolLabel.frame.origin.y, width: wordPhoneticSymbolLabel.frame.width, height: wordPhoneticSymbolLabel.frame.height)
        
        var shouldAutoVoice = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.WORD_AUTO_VOICE) as Bool
        if (shouldAutoVoice) {
            self.playVoice()
        }
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