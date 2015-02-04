//
//  LearnWordController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//
import Foundation
import UIKit

class LearnWordController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,  APIDataDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initView()
    }
    
    func initView() {
        var viewLearnWordSentenceHeight = CGFloat(120)

        var learnWordScrollView = UIScrollView()
        learnWordScrollView.frame = self.view.bounds
        learnWordScrollView.showsVerticalScrollIndicator = false
        learnWordScrollView.pagingEnabled = false
        learnWordScrollView.delegate = self
        learnWordScrollView.bounces = false

        learnWordScrollView.contentSize = CGSize(width: learnWordScrollView.frame.width, height: learnWordScrollView.frame.height + viewLearnWordSentenceHeight)
        
        self.view.addSubview(learnWordScrollView)


        var viewLearnWordSentence = UIView()
        viewLearnWordSentence.backgroundColor = UIColor.purpleColor()
        viewLearnWordSentence.frame = CGRectMake(0, learnWordScrollView.frame.height, learnWordScrollView.frame.width, viewLearnWordSentenceHeight)
        learnWordScrollView.addSubview(viewLearnWordSentence)

        var viewLearnWordPage = UIView()
        viewLearnWordPage.backgroundColor = UIColor(red:0.529, green:0.900, blue:0.647, alpha: 1)
        viewLearnWordPage.frame = CGRectMake(0, viewLearnWordSentenceHeight, learnWordScrollView.frame.width, learnWordScrollView.frame.height)
        
        var wordLabel = UILabel(frame: CGRect(x: 0, y: 60, width: viewLearnWordPage.frame.width, height: 40))
        wordLabel.textAlignment = NSTextAlignment.Center
        wordLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(40))
        wordLabel.text = "what"
        viewLearnWordPage.addSubview(wordLabel)
        
        var wordPhoneticSymbolLabel = UILabel(frame: CGRect(x: 0, y: 105, width: viewLearnWordPage.frame.width, height: 20))
        wordPhoneticSymbolLabel.textAlignment = NSTextAlignment.Center
        wordPhoneticSymbolLabel.font = UIFont(name: wordLabel.font.fontName, size: CGFloat(20))
        wordPhoneticSymbolLabel.text = "英[wa:t]"
        viewLearnWordPage.addSubview(wordPhoneticSymbolLabel)
        
        var optionsTableView = UITableView(frame: CGRect(x: 15, y: 130, width: viewLearnWordPage.frame.width - 30, height: viewLearnWordPage.frame.height - 280), style: UITableViewStyle.Plain)
        optionsTableView.backgroundColor = UIColor.whiteColor()
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        viewLearnWordPage.addSubview(optionsTableView)
        
        var knowButton = UIButton(frame: CGRect(x: 15, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
        knowButton.backgroundColor = UIColor.purpleColor()
        knowButton.layer.cornerRadius = 30
        knowButton.layer.masksToBounds = true
        knowButton.tintColor = UIColor.whiteColor()
        knowButton.setTitle("认识", forState: UIControlState.Normal)
        viewLearnWordPage.addSubview(knowButton)
        
        var unknowButton = UIButton(frame: CGRect(x: 80, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
        unknowButton.backgroundColor = UIColor.purpleColor()
        unknowButton.layer.cornerRadius = 30
        unknowButton.layer.masksToBounds = true
        unknowButton.tintColor = UIColor.whiteColor()
        unknowButton.setTitle("不认识", forState: UIControlState.Normal)
        viewLearnWordPage.addSubview(unknowButton)
        
        var nextButton = UIButton(frame: CGRect(x: 150, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
        nextButton.backgroundColor = UIColor.purpleColor()
        nextButton.layer.cornerRadius = 30
        nextButton.layer.masksToBounds = true
        nextButton.tintColor = UIColor.whiteColor()
        nextButton.setTitle("下一个", forState: UIControlState.Normal)
        viewLearnWordPage.addSubview(nextButton)
        
        var removeButton = UIButton(frame: CGRect(x: 220, y: viewLearnWordPage.frame.height - 120, width: 60, height: 60))
        removeButton.backgroundColor = UIColor.purpleColor()
        removeButton.layer.cornerRadius = 30
        removeButton.layer.masksToBounds = true
        removeButton.tintColor = UIColor.whiteColor()
        removeButton.setTitle("删除", forState: UIControlState.Normal)
        viewLearnWordPage.addSubview(removeButton)
        
        learnWordScrollView.addSubview(viewLearnWordPage)

        learnWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 注意，实际数据填充的时候，这里要用可复用的cell， 资料；http://www.cnblogs.com/smileEvday/archive/2012/06/28/tableView.html
        var tableCell = UITableViewCell()
        tableCell.textLabel?.text = "A"
        
        var optionLabel = UILabel()
        optionLabel.frame = CGRectMake(60, 8, 100, 20)
        optionLabel.text = "什么，什么"
        tableCell.contentView.addSubview(optionLabel)
        
        return tableCell
    }

}