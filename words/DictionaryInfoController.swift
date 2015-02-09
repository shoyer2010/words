
import Foundation
import UIKit

class DictionaryInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIDataDelegate {
    var subView: UIView!
    var subViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapView:"))
        self.subViewHeight = self.view.frame.height - 120
        
        self.subView = UIView(frame: CGRect(x: 0, y: -self.subViewHeight, width: self.view.frame.width, height: self.subViewHeight))
        self.subView.backgroundColor = Color.white.colorWithAlphaComponent(0.89)
        self.subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil)) // prevent tap event from delivering to parent view.
        self.subView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: nil))
        self.view.addSubview(self.subView)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            }) { (isDone: Bool) -> Void in
        }
        
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
        
        var appearCountLabel = UILabel(frame: CGRect(x:  100, y: 0, width: (tableHeader.frame.width - 100) * 0.33, height: 30))
        appearCountLabel.text = "出现(次)"
        appearCountLabel.textColor = Color.white
        appearCountLabel.textAlignment = NSTextAlignment.Center
        appearCountLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(appearCountLabel)
        
        var wrongCountLabel = UILabel(frame: CGRect(x:  100 + (tableHeader.frame.width - 100) * 0.33, y: 0, width: (tableHeader.frame.width - 100) * 0.33, height: 30))
        wrongCountLabel.text = "错误(次)"
        wrongCountLabel.textColor = Color.white
        wrongCountLabel.textAlignment = NSTextAlignment.Center
        wrongCountLabel.font = UIFont(name: wrongCountLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(wrongCountLabel)
        
        var haveMasteredLabel = UILabel(frame: CGRect(x:  100 + (tableHeader.frame.width - 100) * 0.66, y: 0, width: (tableHeader.frame.width - 100) * 0.33, height: 30))
        haveMasteredLabel.text = "已掌握"
        haveMasteredLabel.textColor = Color.white
        haveMasteredLabel.textAlignment = NSTextAlignment.Center
        haveMasteredLabel.font = UIFont(name: haveMasteredLabel.font.fontName, size: CGFloat(12))
        tableHeader.addSubview(haveMasteredLabel)
        tableViewWrap.addSubview(tableHeader)
        
        var tableView = UITableView(frame: CGRect(x: 6, y: 36, width: tableViewWrap.frame.width - 12, height: tableViewWrap.frame.height - 42))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = Layer.cornerRadius
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableViewWrap.addSubview(tableView)
        
        tableViewWrap.bringSubviewToFront(tableHeader)
        
        self.subView.addSubview(tableViewWrap)
        
        var learnButton = UIButton(frame: CGRect(x: self.subView.frame.width / 2 - 65, y: self.subView.frame.height - 40, width: 60, height: 30))
        learnButton.setTitle("学习", forState: UIControlState.Normal)
        learnButton.backgroundColor = Color.gray
        self.subView.addSubview(learnButton)
        
        var deleteButton = UIButton(frame: CGRect(x: learnButton.frame.origin.x + learnButton.frame.width + 10, y: self.subView.frame.height - 40, width: 60, height: 30))
        deleteButton.setTitle("删除", forState: UIControlState.Normal)
        deleteButton.backgroundColor = Color.gray
        self.subView.addSubview(deleteButton)
    }
    
    func onTapView(recognizer: UITapGestureRecognizer) {
        self.closeView()
    }
    
    func onButtonTapped(sender: UIButton) {
        self.closeView()
    }
    
    func onCancelTapped(sender: UIButton) {
        self.closeView()
    }
    
    func closeView() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.subView.transform = CGAffineTransformMakeTranslation(0, -self.subViewHeight)
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            }) { (isDone: Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(30)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5000
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell!.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
            cell!.separatorInset = UIEdgeInsetsZero
            cell!.layoutMargins = UIEdgeInsetsZero
            
            var wordLabel = UILabel(frame: CGRect(x: 10, y: 3, width: 100, height: 24))
            wordLabel.text = "what"
            wordLabel.textColor = Color.gray
            wordLabel.textAlignment = NSTextAlignment.Left
            wordLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(12))
            cell!.addSubview(wordLabel)
            
            var appearCountLabel = UILabel(frame: CGRect(x: 100, y: 0, width: (tableView.frame.width - 100) * 0.33, height: 30))
            appearCountLabel.text = "23"
            appearCountLabel.textColor = Color.gray
            appearCountLabel.font = UIFont(name: appearCountLabel.font.fontName, size: CGFloat(14))
            appearCountLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(appearCountLabel)
            
            var wrongLabel = UILabel(frame: CGRect(x: 100 + (tableView.frame.width - 100) * 0.33, y: 0, width: (tableView.frame.width - 100) * 0.33, height: 30))
            wrongLabel.text = "12"
            wrongLabel.textColor = Color.gray
            wrongLabel.font = UIFont(name: wrongLabel.font.fontName, size: CGFloat(14))
            wrongLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(wrongLabel)
            
            var haveMasteredLabel = UILabel(frame: CGRect(x: 100 + (tableView.frame.width - 100) * 0.66, y: 0, width: (tableView.frame.width - 100) * 0.33, height: 30))
            haveMasteredLabel.text = "√"
            haveMasteredLabel.textColor = Color.gray
            haveMasteredLabel.font = UIFont(name: haveMasteredLabel.font.fontName, size: CGFloat(14))
            haveMasteredLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(haveMasteredLabel)
        }
        
        return cell!
    }

}