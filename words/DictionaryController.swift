import UIKit

class DictionaryController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = (self.parentViewController as HomeController).getFrameOfSubTabItem(2)
        // Do any additional setup after loading the view, typically from a nib.
        
        var totalWordCountLabel = UILabel(frame: CGRect(x: 15, y: 10, width: 200, height: 20))
        totalWordCountLabel.text = "单词总数： 3455个"
        self.view.addSubview(totalWordCountLabel)
        
        var popularIndexLabel = UILabel(frame: CGRect(x: 15, y: 40, width: 200, height: 20))
        popularIndexLabel.text = "人气指数：23243"
        self.view.addSubview(popularIndexLabel)
        
        var hardIndexLabel = UILabel(frame: CGRect(x: 15, y: 70, width: 200, height: 20))
        hardIndexLabel.text = "难度指数： *****"
        self.view.addSubview(hardIndexLabel)
    
        var breakedCountLabel = UILabel(frame: CGRect(x: 15, y: 100, width: 200, height: 20))
        breakedCountLabel.text = "记录被打破：20次"
        self.view.addSubview(breakedCountLabel)
        
        var keeperLabel = UILabel(frame: CGRect(x: 15, y: 130, width: 200, height: 20))
        keeperLabel.text = "记录保持者： shoyer"
        self.view.addSubview(keeperLabel)
        
        var keepDaysLabel = UILabel(frame: CGRect(x: 15, y: 160, width: 200, height: 20))
        keepDaysLabel.text = "保持时间： 232天"
        self.view.addSubview(keepDaysLabel)
        
        var dictionaryTableView = UITableView(frame: CGRect(x: 15, y: 190, width: self.view.frame.width - 30, height: self.view.frame.height - 200))
        dictionaryTableView.backgroundColor = UIColor.whiteColor()
        dictionaryTableView.delegate = self
        dictionaryTableView.dataSource = self
        
        self.view.addSubview(dictionaryTableView)
        
        

//        API.instance.get("/dictionary/list", delegate: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 注意，实际数据填充的时候，这里要用可复用的cell， 资料；http://www.cnblogs.com/smileEvday/archive/2012/06/28/tableView.html
        
        var tableCell = UITableViewCell()
        tableCell.textLabel?.text = "大学英语4级"
        
        var downloadIcon = UIView(frame: CGRect(x: tableView.frame.width - 113, y: 0, width: 32, height: 32))
        downloadIcon.backgroundColor = UIColor.purpleColor()
        tableCell.accessoryView?.addSubview(downloadIcon)
//        tableCell.contentView.addSubview(timeLable)
        
        return tableCell
    }

    
    
    
    func dictionaryList(data: AnyObject) {
        println(self.view)
        var params: NSMutableDictionary = NSMutableDictionary()
//        params.setValue(1, forKey: "sync")
//
//        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("54cc5af6c5e20c9b492b39ae.db")
//        var data: NSData? = NSData(contentsOfFile: path)
//        API.instance.post("/dictionary/syncDictionary", delegate: self,  params: params, file: data?)
    }
    
    func dictionarySyncDictionary(filePath: AnyObject, progress: Float) {
        println(filePath)
        println(progress)
    }
}