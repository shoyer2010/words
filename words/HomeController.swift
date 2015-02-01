//
//  ViewController.swift
//  words
//
//  Created by shoyer on 15/1/29.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import UIKit

// 首页
class HomeController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate, APIDataDelegate {
    
    let udid: String = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    var scrollView: UIScrollView!
    
    var viewArticleForChinese: UIView!
    var viewArticleForEnglish: UIView!
    var viewHome: UIView!
    var viewLearnWord: UIView!
    var viewWordDetail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var viewBoundsWidth = self.view.bounds.width
        var viewBoundsHeight = self.view.bounds.height
        
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.frame = self.view.frame
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: viewBoundsWidth * 5, height: viewBoundsHeight)
        self.view.addSubview(self.scrollView)
        
        self.viewArticleForChinese = UIView()
        self.viewArticleForChinese.backgroundColor = UIColor(red:0.325, green:0.667, blue:0.922, alpha: 1)
        self.viewArticleForChinese.frame = CGRectMake(0, 0, viewBoundsWidth, viewBoundsHeight)
        self.scrollView.addSubview(self.viewArticleForChinese)
        self.scrollView.bringSubviewToFront(self.viewArticleForChinese)
        
        self.viewArticleForEnglish = UIView()
        self.viewArticleForEnglish.backgroundColor = UIColor(red:0.231, green:0.529, blue:0.757, alpha: 1)
        self.viewArticleForEnglish.frame = CGRectMake(viewBoundsWidth, 0, viewBoundsWidth, viewBoundsHeight)
        self.scrollView.addSubview(self.viewArticleForEnglish)
        self.scrollView.bringSubviewToFront(self.viewArticleForEnglish)
        
        self.viewHome = UIView()
        self.viewHome.backgroundColor = UIColor(red:0.529, green:0.600, blue:0.647, alpha: 1)
        self.viewHome.frame = CGRectMake(viewBoundsWidth * 2, 0, viewBoundsWidth, viewBoundsHeight)
        self.scrollView.addSubview(self.viewHome)
        self.scrollView.bringSubviewToFront(self.viewHome)
        
        self.viewLearnWord = UIView()
        self.viewLearnWord.frame = CGRectMake(viewBoundsWidth * 3, 0, viewBoundsWidth, viewBoundsHeight)
        self.scrollView.addSubview(self.viewLearnWord)
        self.scrollView.bringSubviewToFront(self.viewLearnWord)
        
        self.viewWordDetail = UIView()
        self.viewWordDetail.backgroundColor = UIColor(red:0.529, green:0.600, blue:0.647, alpha: 1)
        self.viewWordDetail.frame = CGRectMake(viewBoundsWidth * 4, 0, viewBoundsWidth, viewBoundsHeight)
        self.scrollView.addSubview(self.viewWordDetail)
        self.scrollView.bringSubviewToFront(self.viewWordDetail)
        
        self.scrollView.contentOffset = CGPoint(x: viewBoundsWidth * 2, y: 0)
        
        self.initViewArticleForChinese()
        self.initViewArticleForEnglish()
        self.initViewHome()
        self.initViewLearnWord()
        self.initViewWordDetail()
        
//        var params: NSMutableDictionary = NSMutableDictionary()
//        params.setValue(self.udid, forKey: "udid")
//        API.instance.post("/user/trial", delegate: self, params: params)
    }
    
    
    func initViewArticleForChinese() {
    }
    
    func initViewArticleForEnglish() {
        
    }
    
    func initViewHome() {
        var tabHeight = CGFloat(50)
        
        var homeScrollView = UIScrollView()
        homeScrollView.frame = self.viewHome.bounds
        homeScrollView.showsVerticalScrollIndicator = false
        homeScrollView.delegate = self
        homeScrollView.bounces = false
        homeScrollView.contentSize = CGSize(width: self.viewHome.bounds.width, height: self.viewHome.bounds.height + tabHeight)
        self.viewHome.addSubview(homeScrollView)
        self.viewHome.bringSubviewToFront(homeScrollView)
        
        var viewHomePage = UIView()
        viewHomePage.backgroundColor = UIColor.redColor()
        viewHomePage.frame = CGRectMake(0, 0, homeScrollView.bounds.width, homeScrollView.bounds.height)
        homeScrollView.addSubview(viewHomePage)
        homeScrollView.bringSubviewToFront(viewHomePage)
        self.viewHome.bringSubviewToFront(viewHomePage)
        
        var viewTab = UIView()
        viewTab.backgroundColor = UIColor.purpleColor()
        viewTab.frame = CGRectMake(0, homeScrollView.bounds.height, homeScrollView.bounds.width, tabHeight)
        homeScrollView.addSubview(viewTab)
        homeScrollView.bringSubviewToFront(viewTab)
        self.viewHome.bringSubviewToFront(viewTab)
    }
    
    func initViewLearnWord() {
        var viewLearnWordSentenceHeight = CGFloat(120)
        var learWordScrollView = UIScrollView()
        learWordScrollView.frame = self.viewLearnWord.bounds
        learWordScrollView.showsVerticalScrollIndicator = false
        learWordScrollView.delegate = self
        learWordScrollView.bounces = false
        learWordScrollView.contentSize = CGSize(width: self.viewLearnWord.bounds.width, height: self.viewLearnWord.bounds.height + viewLearnWordSentenceHeight)
        self.viewLearnWord.addSubview(learWordScrollView)
        self.viewLearnWord.bringSubviewToFront(learWordScrollView)
        
        
        var viewLearnWordSentence = UIView()
        viewLearnWordSentence.backgroundColor = UIColor.purpleColor()
        viewLearnWordSentence.frame = CGRectMake(0, learWordScrollView.bounds.height, learWordScrollView.bounds.width, viewLearnWordSentenceHeight)
        learWordScrollView.addSubview(viewLearnWordSentence)
        learWordScrollView.bringSubviewToFront(viewLearnWordSentence)
        self.viewLearnWord.bringSubviewToFront(viewLearnWordSentence)
        
        var viewLearnWordPage = UIView()
        viewLearnWordPage.backgroundColor = UIColor(red:0.529, green:0.900, blue:0.647, alpha: 1)
        viewLearnWordPage.frame = CGRectMake(0, viewLearnWordSentenceHeight, learWordScrollView.bounds.width, learWordScrollView.bounds.height)
        learWordScrollView.addSubview(viewLearnWordPage)
        learWordScrollView.bringSubviewToFront(viewLearnWordPage)
        self.viewLearnWord.bringSubviewToFront(viewLearnWordPage)
        
        learWordScrollView.contentOffset = CGPoint(x: 0, y: viewLearnWordSentenceHeight)
    }
    
    func initViewWordDetail() {
    }
    
    
    func userTrial(data: AnyObject) {
        var username = data["username"] as? String
//        label.text = username
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(username, forKey: "username")
        params.setValue("sfas", forKey: "password")
        params.setValue(self.udid, forKey: "udid")
        API.instance.get("/user/login", delegate: self, params: params)
    }
    
    func userRegister(data: AnyObject) {
        
    }
    
    func userLogin(data: AnyObject) {
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(60, forKey: "seconds")
        params.setValue("fasffs", forKey: "sign")
        API.instance.post("/user/activeTime", delegate: self, params: params)
        
        var borad = UIStoryboard(name: "Main", bundle: nil)

//        self.presentViewController(borad.instantiateViewControllerWithIdentifier("dictionaryController") as UIViewController, animated: true, completion: nil)
//        var navigationController = UINavigationController()
//        
//        navigationController.pushViewController(borad.instantiateViewControllerWithIdentifier("dictionaryController") as UIViewController, animated: true)
    }
    
    func error(error: Error, api: String) {
        println("\(api) error -->>>>>>>>>>\(error.getMessage())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

