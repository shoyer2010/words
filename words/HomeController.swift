//
//  ViewController.swift
//  words
//
//  Created by shoyer on 15/1/29.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import UIKit

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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    
    
    
    func initViewArticleForChinese() {
    }
    
    func initViewArticleForEnglish() {
        
    }
    
    
    /*******************************
     *  首页界面初始化
     *******************************
     */
    func initViewHome() {
        var tabHeight = CGFloat(49) // NOTE: do not change this value, it is the TabBar's default height
        
        var homeScrollView = UIScrollView()
        homeScrollView.frame = self.viewHome.bounds
        homeScrollView.showsVerticalScrollIndicator = false
        homeScrollView.delegate = self
        homeScrollView.bounces = false
        homeScrollView.contentSize = CGSize(width: self.viewHome.bounds.width, height: self.viewHome.bounds.height + tabHeight)
        self.viewHome.addSubview(homeScrollView)
        self.viewHome.bringSubviewToFront(homeScrollView)
        
        var viewHomePage = UIView()
        viewHomePage.backgroundColor = Color.red
        viewHomePage.frame = CGRectMake(0, 0, homeScrollView.bounds.width, homeScrollView.bounds.height)
        
        
        var homeTopBar = UIView(frame: CGRect(x: 0, y: 20, width: homeScrollView.frame.width, height: 32))
        homeTopBar.backgroundColor = Color.red
        
        var leftArticleIcon = UIView(frame: CGRect(x: 0, y: 2, width: 50, height: 32))
        homeTopBar.addSubview(leftArticleIcon)
        
        
        var searchBar = UISearchBar(frame: CGRect(x: 50, y: 4, width: viewHomePage.frame.width - 50 * 2, height: 24))
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 12
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Color.gray.CGColor
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.placeholder = "单词列队完毕，请您检阅"
        homeTopBar.addSubview(searchBar)
        
        var rightHelpIcon = UIView(frame: CGRect(x: 50 + searchBar.frame.width, y: 2, width: 50, height: 26))
        rightHelpIcon.backgroundColor = Color.red
        homeTopBar.addSubview(rightHelpIcon)
        
        viewHomePage.addSubview(homeTopBar)
        
        var homeBody = UIView(frame: CGRect(x: 0, y: 52, width: viewHomePage.frame.width, height: viewHomePage.frame.height - 52))
        homeBody.backgroundColor = Color.homeBackground
        
        var todayRecommend = UILabel(frame: CGRect(x: 5, y: 30, width: homeBody.frame.width - 5, height: 30))
        todayRecommend.text = "今日推荐"
        homeBody.addSubview(todayRecommend)
        
        var startLearn = UIView(frame: CGRect(x: 100, y: 260, width: 100, height: 100))
        startLearn.backgroundColor = UIColor.grayColor()
        startLearn.layer.cornerRadius = 50
        startLearn.layer.masksToBounds = true
        
        var startLearnLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 100))
        startLearnLabel.text = "开始受虐"
        startLearn.addSubview(startLearnLabel)
        homeBody.addSubview(startLearn)
        
        viewHomePage.addSubview(homeBody)
        
        homeScrollView.addSubview(viewHomePage)
        homeScrollView.bringSubviewToFront(viewHomePage)
        
        var viewTab = UITabBar()
        println(homeScrollView.bounds.height)
        viewTab.frame = CGRectMake(0, homeScrollView.bounds.height, homeScrollView.bounds.width, tabHeight)
        println(viewTab.frame)
        viewTab.barTintColor = Color.gray
        viewTab.tintColor = UIColor.whiteColor()
        viewTab.selectionIndicatorImage = UIImage(named: "red")
        
        var viewTabBarItemForRank = UITabBarItem(title: "排行", image: UIImage(named: "tabbar.png"), tag: 1)
        var viewTabBarItemForStatistics = UITabBarItem(title: "统计", image: UIImage(named: "tabbar.png"), tag: 2)
        var viewTabBarItemForDictionary = UITabBarItem(title: "词库", image: UIImage(named: "tabbar.png"), tag: 3)
        var viewTabBarItemForSettings = UITabBarItem(title: "设置", image: UIImage(named: "tabbar.png"), tag: 4)
        
        var viewTabBarItemForAccount = UITabBarItem(title: "账户", image: UIImage(named: "tabbar.png"), tag: 5)
//        var viewTabBarItemForHelp  = UITabBarItem(title: "帮助", image: UIImage(named: "tabbar.png"), tag: 6)
        viewTab.setItems([
            viewTabBarItemForRank,
            viewTabBarItemForStatistics,
            viewTabBarItemForDictionary,
            viewTabBarItemForSettings,
            viewTabBarItemForAccount,
//            viewTabBarItemForHelp
            ], animated: true)
        
        viewTab.selectedItem   = viewTabBarItemForDictionary
        
        homeScrollView.addSubview(viewTab)
        homeScrollView.bringSubviewToFront(viewTab)
    }
    
    
    /*******************************
    *  首页事件处理
    *******************************
    */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        println(searchBar.text)
        searchBar.resignFirstResponder()
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
        
        var viewLearnWordPage = UIView()
        viewLearnWordPage.backgroundColor = UIColor(red:0.529, green:0.900, blue:0.647, alpha: 1)
        viewLearnWordPage.frame = CGRectMake(0, viewLearnWordSentenceHeight, learWordScrollView.bounds.width, learWordScrollView.bounds.height)
        learWordScrollView.addSubview(viewLearnWordPage)
        learWordScrollView.bringSubviewToFront(viewLearnWordPage)
        
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
}

