//
//  LearnWordController.swift
//  words
//
//  Created by shoyer on 15/2/2.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//
import Foundation
import UIKit

class LearnWordController: UIViewController, UIScrollViewDelegate, APIDataDelegate {
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
        learnWordScrollView.addSubview(viewLearnWordPage)

        learnWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
    }
}