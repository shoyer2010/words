//  LearnWordController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

class WordDetailController: UIViewController, APIDataDelegate, AVAudioPlayerDelegate {
    var delegate: WordDetailDelegate?
    var searchWord: String?
    var player: AVAudioPlayer!
    var voiceUS: NSURL?
    var voiceUK: NSURL?
    
    var indicator: UIActivityIndicatorView!
    var wordScrollView: UIScrollView!
    
    var word: AnyObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = self.delegate!.frameOfView()
        self.searchWord = self.delegate!.searchWord()
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60))
        indicator.color = Color.red
        self.view.addSubview(indicator)
        
        if (self.delegate!.shoudRegisterNotification != nil && self.delegate!.shoudRegisterNotification!()) {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageChange:", name: EventKey.ON_PAGE_CHAGNE, object: nil)
        }
        
        self.view.backgroundColor = Color.appBackground
        wordScrollView = UIScrollView(frame: self.view.frame)
        self.view.addSubview(wordScrollView)
        
        if (self.delegate!.shoudRegisterNotification == nil) {
            loadData()
        }
    }
    
    func wordSearch(data: AnyObject) {
        self.word = data
        self.setToView(data)
        self.endLoading()
    }
    
    func setToView(data: AnyObject) {
        var headView:UILabel = UILabel(frame: CGRect(x: 15, y: 10, width: self.wordScrollView.frame.width - 30, height: 40))
        headView.text = data["word"] as? String
        headView.font = UIFont(name: headView.font.fontName, size: 30)
        self.wordScrollView.addSubview(headView)
        
        if (data["word"] as? String != nil) {
            var addToCustomDictionaryButton = UIButton(frame: CGRect(x: self.wordScrollView.frame.width - 45, y: 15, width: 30, height: 30))
            addToCustomDictionaryButton.backgroundColor = Color.red
            addToCustomDictionaryButton.addTarget(self, action: "onaddToCustomDictionaryButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.wordScrollView.addSubview(addToCustomDictionaryButton)
        }
        
        var tagsLabel = UILabel(frame: CGRect(x: 15, y: headView.frame.origin.y + headView.frame.height + 5, width: self.wordScrollView.frame.width - 30, height: 0))
        tagsLabel.numberOfLines = 0
        var tagsArray = data["tags"] as? NSArray
        if (tagsArray != nil && tagsArray!.count > 0) {
            var tags: String = ""
            var tagsArray = data["tags"] as NSArray
            for tag in tagsArray {
                tags += (tag as String) + " "
            }
            tagsLabel.text = tags
            var paragraphStyleForTags = NSMutableParagraphStyle()
            paragraphStyleForTags.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyleForTags.alignment = NSTextAlignment.Left
            paragraphStyleForTags.paragraphSpacing = 1
            paragraphStyleForTags.lineSpacing = 2
            var attributesForTags = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyleForTags,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(14)),
                NSForegroundColorAttributeName: Color.black,
                NSStrokeWidthAttributeName: NSNumber(float: -2.0)
                ])
            tagsLabel.attributedText =  NSAttributedString(string: tagsLabel.text!, attributes: attributesForTags)
            tagsLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(tagsLabel)
        
        
        var phoneticSymbolUSLabel = UILabel(frame: CGRect(x: 15, y: tagsLabel.frame.origin.y + tagsLabel.frame.height + 10, width: 0, height: 0))
        phoneticSymbolUSLabel.numberOfLines = 0
        var phoneticSymbolUS = data["phoneticSymbolUS"] as? String
        if (phoneticSymbolUS != nil) {
            phoneticSymbolUSLabel.text = "美" + phoneticSymbolUS!
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(14)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -2.0)
                ])
            phoneticSymbolUSLabel.attributedText =  NSAttributedString(string: phoneticSymbolUSLabel.text!, attributes: attributes)
            phoneticSymbolUSLabel.sizeToFit()
            
            
            if (data["usPronunciation"] as? String != nil) {
                var voiceIcon = UIButton(frame: CGRect(x: phoneticSymbolUSLabel.frame.origin.x + phoneticSymbolUSLabel.frame.width, y: phoneticSymbolUSLabel.frame.origin.y - 2, width: 24, height: 24))
                voiceIcon.backgroundColor = Color.red
                voiceIcon.addTarget(self, action: "usVoice:", forControlEvents: UIControlEvents.TouchUpInside)
                self.wordScrollView.addSubview(voiceIcon)
                self.voiceUS = Util.getVoiceURL(data["usPronunciation"] as String)
            }
        }
        self.wordScrollView.addSubview(phoneticSymbolUSLabel)
        
        var phoneticSymbolUKLabel = UILabel(frame: CGRect(x: self.wordScrollView.frame.width / 2, y: tagsLabel.frame.origin.y + tagsLabel.frame.height + 10, width: 0, height: 0))
        phoneticSymbolUKLabel.numberOfLines = 0
        var phoneticSymbolUK = data["phoneticSymbolUK"] as? String
        if (phoneticSymbolUK != nil) {
            phoneticSymbolUKLabel.text = "英" + phoneticSymbolUK!
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(14)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -2.0)
                ])
            phoneticSymbolUKLabel.attributedText =  NSAttributedString(string: phoneticSymbolUKLabel.text!, attributes: attributes)
            phoneticSymbolUKLabel.sizeToFit()
            
            if (data["ukPronunciation"] as? String != nil) {
                var voiceIcon = UIButton(frame: CGRect(x: phoneticSymbolUKLabel.frame.origin.x + phoneticSymbolUKLabel.frame.width, y: phoneticSymbolUKLabel.frame.origin.y - 2, width: 24, height: 24))
                voiceIcon.backgroundColor = Color.red
                voiceIcon.addTarget(self, action: "ukVoice:", forControlEvents: UIControlEvents.TouchUpInside)
                self.voiceUK = Util.getVoiceURL(data["ukPronunciation"] as String)
                self.wordScrollView.addSubview(voiceIcon)
            }
        }
        self.wordScrollView.addSubview(phoneticSymbolUKLabel)
        
        var chineseLabel = UILabel(frame: CGRect(x: 15, y: phoneticSymbolUSLabel.frame.origin.y + phoneticSymbolUSLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        chineseLabel.numberOfLines = 0
        if ((data["chinese"] as? NSDictionary) != nil) {
            var chinese: String = "\n"
            var chineseDictionary = data["chinese"] as NSDictionary
            for (key, value) in chineseDictionary {
                chinese += (key as String) + ". " + (value as String) + "\n"
            }
            chineseLabel.text = chinese
            var paragraphStyleForChinese = NSMutableParagraphStyle()
            paragraphStyleForChinese.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyleForChinese.alignment = NSTextAlignment.Left
            paragraphStyleForChinese.paragraphSpacing = 1
            paragraphStyleForChinese.lineSpacing = 2
            var attributesForChinese = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyleForChinese,
                NSFontAttributeName: UIFont(name: Fonts.kaiti, size: CGFloat(17))!,
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -1.5)
                ])
            chineseLabel.attributedText =  NSAttributedString(string: chineseLabel.text!, attributes: attributesForChinese)
            chineseLabel.sizeToFit()
        }
        wordScrollView.addSubview(chineseLabel)
        
        var pluralityLabel = UILabel(frame: CGRect(x: 15, y: chineseLabel.frame.origin.y + chineseLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        pluralityLabel.numberOfLines = 0
        var plurality = data["plurality"] as? String
        if (plurality != nil) {
            pluralityLabel.text = "复数: " + plurality!
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(15)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -3.5)
                ])
            pluralityLabel.attributedText =  NSAttributedString(string: pluralityLabel.text!, attributes: attributes)
            pluralityLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(pluralityLabel)
        
        var pastLabel = UILabel(frame: CGRect(x: 15, y: pluralityLabel.frame.origin.y + pluralityLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        pastLabel.numberOfLines = 0
        var past = data["past"] as? String
        if (past != nil) {
            pastLabel.text = "过去式: " + past!
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(15)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -3.5)
                ])
            pastLabel.attributedText =  NSAttributedString(string: pastLabel.text!, attributes: attributes)
            pastLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(pastLabel)
        
        var pastParticipleLabel = UILabel(frame: CGRect(x: 15, y: pastLabel.frame.origin.y + pastLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        pastParticipleLabel.numberOfLines = 0
        var pastParticiple = data["pastParticiple"] as? String
        if (pastParticiple != nil) {
            pastParticipleLabel.text = "过去分词: " + pastParticiple!
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(15)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -3.5)
                ])
            pastParticipleLabel.attributedText =  NSAttributedString(string: pastParticipleLabel.text!, attributes: attributes)
            pastParticipleLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(pastParticipleLabel)
        
        var presentParticipleLabel = UILabel(frame: CGRect(x: 15, y: pastParticipleLabel.frame.origin.y + pastParticipleLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        presentParticipleLabel.numberOfLines = 0
        var presentParticiple = data["presentParticiple"] as? String
        if (pastParticiple != nil) {
            presentParticipleLabel.text = "现在分词: " + presentParticiple!
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(15)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -3.5)
                ])
            presentParticipleLabel.attributedText =  NSAttributedString(string: presentParticipleLabel.text!, attributes: attributes)
            presentParticipleLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(presentParticipleLabel)
        
        var thirdSingleLabel = UILabel(frame: CGRect(x: 15, y: presentParticipleLabel.frame.origin.y + presentParticipleLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        thirdSingleLabel.numberOfLines = 0
        var thirdSingle = data["thirdSingle"] as? String
        if (thirdSingle != nil) {
            thirdSingleLabel.text = "第三人称单数: " + thirdSingle!
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 1
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(15)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -3.5)
                ])
            thirdSingleLabel.attributedText =  NSAttributedString(string: thirdSingleLabel.text!, attributes: attributes)
            thirdSingleLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(thirdSingleLabel)
        
        
        var phrasesLabel = UILabel(frame: CGRect(x: 15, y: thirdSingleLabel.frame.origin.y + thirdSingleLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        phrasesLabel.numberOfLines = 0
        var phrasesArray = data["phrases"] as? NSArray
        if (phrasesArray != nil && phrasesArray!.count > 0) {
            var phrases: String = "\n"
            for phrase in phrasesArray! {
                phrases += (phrase["english"] as String) + "  " + (phrase["chinese"] as String) + "\n"
            }
            phrasesLabel.text = phrases
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 6
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(13)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -1.0)
                ])
            phrasesLabel.attributedText =  NSAttributedString(string: phrasesLabel.text!, attributes: attributes)
            phrasesLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(phrasesLabel)
        
        var sentencesLabel = UILabel(frame: CGRect(x: 15, y: phrasesLabel.frame.origin.y + phrasesLabel.frame.height, width: self.wordScrollView.frame.width - 30, height: 0))
        sentencesLabel.numberOfLines = 0
        var sentencesArray = data["sentences"] as? NSArray
        if (sentencesArray != nil && sentencesArray!.count > 0) {
            var sentences: String = "\n"
            for sentence in sentencesArray! {
                sentences += (sentence["english"] as String)
                if (sentence["chinese"] as? String != nil) {
                    sentences += "\n" + (sentence["chinese"] as String) + "\n\n"
                } else {
                    sentences += "\n\n"
                }
            }
            sentencesLabel.text = sentences
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            paragraphStyle.paragraphSpacing = 2
            paragraphStyle.lineSpacing = 2
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(13)),
                NSForegroundColorAttributeName: Color.gray,
                NSStrokeWidthAttributeName: NSNumber(float: -1.0)
                ])
            sentencesLabel.attributedText =  NSAttributedString(string: sentencesLabel.text!, attributes: attributes)
            sentencesLabel.sizeToFit()
        }
        self.wordScrollView.addSubview(sentencesLabel)
        
        
        
        wordScrollView.contentSize = CGSize(width: wordScrollView.frame.width, height:sentencesLabel.frame.origin.y + sentencesLabel.frame.height)
    }
    
    func onPageChange(notification: NSNotification) {
        if (PageCode(rawValue: notification.userInfo?["currentPage"] as Int) == PageCode.WordDetail) {
            loadData()
        }
    }
    
    func onaddToCustomDictionaryButtonTapped(sender: UIButton) {
        Word.addToCustomDictionary(self.word)
        SuccessView(view: self.view, message: "已加入生词本")
    }
    
    func loadData() {
        var params = NSMutableDictionary()
        params.setValue(self.searchWord, forKey: "word")
        API.instance.get("/word/search", delegate: self, params: params)
        self.startLoading()
    }
    
    func startLoading() {
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
    }
    
    func endLoading() {
        self.indicator.stopAnimating()
    }
    
    
    func usVoice(sender: UIButton) {
        if (self.voiceUS != nil) {
            self.playVoice(self.voiceUS!)
        }
    }
    
    func ukVoice(sender: UIButton) {
        if (self.voiceUK != nil) {
            self.playVoice(self.voiceUK!)
        }
    }
    
    func playVoice(url: NSURL) {
        player = AVAudioPlayer(data: NSData(contentsOfURL: url), error: nil)
        player.play()
    }
    
    func error(error: Error, api: String) {
        self.endLoading()
        var view = UIView(frame: CGRect(x: 0, y: 22, width: self.view.frame.width, height: 25))
        self.view.addSubview(view)
        ErrorView(view: view, message: error.getMessage(),completion: {() in
            view.removeFromSuperview()
        })
    }
}