
import Foundation
import UIKit

class DictionaryInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, APIDataDelegate {
    var subView: UIView!
    var tableView: UITableView!
    var learnButton: UIButton!
    var editButton: UIButton!
    var deleteButton: UIButton!
    var subViewHeight: CGFloat = 0
    var delegate: DictionaryInfoDelegate!
    var dictionary: AnyObject?
    var words: NSMutableArray = NSMutableArray()
    
    var progressView: UAProgressView!
    
    var queue: dispatch_queue_t?
    var showing: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        var tapViewHeight = CGFloat(120)
        self.subViewHeight = self.view.frame.height - tapViewHeight
        
        var tapViewToCloseView = UIView(frame: CGRect(x: 0, y: self.subViewHeight, width: self.view.frame.width, height: tapViewHeight))
        tapViewToCloseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        self.view.addSubview(tapViewToCloseView)
        
        self.subView = UIView(frame: CGRect(x: 0, y: -self.subViewHeight, width: self.view.frame.width, height: self.subViewHeight))
        self.subView.backgroundColor = Color.white.colorWithAlphaComponent(0.89)
        self.subView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.subView)
        
        progressView = UAProgressView()
        progressView.frame = CGRect(x: self.subView.frame.width / 2 - 35, y: self.subView.frame.height / 2 - 50, width: 70, height: 70)
        progressView.lineWidth = 2
        progressView.tintColor = Color.red
        
        var percentView = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        percentView.text = ""
        percentView.textAlignment = NSTextAlignment.Center
        percentView.font = UIFont.systemFontOfSize(14)
        percentView.textColor = Color.white
        percentView.backgroundColor = Color.red
        percentView.layer.cornerRadius = 20
        percentView.layer.opacity = 0.9
        percentView.layer.masksToBounds = true
        progressView.centralView = percentView
        self.view.addSubview(progressView)
        
        var tableViewWrap = UIView(frame: CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: self.subView.frame.height - 70))
        tableViewWrap.backgroundColor = Color.blockBackground
        tableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        tableViewWrap.layer.shadowOffset = Layer.shadowOffset
        tableViewWrap.layer.shadowColor = Layer.shadowColor
        tableViewWrap.layer.shadowRadius = Layer.shadowRadius
        tableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        var tableHeader = UIView(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: 30))
        tableHeader.backgroundColor = Color.red.colorWithAlphaComponent(0.95)
        
        var wordLabel = UILabel(frame: CGRect(x:  10, y: 0, width: 100, height: 30))
        wordLabel.text = "单词"
        wordLabel.textColor = Color.white
        wordLabel.textAlignment = NSTextAlignment.Left
        wordLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(wordLabel)
        
        var appearCountLabel = UILabel(frame: CGRect(x:  100, y: 0, width: (tableHeader.frame.width - 100) * 0.25, height: 30))
        appearCountLabel.text = "出现"
        appearCountLabel.textColor = Color.white
        appearCountLabel.textAlignment = NSTextAlignment.Center
        appearCountLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(appearCountLabel)
        
        var wrongCountLabel = UILabel(frame: CGRect(x:  100 + (tableHeader.frame.width - 100) * 0.25, y: 0, width: (tableHeader.frame.width - 100) * 0.25, height: 30))
        wrongCountLabel.text = "错误"
        wrongCountLabel.textColor = Color.white
        wrongCountLabel.textAlignment = NSTextAlignment.Center
        wrongCountLabel.font = UIFont(name: wrongCountLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(wrongCountLabel)
        
        var timeCountLabel = UILabel(frame: CGRect(x:  100 + (tableHeader.frame.width - 100) * 0.5, y: 0, width: (tableHeader.frame.width - 100) * 0.25, height: 30))
        timeCountLabel.text = "反应(秒)"
        timeCountLabel.textColor = Color.white
        timeCountLabel.textAlignment = NSTextAlignment.Center
        timeCountLabel.font = UIFont(name: timeCountLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(timeCountLabel)
        
        var haveMasteredLabel = UILabel(frame: CGRect(x:  100 + (tableHeader.frame.width - 100) * 0.75, y: 0, width: (tableHeader.frame.width - 100) * 0.25, height: 30))
        haveMasteredLabel.text = "掌握"
        haveMasteredLabel.textColor = Color.white
        haveMasteredLabel.textAlignment = NSTextAlignment.Center
        haveMasteredLabel.font = UIFont(name: haveMasteredLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(haveMasteredLabel)
        tableViewWrap.addSubview(tableHeader)
        
        self.tableView = UITableView(frame: CGRect(x: 6, y: 36, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 42))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.cornerRadius = Layer.cornerRadius
        self.tableView.layer.masksToBounds = true
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        if (self.tableView.respondsToSelector("setLayoutMargins:")) {
            self.tableView.layoutMargins = UIEdgeInsetsZero
        }
        
        tableViewWrap.addSubview(self.tableView)
        
        tableViewWrap.bringSubviewToFront(tableHeader)
        
        self.subView.addSubview(tableViewWrap)
        
        learnButton = UIButton(frame: CGRect(x: tableViewWrap.frame.origin.x, y: self.subView.frame.height - 40, width: (tableViewWrap.frame.width - 40) / 3, height: 32))
        learnButton.backgroundColor = Color.gray
        learnButton.userInteractionEnabled = false
        learnButton.alpha = 0.5
        learnButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        learnButton.addTarget(self, action: "onLearnButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        learnButton.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        learnButton.addTarget(self, action: "onTouchUp:", forControlEvents: UIControlEvents.TouchUpOutside | UIControlEvents.TouchUpInside)
        self.subView.addSubview(learnButton)
        
        
        self.dictionary = DictionaryUtil.getDictionaryInfo(self.delegate.setDictionaryId())
        
        if (self.dictionary != nil && self.dictionary!["custom"] as Bool) {
            if ((NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_CUSTOM_DICTIONARY) as? String ) != nil) {
                learnButton.setTitle("不学习", forState: UIControlState.Normal)
            } else {
                learnButton.setTitle("学 习", forState: UIControlState.Normal)
            }
        }
        
        if (self.dictionary != nil && !(self.dictionary!["custom"] as Bool)) {
            var dictionaryId = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_DICTIONARY) as? String
            if (dictionaryId != nil && dictionaryId! == self.dictionary!["id"] as String) {
                learnButton.setTitle("不学习", forState: UIControlState.Normal)
            } else{
                learnButton.setTitle("学 习", forState: UIControlState.Normal)
            }
        }
        
        editButton = UIButton(frame: CGRect(x: learnButton.frame.origin.x + learnButton.frame.width + 20, y: self.subView.frame.height - 40, width: (tableViewWrap.frame.width - 40) / 3, height: 32))
        editButton.setTitle("编 辑", forState: UIControlState.Normal)
        editButton.userInteractionEnabled = false
        editButton.alpha = 0.5
        editButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        editButton.backgroundColor = Color.gray
        editButton.addTarget(self, action: "onEditButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        editButton.addTarget(self, action: "onTouchUp:", forControlEvents: UIControlEvents.TouchUpOutside | UIControlEvents.TouchUpInside)
        self.subView.addSubview(editButton)
        
        deleteButton = UIButton(frame: CGRect(x: editButton.frame.origin.x + editButton.frame.width + 20, y: self.subView.frame.height - 40, width: (tableViewWrap.frame.width - 40) / 3, height: 32))
        deleteButton.setTitle("删 除", forState: UIControlState.Normal)
        deleteButton.backgroundColor = Color.red
        deleteButton.userInteractionEnabled = false
        deleteButton.alpha = 0.5
        deleteButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        deleteButton.addTarget(self, action: "onDeleteButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.subView.addSubview(deleteButton)
        
        if (self.dictionary != nil && (self.dictionary!["custom"] as Bool)) {
            deleteButton.userInteractionEnabled = false
            deleteButton.layer.opacity = 0.5
        }
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
                self.prepareWords()
        }
    }
    
    func onTouchDown(sender: UIButton) {
        sender.backgroundColor = Color.red
    }
    
    func onTouchUp(sender: UIButton) {
        sender.backgroundColor = Color.gray
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.progressView.hidden = true
        self.closeView()
    }
    
    func closeView() {
        self.showing = false
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, -self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    func onEditButtonTapped(sender: UIButton) {
        if (self.tableView.editing) {
            self.tableView.setEditing(false, animated: true)
            self.editButton.setTitle("编 辑", forState: UIControlState.Normal)
        } else {
            self.tableView.setEditing(true, animated: true)
            self.editButton.setTitle("完 成", forState: UIControlState.Normal)
        }
    }
    
    
    func onDeleteButtonTapped(sender: UIButton) {
        var alertView = UIAlertView(title: "删除词库", message: "同时将会删除与词库相关的学习记录，好处是会释放一些存储空间，您坚信要删除吗？", delegate: self, cancelButtonTitle: "不删了")
        alertView.addButtonWithTitle("无比坚信")
        alertView.delegate = self
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0) {
            return
        }
        
        if (buttonIndex == 1) {
            Util.deleteFile(self.delegate.setDictionaryId() + ".db")
            var learingDictionaryId = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_DICTIONARY) as? String
            if (learingDictionaryId == self.delegate.setDictionaryId()) {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.LEARNING_DICTIONARY)
            }
            
            var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
            var userId = user!["id"] as String
            
            var dbUser = Database(Util.getFilePath(userId + ".db"))
            dbUser.prepare("DELETE FROM learningProgress WHERE dictionaryId=?", self.delegate.setDictionaryId()).run()
            
            var info = NSMutableDictionary()
            info.setValue(self.delegate.setDictionaryId(), forKey: "id")
            NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_DICTIONARY_DELETED, object: self, userInfo: info)
            self.closeView()
        }
    }
    
    func onLearnButtonTapped(sender: UIButton) {
        if (self.dictionary != nil && (self.dictionary!["custom"] as Bool)) {
            if ((NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_CUSTOM_DICTIONARY) as? String ) != nil) {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.LEARNING_CUSTOM_DICTIONARY)
                NSUserDefaults.standardUserDefaults().synchronize()
                NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_LEARNING_DICTIONARY_CHANGED, object: self, userInfo: nil)
                self.closeView()
            } else{
                self.progressView.hidden = false
                self.learnButton.alpha = 0.5
                self.learnButton.userInteractionEnabled = false
                self.deleteButton.alpha = 0.5
                self.deleteButton.userInteractionEnabled = false
                self.editButton.alpha = 0.5
                self.editButton.userInteractionEnabled = false
                DictionaryUtil.importDataToLearingProcess(self.delegate.setDictionaryId(), progressCallback: {(progress) -> Bool in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.progressView.setProgress(CGFloat(progress), animated: true)
                        (self.progressView.centralView as UILabel).text = "\(Int(progress * 100))%"
                        if (progress >= 1) {
                            NSUserDefaults.standardUserDefaults().setObject(self.delegate.setDictionaryId(), forKey: CacheKey.LEARNING_CUSTOM_DICTIONARY)
                            NSUserDefaults.standardUserDefaults().synchronize()
                            NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_LEARNING_DICTIONARY_CHANGED, object: self, userInfo: nil)
                            self.closeView()
                        }
                    })
                    
                    
                    return !self.showing
                })
            }
        }
        
        if (self.dictionary != nil && !(self.dictionary!["custom"] as Bool)) {
            var dictionaryId = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.LEARNING_DICTIONARY) as? String
            if (dictionaryId != nil && dictionaryId! == self.dictionary!["id"] as String) {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(CacheKey.LEARNING_DICTIONARY)
                NSUserDefaults.standardUserDefaults().synchronize()
                NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_LEARNING_DICTIONARY_CHANGED, object: self, userInfo: nil)
                self.closeView()
            } else{
                self.progressView.hidden = false
                self.learnButton.alpha = 0.5
                self.learnButton.userInteractionEnabled = false
                self.deleteButton.alpha = 0.5
                self.deleteButton.userInteractionEnabled = false
                self.editButton.alpha = 0.5
                self.editButton.userInteractionEnabled = false
                DictionaryUtil.importDataToLearingProcess(self.delegate.setDictionaryId(), progressCallback: {(progress) -> Bool in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.progressView.setProgress(CGFloat(progress), animated: true)
                        (self.progressView.centralView as UILabel).text = "\(Int(progress * 100))%"
                        if (progress >= 1) {
                            NSUserDefaults.standardUserDefaults().setObject(self.delegate.setDictionaryId(), forKey: CacheKey.LEARNING_DICTIONARY)
                            NSUserDefaults.standardUserDefaults().synchronize()
                            NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_LEARNING_DICTIONARY_CHANGED, object: self, userInfo: nil)
                            self.closeView()
                        }
                    })
                    
                    return !self.showing
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(30)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.words.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (UITableViewCellEditingStyle.Delete == editingStyle) {
            DictionaryUtil.deleteWordFromDictionary(self.delegate.setDictionaryId(), wordId: self.words[indexPath.row]["id"] as String, delegate: self)
            self.words.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        }
    }
    
    func dictionaryCustomWord(data: AnyObject, params: NSMutableDictionary) {
        var wordId = params["id"] as String
        var type = params["type"] as Int
        
        var customDictionayId = DictionaryUtil.customDictionaryId()
        var db = Database(Util.getFilePath(customDictionayId + ".db"))
        db.prepare("DELETE FROM operationLogs WHERE wordId=? and wordStatus=?", wordId, type).run()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var wordLabelTag = 1001
        var appearCountLabelTag = 1002
        var wrongLabelTag = 1003
        var timeLabellTag = 1004
        var haveMasteredLabelTag = 1005
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell!.separatorInset = UIEdgeInsetsZero
            
            if (cell!.respondsToSelector("setLayoutMargins:")) {
                cell!.layoutMargins = UIEdgeInsetsZero
            }
            
            var wordLabel = UILabel(frame: CGRect(x: 10, y: 3, width: 100, height: 24))
            wordLabel.tag = wordLabelTag
            wordLabel.text = "what"
            wordLabel.textColor = Color.gray
            wordLabel.textAlignment = NSTextAlignment.Left
            wordLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(12))
            cell!.contentView.addSubview(wordLabel)
            
            var appearCountLabel = UILabel(frame: CGRect(x: 100, y: 0, width: (tableView.frame.width - 100) * 0.25, height: 30))
            appearCountLabel.tag = appearCountLabelTag
            appearCountLabel.text = "23"
            appearCountLabel.textColor = Color.gray
            appearCountLabel.font = UIFont(name: appearCountLabel.font.fontName, size: CGFloat(14))
            appearCountLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(appearCountLabel)
            
            var wrongLabel = UILabel(frame: CGRect(x: 100 + (tableView.frame.width - 100) * 0.25, y: 0, width: (tableView.frame.width - 100) * 0.25, height: 30))
            wrongLabel.tag = wrongLabelTag
            wrongLabel.text = "12"
            wrongLabel.textColor = Color.gray
            wrongLabel.font = UIFont(name: wrongLabel.font.fontName, size: CGFloat(14))
            wrongLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(wrongLabel)
            
            var timeLabel = UILabel(frame: CGRect(x: 100 + (tableView.frame.width - 100) * 0.5, y: 0, width: (tableView.frame.width - 100) * 0.25, height: 30))
            timeLabel.tag = timeLabellTag
            timeLabel.text = "12.12"
            timeLabel.textColor = Color.gray
            timeLabel.font = UIFont(name: timeLabel.font.fontName, size: CGFloat(14))
            timeLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(timeLabel)
            

            
            var haveMasteredLabel = UILabel(frame: CGRect(x: 100 + (tableView.frame.width - 100) * 0.75, y: 0, width: (tableView.frame.width - 100) * 0.25, height: 30))
            haveMasteredLabel.tag = haveMasteredLabelTag
            haveMasteredLabel.text = "√"
            haveMasteredLabel.textColor = Color.green
            haveMasteredLabel.font = UIFont(name: haveMasteredLabel.font.fontName, size: CGFloat(14))
            haveMasteredLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(haveMasteredLabel)
        }
        
        var wordLabel = cell!.viewWithTag(wordLabelTag) as UILabel
        wordLabel.text = self.words[indexPath.row]["word"] as? String
        
        var appearCountLabel = cell!.viewWithTag(appearCountLabelTag) as UILabel
        var appearCount = self.words[indexPath.row]["appearTimes"] as? Int
        if (appearCount != nil) {
            appearCountLabel.text = "\(appearCount!)"
        } else {
            appearCountLabel.text = "-"
        }
        
        var wrongLabel = cell!.viewWithTag(wrongLabelTag) as UILabel
        var rightTimes = self.words[indexPath.row]["rightTimes"] as? Int
        if (rightTimes != nil) {
            wrongLabel.text = "\(appearCount! - rightTimes!)"
        } else {
            wrongLabel.text = "-"
        }
        
        var timeLabel = cell!.viewWithTag(timeLabellTag) as UILabel
        var rightSeconds = self.words[indexPath.row]["rightSeconds"] as? Float
        if (rightSeconds != nil && rightSeconds > 0 && rightTimes > 0) {
            var averageTime = rightSeconds! / Float(rightTimes!)
            timeLabel.text = NSString(format: "%.2f", averageTime)
        } else {
            timeLabel.text = "-"
        }
        
        
        var haveMasteredLabel = cell!.viewWithTag(haveMasteredLabelTag) as UILabel
        var wordStatus = self.words[indexPath.row]["wordStatus"] as? Int
        if (wordStatus == nil) {
            haveMasteredLabel.text = "-"
            haveMasteredLabel.textColor = Color.gray
        } else if (wordStatus == 6) {
            haveMasteredLabel.text = "√"
            haveMasteredLabel.textColor = Color.green
        } else {
            haveMasteredLabel.text = "X"
            haveMasteredLabel.textColor = Color.red
        }
        
        return cell!
    }
    
    func prepareWords() {
        self.dictionary = DictionaryUtil.getDictionaryInfo(self.delegate.setDictionaryId())
        var db = Database(Util.getFilePath(self.delegate.setDictionaryId() + ".db"))
        
        var totalCount = 0
        for row in db.prepare("SELECT count(rowid) FROM words") {
            totalCount = row[0] as Int
        }
        
        var sql = "SELECT id, word FROM words"
        if (self.dictionary!["custom"] as Bool) {
            sql = "SELECT id, word FROM words ORDER BY rowid desc"
        }
        
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER)
        var userId = user!["id"] as String
        var dbUser = Database(Util.getFilePath(userId + ".db"))
        var i = 1
        
        self.queue = dispatch_queue_create("queueForDictionaryInfo", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(self.queue!, { () -> Void in
            self.view.bringSubviewToFront(self.progressView)
            
            for row in db.prepare(sql) {
                var word = NSMutableDictionary()
                word.setValue(row[0] as String, forKey: "id")
                word.setValue(row[1] as String, forKey: "word")
                
                for row2 in dbUser.prepare("SELECT wordStatus, appearTimes, rightTimes, rightSeconds FROM learningProgress WHERE dictionaryId=? AND wordId=?", self.delegate.setDictionaryId(), row[0] as String) {
                    word.setValue(row2[0] as Int, forKey: "wordStatus")
                    word.setValue(row2[1] as Int, forKey: "appearTimes")
                    word.setValue(row2[2] as Int, forKey: "rightTimes")
                    word.setValue(((row2[3] as String) as NSString).floatValue, forKey: "rightSeconds")
                }
                
                self.words.addObject(word)
                
                var progress = Float(i) / Float(totalCount)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressView.setProgress(CGFloat(progress), animated: true)
                    (self.progressView.centralView as UILabel).text = "\(Int(progress * 100))%"
                })
                i++
                
                if (!self.showing) {
                    break
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.progressView.hidden = true
                self.tableView.reloadData()
                self.editButton.alpha = 1
                self.editButton.userInteractionEnabled = true
                self.learnButton.alpha = 1
                self.learnButton.userInteractionEnabled = true
                
                if (self.dictionary != nil && !(self.dictionary!["custom"] as Bool)) {
                    self.deleteButton.userInteractionEnabled = true
                    self.deleteButton.alpha = 1
                }
            })
        })
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("DictionaryInfoController")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("DictionaryInfoController")
    }
}