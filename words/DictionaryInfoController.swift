
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
        
        var scrollView = UIScrollView(frame: self.subView.frame)
        scrollView.bounces = true
        scrollView.contentSize = CGSize(width: self.subView.frame.width, height:  500)
        
        var tableViewWrap = UIView(frame: CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: 371))
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
        tableView.userInteractionEnabled = false
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var tableHeader = UIView(frame: CGRect(x: 15, y: 20, width: tableView.frame.width, height: 30))
        tableHeader.backgroundColor = Color.red.colorWithAlphaComponent(0.9)
        
        var rankHeaderLabel = UILabel(frame: CGRect(x:  0, y: 0, width: 50, height: 30))
        rankHeaderLabel.text = "排名"
        rankHeaderLabel.font = UIFont(name: rankHeaderLabel.font.fontName, size: CGFloat(12))
        var attributesForRankHeaderLabel = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: rankHeaderLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        rankHeaderLabel.attributedText = NSAttributedString(string: rankHeaderLabel.text!, attributes: attributesForRankHeaderLabel)
        tableHeader.addSubview(rankHeaderLabel)
        
        var usernameLabel = UILabel(frame: CGRect(x:  50, y: 0, width: (tableHeader.frame.width - 50) * 0.25, height: 30))
        usernameLabel.text = "用户名"
        usernameLabel.font = UIFont(name: usernameLabel.font.fontName, size: CGFloat(12))
        var attributesForUsername = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: usernameLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        usernameLabel.attributedText = NSAttributedString(string: usernameLabel.text!, attributes: attributesForUsername)
        tableHeader.addSubview(usernameLabel)
        
        var timeLabel = UILabel(frame: CGRect(x:  50 + (tableHeader.frame.width - 50) * 0.25, y: 0, width: (tableHeader.frame.width - 50) * 0.25, height: 30))
        timeLabel.text = "耗时(分)"
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: CGFloat(12))
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: timeLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        timeLabel.attributedText = NSAttributedString(string: timeLabel.text!, attributes: attributes)
        tableHeader.addSubview(timeLabel)
        
        var keepLabel = UILabel(frame: CGRect(x: 50 + (tableHeader.frame.width - 50) * 0.5, y: 0, width: (tableHeader.frame.width - 50) * 0.25, height: 30))
        keepLabel.text = "已保持(天)"
        keepLabel.font = UIFont(name: keepLabel.font.fontName, size: CGFloat(12))
        var attributesForKeepLabel = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: keepLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        keepLabel.attributedText = NSAttributedString(string: keepLabel.text!, attributes: attributesForKeepLabel)
        tableHeader.addSubview(keepLabel)
        
        var challengeLabel = UILabel(frame: CGRect(x: 50 + (tableHeader.frame.width - 50) * 0.75, y: 0, width: (tableHeader.frame.width - 50) * 0.25, height: 30))
        challengeLabel.text = "操作"
        challengeLabel.font = UIFont(name: challengeLabel.font.fontName, size: CGFloat(12))
        var attributesForChallengeLabel = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: challengeLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        challengeLabel.attributedText = NSAttributedString(string: challengeLabel.text!, attributes: attributesForChallengeLabel)
        tableHeader.addSubview(challengeLabel)
        
        tableView.tableHeaderView = tableHeader
        
        var tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        tableFooter.backgroundColor = Color.red.colorWithAlphaComponent(0.9)

        var myRankLabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableFooter.frame.width - 30, height: tableFooter.frame.height))
        myRankLabel.text = "我的耗时23分钟，当前排名2323"
        myRankLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
        var paragraphStyleForFooter = NSMutableParagraphStyle()
        paragraphStyleForFooter.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        var attributesForFooter = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForFooter,
            NSFontAttributeName: myRankLabel.font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -1.0)
            ])
        myRankLabel.attributedText = NSAttributedString(string: myRankLabel.text!, attributes: attributesForFooter)
        tableFooter.addSubview(myRankLabel)
        tableView.tableFooterView = tableFooter
        
        tableViewWrap.addSubview(tableView)
        scrollView.addSubview(tableViewWrap)
        self.subView.addSubview(scrollView)
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
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        var rankLabel = UILabel(frame: CGRect(x: 10, y: 3, width: 24, height: 24))
        rankLabel.backgroundColor = Color.listIconBackground
        rankLabel.text = String(indexPath.row + 1)
        rankLabel.textColor = Color.white
        rankLabel.textAlignment = NSTextAlignment.Center
        rankLabel.font = UIFont(name: rankLabel.font.fontName, size: CGFloat(11))
        rankLabel.layer.cornerRadius = 12
        rankLabel.layer.masksToBounds = true
        cell.addSubview(rankLabel)
        
        var usernameLabel = UILabel(frame: CGRect(x: 50, y: 0, width: (tableView.frame.width - 50) * 0.25, height: 30))
        usernameLabel.text = "shoyer"
        usernameLabel.textColor = Color.gray
        usernameLabel.font = UIFont(name: usernameLabel.font.fontName, size: CGFloat(14))
        usernameLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(usernameLabel)
        
        var timeLabel = UILabel(frame: CGRect(x: 50 + (tableView.frame.width - 50) * 0.25, y: 0, width: (tableView.frame.width - 50) * 0.25, height: 30))
        timeLabel.text = "23"
        timeLabel.textColor = Color.gray
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: CGFloat(14))
        timeLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(timeLabel)
        
        var haveKeepLabel = UILabel(frame: CGRect(x: 50 + (tableView.frame.width - 50) * 0.5, y: 0, width: (tableView.frame.width - 50) * 0.25, height: 30))
        haveKeepLabel.text = "34"
        haveKeepLabel.textColor = Color.gray
        haveKeepLabel.font = UIFont(name: haveKeepLabel.font.fontName, size: CGFloat(14))
        haveKeepLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(haveKeepLabel)
        
        var challengeButton = UIButton(frame: CGRect(x: tableView.frame.width - 35, y: 2, width: 26, height: 26))
        challengeButton.backgroundColor = Color.gray
        challengeButton.layer.cornerRadius = 13
        challengeButton.layer.masksToBounds = true
        challengeButton.setTitle(("战"), forState: UIControlState.Normal)
        challengeButton.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(12))
        cell.addSubview(challengeButton)
        
        return cell
    }

}