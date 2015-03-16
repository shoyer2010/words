//
//  LearnWordController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

class LearnWordController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,  APIDataDelegate, WordDetailDelegate, SearchWordResultDelegate, AVAudioPlayerDelegate {
    var optionSelectedRow: Int?
    var learnWordScrollView: UIScrollView!
    var sentencesScrollView: UIScrollView!
    var scrollIndicator: UIView!
    var word: AnyObject?
    var selectedDictionaryId: String?
    var sentences: NSMutableArray! = NSMutableArray()
    var chineseString: String?
    var correctOptinIndex: Int?
    var randomChineseArray: NSMutableArray! = NSMutableArray()
    var player: AVAudioPlayer!
    var currentSentenceIndex: Int! = 0
    
    var viewLearnWordPage: UIView!
    
    var wordLabel: UILabel!
    var wordPhoneticButton: UIButton!
    var wordPhoneticSymbolLabel: UILabel!
    var voiceIcon: UIButton!
    var knowButton: UIButton!
    var nextButton: UIButton!
    var removeButton: UIButton!
    var statusButton: UIButton!
    var infoView: UILabel!
    
    var wordView: UIView!
    var tableViewWrap: UIView!
    var tableView: UITableView!
    var chineseView: UILabel!
    var blurView: FXBlurView!
    var blurViewForWord: FXBlurView!
    var timer: NSTimer!
    
    var wrongCounter: Int! = 0
    
    var rightSecondsCounter: NSTimeInterval!
    
    var indicator: UIActivityIndicatorView!
    
    var viewLearnWordSentence: UIView!
    
    var matchWord: String?
    
    
    // 0 no word to show. 
    // 1 no button, and four options to choose.
    // 2 word and right chinese , next button
    // 3 word and blured right chinese with a timecount progress, known button.
    // 4 blured word with a timecount progress, and right chinese, known button.
    // 5 TODO: all the words has been mastered no word to show
    
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
        viewLearnWordSentence = UIView(frame: CGRect(x: 0, y: 0, width: learnWordScrollView.frame.width, height: viewLearnWordSentenceHeight))
        viewLearnWordSentence.backgroundColor = Color.blockBackground
        self.sentencesScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewLearnWordSentence.frame.width, height: viewLearnWordSentence.frame.height))
        self.sentencesScrollView.delegate = self
        self.sentencesScrollView.pagingEnabled = true
        self.sentencesScrollView.bounces = false
        self.sentencesScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onSentencesScrollViewTapped:"))
        self.sentencesScrollView.showsHorizontalScrollIndicator = false
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: viewLearnWordSentence.frame.width / 2 - 15, y: viewLearnWordSentence.frame.height / 2 - 15, width: 30, height: 30))
        indicator.color = Color.red
        viewLearnWordSentence.addSubview(indicator)
        
        self.scrollIndicator = UIView()
        self.scrollIndicator.backgroundColor = Color.red
        viewLearnWordSentence.addSubview(self.scrollIndicator)
        viewLearnWordSentence.addSubview(self.sentencesScrollView)
        learnWordScrollView.addSubview(viewLearnWordSentence)
        
        // page down
        viewLearnWordPage = UIView()
        viewLearnWordPage.backgroundColor = Color.appBackground
        viewLearnWordPage.frame = CGRectMake(0, viewLearnWordSentenceHeight, learnWordScrollView.frame.width, learnWordScrollView.frame.height)
        
        
        removeButton = UIButton(frame: CGRect(x: 15, y: 32, width: 30, height: 30))
        removeButton.backgroundColor = UIColor(patternImage: UIImage(named: "remove.png")!)
        removeButton.layer.cornerRadius = 15
        removeButton.layer.masksToBounds = true
        removeButton.addTarget(self, action: "onRemoveButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        viewLearnWordPage.addSubview(removeButton)
        
        statusButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width - 45, y: 32, width: 30, height: 30))
        statusButton.backgroundColor = UIColor(patternImage: UIImage(named: "info.png")!)
        statusButton.layer.cornerRadius = 15
        statusButton.layer.masksToBounds = true
        statusButton.addTarget(self, action: "onStatusButtonTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        statusButton.addTarget(self, action: "onStatusButtonTouchUp:", forControlEvents: UIControlEvents.TouchUpInside | UIControlEvents.TouchUpOutside)
        viewLearnWordPage.addSubview(statusButton)
        
        infoView = UILabel(frame: CGRect(x: removeButton.frame.origin.x + removeButton.frame.width + 15, y: 32, width: viewLearnWordPage.frame.width - 120, height: 90))
        infoView.text = "  已经出现： 4 次\n  正确回答： 5 次 \n  错误： 5 次 \n  平均反应(只算正确)：23 秒 \n  词圣安排复习时间点：1天后"
        infoView.textColor = Color.lightGray
        infoView.font = UIFont(name: Fonts.kaiti, size: 14)
        infoView.numberOfLines = 5
        infoView.hidden = true
        infoView.alpha = 0.95
        infoView.backgroundColor = Color.blockBackground
        infoView.layer.cornerRadius = Layer.cornerRadius
        infoView.layer.borderColor = Color.lightGray.CGColor
        infoView.layer.borderWidth = 1
        infoView.layer.masksToBounds = true
        viewLearnWordPage.addSubview(infoView)
        
        
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
        
        voiceIcon = UIButton()
        voiceIcon.hidden = true
        voiceIcon.addTarget(self, action: "onVoiceIconTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        wordView.addSubview(voiceIcon)
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
            self.updateWordStatus(2)
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
        
        if (tableView.respondsToSelector("setLayoutMargins:")) {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        
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
            self.updateWordStatus(2)
            self.hideBlurView()
        }
        blurView.addSubview(progressView)
        self.showBlurView()
        self.hideBlurView()
        tableViewWrap.addSubview(blurView)
        
        
        knowButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width / 2 - 50, y: tableViewWrap.frame.origin.y + tableViewWrap.frame.height + 20, width: 100, height: 100))
        knowButton.backgroundColor = UIColor(patternImage: UIImage(named: "known.png")!)
        knowButton.layer.cornerRadius = 50
        knowButton.layer.masksToBounds = true
        knowButton.addTarget(self, action: "onKnowButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        knowButton.hidden = true
        viewLearnWordPage.addSubview(knowButton)
        
        nextButton = UIButton(frame: CGRect(x: viewLearnWordPage.frame.width / 2 - 50, y: tableViewWrap.frame.origin.y + tableViewWrap.frame.height + 20, width: 100, height: 100))
        nextButton.backgroundColor = UIColor(patternImage: UIImage(named: "next.png")!)
        nextButton.layer.cornerRadius = 50
        nextButton.layer.masksToBounds = true
        nextButton.addTarget(self, action: "onNextButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.hidden = true
        viewLearnWordPage.addSubview(nextButton)
        
        learnWordScrollView.addSubview(viewLearnWordPage)

        learnWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
    }
    
    func startLoading() {
        self.viewLearnWordSentence.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func endLoading() {
        self.indicator.stopAnimating()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView == self.sentencesScrollView) {
            self.currentSentenceIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: CacheKey.GUIDE_HAVE_SWIPE_ON_SENTENCE)
            NSUserDefaults.standardUserDefaults().synchronize()
            
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
            
            var haveSwipeSentence = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.GUIDE_HAVE_SWIPE_ON_SENTENCE) as? Bool
            if (haveSwipeSentence == nil) {
                var view = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 25))
                self.view.addSubview(view)
                SuccessView(view: view, message: "左右滑动切换例句", completion: {() in
                    view.removeFromSuperview()
                })
            }
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
        
        if (cell.respondsToSelector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
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
                answerLabel.text = indexPath.row == self.correctOptinIndex ? self.chineseString : self.randomChineseArray?[0] as? String
            case 1:
                answerLabel.text = indexPath.row == self.correctOptinIndex ? self.chineseString : self.randomChineseArray?[1] as? String
            case 2:
                answerLabel.text = indexPath.row == self.correctOptinIndex ? self.chineseString : self.randomChineseArray?[2] as? String
            case 3:
                answerLabel.text = indexPath.row == self.correctOptinIndex ? self.chineseString : self.randomChineseArray?[3] as? String
            default:
                break
            }
        }
        
        answerLabel.textColor = Color.gray
        answerLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(18))
        answerLabel.textAlignment = NSTextAlignment.Left
        cell.addSubview(answerLabel)
        
        if (indexPath.row == self.optionSelectedRow && indexPath.row == self.correctOptinIndex) {
            selectedView.backgroundColor = Color.green // if right use Color.green, if wrong use Color.red
            answerLabel.textColor = Color.white
        } else if (indexPath.row == self.optionSelectedRow && indexPath.row != self.correctOptinIndex) {
            selectedView.backgroundColor = Color.red // if right use Color.green, if wrong use Color.red
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(200 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
            if (indexPath.row == self.correctOptinIndex) {
                self.updateWordStatus(1)
                self.setNextWord()
            } else {
                self.updateWordStatus(2)
                self.pageMode = 2
                self.setToView()
            }
        })
    }
    
    
    func onStatusButtonTouchDown(sender: UIButton) {
        self.infoView.hidden = false
        self.viewLearnWordPage.bringSubviewToFront(self.infoView)
        
        MobClick.event("onStatusButtonTouchDown")
    }
    
    func onStatusButtonTouchUp(sender: UIButton) {
        self.infoView.hidden = true
    }
    
    func onRemoveButtonTapped(recognizer: UIGestureRecognizer) {
        DictionaryUtil.deleteWordFromDictionary(self.selectedDictionaryId!, wordId: self.word!["id"] as String, delegate: self)
        self.setNextWord()
        
        MobClick.event("onRemoveButtonTapped")
    }
    
    func dictionaryCustomWord(data: AnyObject, params: NSMutableDictionary) {
        var wordId = params["id"] as String
        var type = params["type"] as Int
        
        var customDictionayId = DictionaryUtil.customDictionaryId()
        var db = Database(Util.getFilePath(customDictionayId + ".db"))
        db.prepare("DELETE FROM operationLogs WHERE wordId=? and wordStatus=?", wordId, type).run()
    }
    
    func postWrongWordsToServer() {
        var db = Database(Util.getFilePath(self.getUserId() + ".db"))
        
        var string = ""
        for row in db.prepare("SELECT wordId, appearTimes-rightTimes as wrongTimes FROM learningProgress WHERE dictionaryId=? ORDER BY lastAppearTime DESC, wrongTimes DESC LIMIT 5", self.selectedDictionaryId) {
            string += row[0] as String + "|"
        }
        
        var params = NSMutableDictionary()
        params.setValue(string, forKey: "words")
        API.instance.post("/word/wrongWords", delegate: self, params: params)
    }
    
    func wordWrongWords(data: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(time(nil), forKey: CacheKey.WRONG_WORD_POST_TIME)
    }
    
    func updateWordStatus(type: Int) { // 1, right, 2, wrong
        
        var wordStatus = (self.word!["wordStatus"] as Int)
        var db = Database(Util.getFilePath(self.getUserId() + ".db"))
        var currentTimestamp = Int(time(nil))
        var lastAppearTime: Int = self.word!["lastAppearTime"] as Int
        
        var newStatus: Int = wordStatus
        
        if (type == 2) {
            newStatus = 1
            lastAppearTime = currentTimestamp
            self.wrongCounter = self.wrongCounter + 1
        }
        
        
        var lastPostTime = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.WRONG_WORD_POST_TIME) as? Int
        if (lastPostTime == nil) {
            NSUserDefaults.standardUserDefaults().setObject(time(nil), forKey: CacheKey.WRONG_WORD_POST_TIME)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        lastPostTime = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.WRONG_WORD_POST_TIME) as? Int
        
        if self.wrongCounter > 50 || (time(nil) as Int) - lastPostTime! >= 86400 {
            self.postWrongWordsToServer()
        }
        
        if (type == 1 && (wordStatus == 1 || wordStatus == 0)) {
            lastAppearTime = currentTimestamp
            newStatus = 2
        }
        
        if (type == 1 && wordStatus == 2 && currentTimestamp - lastAppearTime >= DateUtil.DAYS_1) {
            lastAppearTime = currentTimestamp
            newStatus = wordStatus + 1
        }
        
        if (type == 1 && wordStatus == 3 && currentTimestamp - lastAppearTime >= DateUtil.DAYS_10) {
            lastAppearTime = currentTimestamp
            newStatus = wordStatus + 1
        }
        
        if (type == 1 && wordStatus == 4 && currentTimestamp - lastAppearTime >= DateUtil.DAYS_30) {
            lastAppearTime = currentTimestamp
            newStatus = wordStatus + 1
        }
        
        if (type == 1 && wordStatus == 5 && currentTimestamp - lastAppearTime >= DateUtil.DAYS_60) {
            lastAppearTime = currentTimestamp
            newStatus = wordStatus + 1
        }
        
        var rightTimes = self.word!["rightTimes"] as Int
        var rightSeconds = self.word!["rightSeconds"] as Float
        
        if (type == 1) {
            rightTimes = rightTimes + 1
            var time = Float(NSDate().timeIntervalSince1970 - self.rightSecondsCounter)
            rightSeconds = rightSeconds + time
        }
        
        db.prepare("UPDATE learningProgress SET wordStatus=?, lastAppearTime=?, rightTimes=?, rightSeconds=?  WHERE dictionaryId=? and wordId=?", newStatus, lastAppearTime, rightTimes, NSString(format: "%.2f", rightSeconds) as String, self.selectedDictionaryId, self.word!["id"] as String).run()
    }
    
    func frameOfView() -> CGRect {
        return CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
    }
    
    func searchWord() -> String {
        if (self.learnWordScrollView.contentOffset.y < self.viewLearnWordSentenceHeight - 20) {
            return self.matchWord!
        } else {
            if (self.word != nil) {
                return self.word!["word"] as String
            }
            
            return ""
        }
    }
    
    func loadSentences() {
        if (self.sentences.count == 0 && self.word != nil) {
            self.startLoading()
            var params = NSMutableDictionary()
            params.setValue(self.word!["id"] as String, forKey: "id")
            API.instance.get("/sentence/getByWordId", delegate: self, params: params)
        }
    }
    
    func sentenceGetByWordId(data: AnyObject) {
        self.endLoading()
        self.sentences.setArray(data as NSArray)
        self.setToSentencesView()
        
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: CacheKey.GUIDE_HAVE_SLIDE_DOWN_TO_SEE_SENTENCE)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        var shouldAutoVoice = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.SENTENCE_AUTO_VOICE) as? Bool
        if (shouldAutoVoice != nil && shouldAutoVoice!) {
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
            var noSentencsFound = UILabel(frame: self.sentencesScrollView.frame)
            noSentencsFound.text = "此单词暂无例句"
            noSentencsFound.font = UIFont(name: Fonts.kaiti, size: 18)
            noSentencsFound.textAlignment = NSTextAlignment.Center
            noSentencsFound.textColor = Color.gray
            self.sentencesScrollView.addSubview(noSentencsFound)
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
            sentenceEnglishView.userInteractionEnabled = true
            sentenceEnglishView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapEnglishSentence:"))
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
            if (sentence["from"] as? String != nil && (sentence["from"] as NSString).length > 1) {
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
    
    func onTapEnglishSentence(recognizer: UITapGestureRecognizer) {
        var tapPoint:CGPoint = recognizer.locationInView(recognizer.view!)
        self.matchWord = Util.recognizeWord(recognizer.view! as UILabel, recognizer: recognizer)
        
        TapPointView(view: recognizer.view!, tapPoint: tapPoint, completion: { () -> Void in
            if (self.matchWord != nil) {
                var searchWordResultController = SearchWordResultController()
                searchWordResultController.delegate = self
                self.addChildViewController(searchWordResultController)
                self.view.addSubview(searchWordResultController.view)
                MobClick.event("tapEnglishWord", attributes: ["page": "onTapEnglishSentence"])
            }
        })
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
            self.player.pause()
        } else {
            self.player.play()
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
        self.updateWordStatus(1)
        self.setNextWord()
    }
    
    func onNextButtonTapped(sender: UIButton) {
        self.setNextWord()
    }
    
    func onBlurViewTapped(recognizer: UIGestureRecognizer) {
        self.updateWordStatus(2)
        self.hideBlurView()
    }
    
    func onBlurViewForWordTapped(recognizer: UIGestureRecognizer) {
        self.updateWordStatus(2)
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
        
        self.stopTimer()
        
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
        
        self.stopTimer()
        
        self.timer = NSTimer(timeInterval: NSTimeInterval(1), target: self, selector: "updateProgressForWord:", userInfo: self.blurViewForWord, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSDefaultRunLoopMode)
    }
    
    func stopTimer() {
        if (self.timer != nil) {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    func hideBlurView() {
        self.blurView.blurRadius = 0
        self.blurView.updateAsynchronously(true, completion: {()in
            self.blurView.hidden = true
            self.stopTimer()
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
            self.stopTimer()
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
            self.updateWordStatus(2)
            self.hideBlurView()
        }
    }
    
    func updateProgressForWord(timer: NSTimer) {
        var blurView = timer.userInfo as FXBlurView
        var progressView = blurView.viewWithTag(10009) as UAProgressView
        progressView.setProgress(progressView.progress - 0.2, animated: true)
        if (progressView.progress == 0) {
            self.updateWordStatus(2)
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
    
    func onVoiceIconTapped(sender: UIButton) {
        self.playVoice()
    }
    
    func shoudRegisterNotification() -> Bool {
        return true
    }
    
    func setTheDictionary() {
        var customDictionary = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_CUSTOM_DICTIONARY) as? String
        var learningDictionary = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_DICTIONARY) as? String
        
        var customDictionaryWeight = 0
        if (customDictionary != nil) {
            var db = Database(Util.getFilePath((customDictionary! as String) + ".db"))
            for row in db.prepare("SELECT count(rowid) FROM words") {
                customDictionaryWeight = row[0] as Int
            }
        }
        
        var learningDictionaryWeight = 0
        if (learningDictionary != nil) {
            var db = Database(Util.getFilePath((learningDictionary! as String) + ".db"))
            for row in db.prepare("SELECT count(rowid) FROM words") {
                learningDictionaryWeight = row[0] as Int
            }
        }
        
        var total = customDictionaryWeight + learningDictionaryWeight
        
        if (total <= 0) {
            self.selectedDictionaryId = nil
        } else if (total == customDictionaryWeight) {
            self.selectedDictionaryId = customDictionary
        } else if (total == learningDictionaryWeight) {
            self.selectedDictionaryId = learningDictionary
        }else {
            if (Util.getRandomInt(from: 1, to: total) <= customDictionaryWeight) {
                self.selectedDictionaryId = customDictionary
            } else {
                self.selectedDictionaryId = learningDictionary
            }
        }
    }
    
    func getUserId() -> String {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        return user!["id"] as String
    }
    
    func computeTheWord() -> String? {
        var db = Database(Util.getFilePath(self.getUserId() + ".db"))
        var currentTimestamp = Int(time(nil))
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus=5 and lastAppearTime<=? limit 1", self.selectedDictionaryId!,currentTimestamp - DateUtil.DAYS_60) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus=4 and lastAppearTime<=? limit 1", self.selectedDictionaryId!, currentTimestamp - DateUtil.DAYS_30) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus=3 and lastAppearTime<=? limit 1", self.selectedDictionaryId!,currentTimestamp - DateUtil.DAYS_10) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus=2 and lastAppearTime<=? limit 1", self.selectedDictionaryId!,currentTimestamp - DateUtil.DAYS_1) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus=1 and lastAppearTime<=? limit 1", self.selectedDictionaryId!, currentTimestamp - Util.getRandomInt(from: 20, to: 120)) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus=0 order by random() limit 1", self.selectedDictionaryId!) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus in(2,3,4,5) order by random() limit 1", self.selectedDictionaryId!) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        for row in db.prepare("SELECT wordId FROM learningProgress WHERE dictionaryId=? and wordStatus!=6 order by random() limit 1", self.selectedDictionaryId!) {
            if (row[0] != nil) {
                return row[0] as? String
            }
        }
        
        return nil
    }
    
    func setTheWord() {
        var wordId = self.computeTheWord()
        
        if (wordId == nil) {
            self.word = nil
            return
        }
        
        var db = Database(Util.getFilePath(self.selectedDictionaryId! + ".db"))
        for row in db.prepare("SELECT id, word, phoneticSymbolUS, usPronunciation, phoneticSymbolUK, ukPronunciation, chinese FROM words WHERE id=?", wordId) {
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
            
            var db = Database(Util.getFilePath(self.getUserId() + ".db"))
            for row in db.prepare("SELECT wordStatus, lastAppearTime, rightTimes, appearTimes, rightSeconds FROM learningProgress WHERE dictionaryId=? and wordId=?", self.selectedDictionaryId!, wordId) {
                
                var wordStatus: Int = row[0] as Int
                var lastAppearTime: Int = row[1] as Int
                var rightTimes: Int = row[2] as Int
                var appearTimes: Int = row[3] as Int
                var rightSeconds: Float = ((row[4] as String) as NSString).floatValue
                self.word = ["id": id, "word": wordString, "phoneticSymbolUS": phoneticSymbolUS, "usPronunciation": usPronunciation, "phoneticSymbolUK": phoneticSymbolUK, "ukPronunciation": ukPronunciation, "chinese": chinese, "wordStatus": wordStatus, "lastAppearTime": lastAppearTime, "rightTimes": rightTimes, "rightSeconds": rightSeconds, "appearTimes": appearTimes]
                
                switch (wordStatus) {
                case 0:
                    self.pageMode = 1
                case 1:
                    self.pageMode = Util.getRandomInt(from: 1, to: 2) == 1 ? 1: 3
                case 2:
                    var random = Util.getRandomInt(from: 1, to: 3)
                    if random == 1 {
                        self.pageMode = 1
                    } else if (random == 2) {
                        self.pageMode = 3
                    } else {
                        self.pageMode = 4
                    }
                case 3:
                    self.pageMode = Util.getRandomInt(from: 3, to: 4)
                case 4:
                    self.pageMode = Util.getRandomInt(from: 1, to: 2) == 1 ? 1: 3
                case 5:
                    self.pageMode = 3
                default:
                    self.pageMode = Util.getRandomInt(from: 3, to: 4)
                }
                
                appearTimes = appearTimes + 1
                db.prepare("UPDATE learningProgress SET appearTimes=?  WHERE dictionaryId=? and wordId=?", appearTimes, self.selectedDictionaryId, self.word!["id"] as String).run()
            }
        }
        
        self.setWrongChineseArray()
    }
    
    func setWrongChineseArray() {
        var dbUser = Database(Util.getFilePath(self.getUserId() + ".db"))
        var db = Database(Util.getFilePath(self.selectedDictionaryId! + ".db"))
        self.randomChineseArray = NSMutableArray()
        for rowOut in dbUser.prepare("SELECT wordId FROM(SELECT wordId FROM learningProgress WHERE dictionaryId=? AND wordId!=? ORDER BY lastAppearTime DESC LIMIT 10) ORDER BY random() LIMIT 4", self.selectedDictionaryId, self.word!["id"] as String) {
            
            for row in db.prepare("SELECT chinese FROM words WHERE id=?", rowOut[0] as String) {
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
                
                if (tempString.length >= 1) {
                    self.randomChineseArray.addObject(tempString.substringToIndex(tempString.length - 1))
                }
            }
        }
        
        
        var randomChineseArray = [
            "书籍；卷；帐簿；名册；工作簿",
            "试验；检验",
            "那；那个",
            "在哪里",
            "你；你们",
            "男颜 ; 送给他 ; 她主义 ; 对象给他买",
            "计算机系统结构",
            "删除图层 ; 删除层 ; 删除色层 ; 命令",
            "回忆；回忆起来的事；能记得的情况",
            "幸福",
            "最美好的",
            "国家的， 人民的",
            "世界",
            "海外，海外的",
            "星星",
            "星球",
            "伤心的，难过的",
            "快乐的，高兴的",
            "未知的，未发觉的",
            "认真，专心"
        ]
        while (self.randomChineseArray.count < 4) {
            self.randomChineseArray.addObject(randomChineseArray[Util.getRandomInt(from: 0, to: 19)])
        }
    }
    
    
    func setNextWord() {
        self.setTheDictionary()

        if (self.selectedDictionaryId == nil) {
            self.word = nil
            self.pageMode = 0
        } else {
            self.setTheWord()
            
            // if the word is still null,  that means this dictionary has been done
            if (self.word == nil) {
                self.pageMode = 5
            }
        }
        
        self.rightSecondsCounter = NSTimeInterval(0)
        self.stopTimer()
        self.optionSelectedRow = nil
        self.currentSentenceIndex = 0
        self.sentencesScrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollIndicator.frame = CGRect(x: 0, y: self.scrollIndicator.frame.origin.y, width: self.scrollIndicator.frame.width, height: 2)
        self.setChineseString()
        self.setCorrectOptinIndex()
        self.sentences = NSMutableArray()
        self.clearSentencesView()
        self.setToView()
    }
    
    func setCorrectOptinIndex() {
        self.correctOptinIndex = Util.getRandomInt(from: 0, to: 3)
    }
    
    func setChineseString() {
        self.chineseString = ""
        if (self.word != nil) {
            for (key, value) in (self.word!["chinese"] as NSDictionary) {
                self.chineseString! += "\(value)，"
            }
            
            if (self.chineseString != "") {
                var tempString = self.chineseString! as NSString
                self.chineseString = tempString.substringToIndex(tempString.length - 1)
            } else {
                self.chineseString = "此单词中文暂缺"
            }
        }
    }
    
    func onPageChange(notification: NSNotification) {
        self.learnWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.LearnWord && PageCode(rawValue: notification.userInfo?["previousPage"] as Int) == PageCode.Home) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
                
                var haveSawSentence = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.GUIDE_HAVE_SLIDE_DOWN_TO_SEE_SENTENCE) as? Bool
                
                if (haveSawSentence == nil) {
                    var view = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 25))
                    self.view.addSubview(view)
                    SuccessView(view: view, message: "下滑显示例句", completion: {() in
                        view.removeFromSuperview()
                    })
                }
                
                self.setNextWord()
            })
        } else {
            if (self.player != nil) {
                self.player.stop()
            }
        }
    }
    
    func setToView() {
        // hide all the view
        wordLabel.hidden = true
        statusButton.hidden = true
        removeButton.hidden = true
        voiceIcon.hidden = true
        tableViewWrap.hidden = true
        wordPhoneticButton.hidden = true
        wordPhoneticSymbolLabel.hidden = true
        knowButton.hidden = true
        nextButton.hidden = true
        tableView.hidden = true
        chineseView.hidden = true
        blurView.hidden = true
        blurViewForWord.hidden = true
        
        removeButton.hidden = (self.pageMode == 0 || self.pageMode == 5)
        statusButton.hidden = (self.pageMode == 0 || self.pageMode == 5)
        tableViewWrap.hidden = (self.pageMode == 0)
        
        if (self.pageMode == 0) {
            wordLabel.text = "请选择您想学习的词库"
            wordLabel.font = UIFont.systemFontOfSize(20)
            wordLabel.hidden = false
            return
        } else if (self.pageMode == 5) {
            var dictionary: AnyObject? = DictionaryUtil.getDictionaryInfo(self.selectedDictionaryId!)
            var name = dictionary!["name"] as String
            chineseView.hidden = false
            chineseView.text = "恭喜，功夫不负有心人!\n \(name) \n 已经全部掌握 \n 如不想看到此页面，请将此词库设为非学习状态"
            chineseView.textColor = Color.red
            chineseView.font = UIFont(name: Fonts.kaiti, size: CGFloat(18))
            chineseView.textAlignment = NSTextAlignment.Center
            nextButton.hidden = false
            return
        } else {
            wordLabel.text = self.word!["word"] as? String
            wordLabel.textColor = Color.gray
            wordLabel.font = UIFont.systemFontOfSize(40)
            wordLabel.hidden = false
            
            var appearTimes = self.word!["appearTimes"] as Int
            var rightTimes = self.word!["rightTimes"] as Int
            var rightSeconds = self.word!["rightSeconds"] as? Float
            var text = "-"
            if (rightSeconds != nil && rightSeconds > 0 && rightTimes > 0) {
                var averageTime = rightSeconds! / Float(rightTimes)
                text = NSString(format: "%.2f", averageTime)
            }
            
            infoView.text = "  已经出现： \(appearTimes) 次\n  正确回答： \(rightTimes) 次 \n  错误： \(appearTimes - rightTimes) 次 \n  平均反应(只算正确)：\(text) 秒 \n  词圣安排复习时间点：\(self.getTheNextReviewString())"
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
        self.rightSecondsCounter = NSDate().timeIntervalSince1970
    }
    
    func getTheNextReviewString() -> String {
        var string = "-"
        if self.word == nil {
            return string
        }
        
        var days = 0
        if self.word!["wordStatus"] as Int == 5 {
            days = (self.word!["lastAppearTime"] as Int + DateUtil.DAYS_60 - time(nil)) / 86400
        }
        
        if self.word!["wordStatus"] as Int == 4 {
            days = (self.word!["lastAppearTime"] as Int + DateUtil.DAYS_30 - time(nil)) / 86400
        }
        
        if self.word!["wordStatus"] as Int == 3 {
            days = (self.word!["lastAppearTime"] as Int + DateUtil.DAYS_10 - time(nil)) / 86400
        }
        
        if self.word!["wordStatus"] as Int == 2 {
            days = (self.word!["lastAppearTime"] as Int + DateUtil.DAYS_1 - time(nil)) / 86400
        }
        
        if (days < 1) {
            string = "今天"
        }
        
        if (days >= 1 && days <= 2) {
            string = "明天"
        }
        
        if (days > 2) {
            string = "\(Int(days))天后"
        }
        
        return string
    }
    
    func setWordPhonetic() {
        var type = self.wordPhoneticType()
        wordPhoneticButton.setTitle(type, forState: UIControlState.Normal)
        
        if (type == "us") {
            wordPhoneticSymbolLabel.text = self.word!["phoneticSymbolUS"]? as? String
        }
        
        if (type == "uk") {
            wordPhoneticSymbolLabel.text = self.word!["phoneticSymbolUK"]? as? String
        }
        
        if (wordPhoneticSymbolLabel.text != nil && (wordPhoneticSymbolLabel.text! as NSString).length > 0) {
            wordPhoneticSymbolLabel.hidden = false
            wordPhoneticButton.hidden = false
        } else {
            wordPhoneticSymbolLabel.hidden = true
            wordPhoneticButton.hidden = true
        }
        
        wordPhoneticSymbolLabel.sizeToFit()
        wordPhoneticButton.frame = CGRect(x: viewLearnWordPage.frame.width / 2 - (wordPhoneticButton.frame.width + wordPhoneticSymbolLabel.frame.width + 24) / 2, y: wordPhoneticButton.frame.origin.y, width: wordPhoneticButton.frame.width, height: wordPhoneticButton.frame.height)
        wordPhoneticSymbolLabel.frame = CGRect(x: wordPhoneticButton.frame.origin.x + wordPhoneticButton.frame.width, y: wordPhoneticSymbolLabel.frame.origin.y, width: wordPhoneticSymbolLabel.frame.width, height: wordPhoneticSymbolLabel.frame.height)
        
        voiceIcon.frame = CGRect(x: wordPhoneticSymbolLabel.frame.origin.x + wordPhoneticSymbolLabel.frame.width, y: wordPhoneticButton.frame.origin.y, width: 24, height: 24)
        voiceIcon.hidden = wordPhoneticSymbolLabel.hidden
        voiceIcon.backgroundColor = UIColor(patternImage: UIImage(named: "voice.png")!)
        
        var shouldAutoVoice = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.WORD_AUTO_VOICE) as? Bool
        if (shouldAutoVoice != nil && shouldAutoVoice! && self.pageMode != 4) {
            self.playVoice()
        }
    }
    
    func playVoice() {
        if (self.word == nil) {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            self.player = nil
            var type = self.wordPhoneticType()
            var word = self.word!["word"] as String
            if (type == "us" && (self.word!["usPronunciation"]? as? String) != nil) {
                var filename = Util.getCacheFilePath("us_\(word).mp3")
                var data = NSData(contentsOfFile: filename)
                
                if (data == nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    data = NSData(contentsOfURL: Util.getVoiceURL(self.word!["usPronunciation"] as String))
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
                
                if (data != nil) {
                    self.player = AVAudioPlayer(data: data, error: nil)
                    self.player.delegate = self
                    data!.writeToFile(filename, atomically: true)
                }
            }
            
            if (type == "uk" && self.word!["ukPronunciation"]? as? String != nil) {
                var filename = Util.getCacheFilePath("uk_\(word).mp3")
                var data = NSData(contentsOfFile: filename)
                
                if (data == nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    data = NSData(contentsOfURL: Util.getVoiceURL(self.word!["ukPronunciation"] as String))
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
                
                if (data != nil) {
                    self.player = AVAudioPlayer(data: data, error: nil)
                    self.player.delegate = self
                    data!.writeToFile(filename, atomically: true)
                }
            }
            
            if (self.player != nil) {
                self.player.play()
            }
        })
    }
    
    func playSentence() {
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            if (self.sentences.count > 0) {
                var url = self.sentences![self.currentSentenceIndex]["voice"] as? String
                if (url != nil) {
                    var filename = Util.getCacheFilePath(self.sentences![self.currentSentenceIndex]["id"] as String + ".mp3")
                    var data = NSData(contentsOfFile: filename)
                    
                    if (data == nil) {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                        data = NSData(contentsOfURL: Util.getVoiceURL(url!))
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                    
                    if (data != nil) {
                        self.player = AVAudioPlayer(data: data, error: nil)
                        self.player.delegate = self
                        self.player.play()
                        data!.writeToFile(filename, atomically: true)
                    }
                }
            }
        })
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.player = nil
    }
    
    func error(error: Error, api: String) {
        self.endLoading()
    }
}