import UIKit

class DictionaryController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIDataDelegate, DictionaryInfoDelegate {

    var commonTableView: UITableView!
    var commonTableViewSelectedRow: Int?
    var dictionaryNameLabelTag = 1000
    var countLabelTag = 1001
    var popularLabelTag = 1002
    var sizeLabelTag = 1003
    var selectedSegmentIndex: Int = 0
    var myCurrentDictionaryLabel: UILabel!
    
    var dictionaryList: NSArray!
    var generalDictionaryList: NSMutableArray!
    var professionalDictionaryList: NSMutableArray!
    var specialDictionaryList: NSMutableArray!
    
    var selectedDictionaryId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoginSuccess:", name: EventKey.ON_LOGIN_SUCCESS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDictionaryDeleted:", name: EventKey.ON_DICTIONARY_DELETED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLearingDictionaryChanged:", name: EventKey.ON_LEARNING_DICTIONARY_CHANGED, object: nil)
        
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(2)
        self.view.backgroundColor = Color.appBackground
        
        var segment = UISegmentedControl(frame: CGRect(x: self.view.frame.width / 2 - 65, y: 15, width: 130, height: 26))
        segment.backgroundColor = UIColor.whiteColor()
        segment.tintColor = Color.red
        segment.insertSegmentWithTitle("常用", atIndex: 0, animated: false)
        segment.insertSegmentWithTitle("专业", atIndex: 1, animated: false)
        segment.insertSegmentWithTitle("特种", atIndex: 2, animated: false)
        segment.addTarget(self, action: "onSegmentTapped:", forControlEvents: UIControlEvents.ValueChanged)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        var tableViewWrap = UIView(frame: CGRect(x: 15, y: 55, width: self.view.frame.width - 30, height: self.view.frame.height - 85))
        tableViewWrap.backgroundColor = Color.blockBackground
        tableViewWrap.layer.shadowOpacity = Layer.shadowOpacity
        tableViewWrap.layer.shadowOffset = Layer.shadowOffset
        tableViewWrap.layer.shadowColor = Layer.shadowColor
        tableViewWrap.layer.shadowRadius = Layer.shadowRadius
        tableViewWrap.layer.cornerRadius = Layer.cornerRadius
        
        self.dictionaryList = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.DICTIONARY_LIST) as? NSArray
        self.groupDictionaryList()
        
        commonTableView = UITableView(frame: CGRect(x: 6, y: 6, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 12), style: UITableViewStyle.Plain)
        commonTableView.dataSource = self
        commonTableView.delegate = self
        commonTableView.layer.cornerRadius = Layer.cornerRadius
        commonTableView.separatorInset = UIEdgeInsets(top: 0, left: 0,  bottom: 0, right: 15)
        commonTableView.separatorInset = UIEdgeInsetsZero
        commonTableView.layoutMargins = UIEdgeInsetsZero
        tableViewWrap.addSubview(commonTableView)
        self.view.addSubview(tableViewWrap)
        
        
        var myCurrentDictionaryLabelWrap = UIView(frame: CGRectMake(15, self.view.frame.height - 22, self.view.frame.width - 30, 22))
        myCurrentDictionaryLabelWrap.layer.shadowOpacity = Layer.shadowOpacity
        myCurrentDictionaryLabelWrap.layer.shadowOffset = Layer.shadowOffset
        myCurrentDictionaryLabelWrap.layer.shadowColor = Layer.shadowColor
        myCurrentDictionaryLabelWrap.layer.shadowRadius = Layer.shadowRadius
        myCurrentDictionaryLabelWrap.layer.cornerRadius = Layer.cornerRadius
        myCurrentDictionaryLabelWrap.backgroundColor = Color.red
        
        myCurrentDictionaryLabel = UILabel(frame: CGRect(x: 5, y: 4, width: myCurrentDictionaryLabelWrap.frame.width, height: myCurrentDictionaryLabelWrap.frame.height))
        self.reloadMyCurrentLabel()
        myCurrentDictionaryLabelWrap.addSubview(myCurrentDictionaryLabel)
        self.view.addSubview(myCurrentDictionaryLabelWrap)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var homeController = self.parentViewController as HomeController
        
        if (offset < Interaction.offsetForChangePage) {
            homeController.scrollToPageUpAndDown(page: 0)
        }
    }
    
    func onSegmentTapped(sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        commonTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if (self.dictionaryList != nil) {
            switch self.selectedSegmentIndex {
            case 0:
                count = self.generalDictionaryList.count
            case 1:
                count = self.professionalDictionaryList.count
            case 2:
                count = self.specialDictionaryList.count
            default:
                break
            }
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("dictionaryCell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dictionaryCell")
            cell!.separatorInset = UIEdgeInsetsZero
            cell!.layoutMargins = UIEdgeInsetsZero
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            var selectedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            selectedView.tag = 999
            selectedView.backgroundColor = UIColor.clearColor()
            cell!.addSubview(selectedView)
            
            if (indexPath.row == 5) { // 当前正在学习词库的样式
                var selectedRow = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 40))
                selectedRow.backgroundColor = Color.red
                cell!.addSubview(selectedRow)
            }
            
            var dictionaryNameLabel = UILabel(frame: CGRect(x: 6, y: 6, width: tableView.frame.width * 0.6, height: 16))
            dictionaryNameLabel.tag = self.dictionaryNameLabelTag
            dictionaryNameLabel.text = "大学英语4级"
            dictionaryNameLabel.textAlignment = NSTextAlignment.Left
            dictionaryNameLabel.font = UIFont(name: dictionaryNameLabel.font.fontName, size: CGFloat(15))
            cell!.addSubview(dictionaryNameLabel)
            
            var countLabel = UILabel(frame: CGRect(x: 6, y: dictionaryNameLabel.frame.origin.y + dictionaryNameLabel.frame.height + 2, width: 100, height: 12))
            countLabel.tag = self.countLabelTag
            countLabel.text = "单词：0"
            countLabel.textColor = Color.lightGray
            countLabel.font = UIFont(name: countLabel.font.fontName, size: CGFloat(10))
            countLabel.textAlignment = NSTextAlignment.Left
            cell!.addSubview(countLabel)
            
            var popularLabel = UILabel(frame: CGRect(x: tableView.frame.width * 0.25, y: dictionaryNameLabel.frame.origin.y + dictionaryNameLabel.frame.height + 2, width: 100, height: 12))
            popularLabel.tag = self.popularLabelTag
            popularLabel.text = "人气：2323"
            popularLabel.textColor = Color.lightGray
            popularLabel.font = UIFont(name: popularLabel.font.fontName, size: CGFloat(10))
            popularLabel.textAlignment = NSTextAlignment.Left
            cell!.addSubview(popularLabel)
            
            var sizeLabel = UILabel(frame: CGRect(x: tableView.frame.width - 60, y: 8, width: 50, height: 24))
            sizeLabel.tag = self.sizeLabelTag
            sizeLabel.text = "32M"
            sizeLabel.textColor = Color.lightGray
            sizeLabel.font = UIFont(name: sizeLabel.font.fontName, size: CGFloat(12))
            sizeLabel.textAlignment = NSTextAlignment.Right
            cell!.addSubview(sizeLabel)
        }
        
        var dictionaryList = self.getCurrentDictionaryList()
        if (dictionaryList.count > 0) {
            var dictionary: AnyObject = dictionaryList[indexPath.row]
            
            var countLabel = cell!.viewWithTag(self.countLabelTag) as UILabel
            var count = dictionary["count"] as Int
            countLabel.text = "单词：\(count)"
            
            var popularLabel = cell!.viewWithTag(self.popularLabelTag) as UILabel
            var popluarIndex = dictionary["popularIndex"] as Int
            popularLabel.text = "人气：\(popluarIndex)"
            
            var filename = (dictionary["id"] as String) + ".db"
            var sizeLabel = cell!.viewWithTag(self.sizeLabelTag) as UILabel
            if (Util.isFileExist(filename)) {
                sizeLabel.text = Util.fileSizeString(filename)
            } else {
                sizeLabel.text = "未下载"
            }
            
            var dictionaryNameLabel = cell!.viewWithTag(self.dictionaryNameLabelTag) as UILabel
            dictionaryNameLabel.text = dictionary["name"] as? String
            
            var selectedView = cell!.viewWithTag(999)
            if (indexPath.row == self.commonTableViewSelectedRow) {
                selectedView?.backgroundColor = Color.red
                dictionaryNameLabel.textColor = Color.white
                countLabel.textColor = Color.white
                popularLabel.textColor = Color.white
                sizeLabel.textColor = Color.white
            } else {
                selectedView?.backgroundColor = UIColor.clearColor()
                dictionaryNameLabel.textColor = Color.black
                countLabel.textColor = Color.lightGray
                popularLabel.textColor = Color.lightGray
                sizeLabel.textColor = Color.lightGray
            }
        }
        
        return cell!
    }
    
    func getCurrentDictionaryList() -> NSArray {
        var dictionaryList: NSArray!
        switch self.selectedSegmentIndex {
        case 0:
            dictionaryList = self.generalDictionaryList
        case 1:
            dictionaryList = self.professionalDictionaryList
        case 2:
            dictionaryList = self.specialDictionaryList
        default:
            break
        }
        
        return dictionaryList
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dictionaryList = self.getCurrentDictionaryList()
        var selectedDictionary: AnyObject = dictionaryList[indexPath.row]
        self.selectedDictionaryId = selectedDictionary["id"] as String
        
        var filename = self.selectedDictionaryId  + ".db"
        if (Util.isFileExist(filename)) {
            var dictionaryInfoController = DictionaryInfoController()
            dictionaryInfoController.delegate = self
            self.addChildViewController(dictionaryInfoController)
            self.view.addSubview(dictionaryInfoController.view)
        } else {
            var params: NSMutableDictionary = NSMutableDictionary()
            params.setValue(self.selectedDictionaryId, forKey: "id")
            API.instance.get("/dictionary/download", delegate: self,  params: params)
        }
        
        self.commonTableViewSelectedRow = indexPath.row
        tableView.reloadData()
    }
    
    func dictionaryDownload(filePath: AnyObject, progress: Float) {
        if (progress >= 1.0) {
            self.commonTableView.reloadData()
        }
    }

    //downloadIcon.addTarget(self, action: "showInfoPage:event:", forControlEvents: UIControlEvents.TouchUpInside)
//    func showInfoPage(sender: UIButton, event: UIEvent) {
//        var touches = event.allTouches()
//        var touch: AnyObject? = touches?.anyObject()
//        var currentTouchPosition = touch?.locationInView(self.commonTableView)
//        var indexPath = self.commonTableView.indexPathForRowAtPoint(currentTouchPosition!)
//        var row = indexPath!.row
//        
//        println(row)
//
//        var dictionaryInfoController = DictionaryInfoController()
//        self.addChildViewController(dictionaryInfoController)
//        self.view.addSubview(dictionaryInfoController.view)
//    }

    
    
    
//    func dictionaryList(data: AnyObject) {
//        LoadingDialog.dismissLoading()
//        
//        var dicList:NSDictionary = data as NSDictionary
//        LogUtils.log("dictionaryList():\(dicList)")
//
//        
//        var params: NSMutableDictionary = NSMutableDictionary()
////        params.setValue(1, forKey: "sync")
////
////        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("54cc5af6c5e20c9b492b39ae.db")
////        var data: NSData? = NSData(contentsOfFile: path)
////        API.instance.post("/dictionary/syncDictionary", delegate: self,  params: params, file: data?)
//    }
    
    func dictionarySyncDictionary(filePath: AnyObject, progress: Float) {
        println(filePath)
        println(progress)
    }
    
    func onLoginSuccess(notification: NSNotification) {
        loadData()
    }
    
    func onDictionaryDeleted(notification: NSNotification) {
        self.commonTableView.reloadData()
        self.reloadMyCurrentLabel()
    }
    
    func onLearingDictionaryChanged(notification: NSNotification) {
        self.reloadMyCurrentLabel()
    }
    
    func reloadMyCurrentLabel() {
        var string = "我正在学习: " + Util.learningString()
        
        myCurrentDictionaryLabel.text = string
        myCurrentDictionaryLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.lineSpacing = 7
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: myCurrentDictionaryLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        myCurrentDictionaryLabel.attributedText = NSAttributedString(string: myCurrentDictionaryLabel.text!, attributes: attributes)
    }
    
    func loadData() {
        API.instance.get("/dictionary/list", delegate: self, params: NSMutableDictionary())
    }
    
    func groupDictionaryList() {
        self.generalDictionaryList = NSMutableArray()
        self.professionalDictionaryList = NSMutableArray()
        self.specialDictionaryList = NSMutableArray()
        
        if (self.dictionaryList != nil) {
            for dictionary in self.dictionaryList {
                switch dictionary["type"] as Int {
                case 3:
                    self.specialDictionaryList.addObject(dictionary)
                case 2:
                    self.professionalDictionaryList.addObject(dictionary)
                default:
                    self.generalDictionaryList.addObject(dictionary)
                }
            }
        }
    }
    
    func dictionaryList(data: AnyObject) {
        self.dictionaryList = data as NSArray
        self.groupDictionaryList()
        commonTableView.reloadData()
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: CacheKey.DICTIONARY_LIST)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setDictionaryId() -> String {
        return self.selectedDictionaryId
    }
    
    func error(error: Error, api: String) {
        ErrorView(view: self.view, message: error.getMessage())
    }
}