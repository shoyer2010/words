import UIKit

class HomeController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UIScrollViewDelegate, APIDataDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.initView()
        
        
        //        var params: NSMutableDictionary = NSMutableDictionary()
        //        params.setValue(self.udid, forKey: "udid")
        //        API.instance.post("/user/trial", delegate: self, params: params)
    }
    
    func initView() {
        var tabHeight = CGFloat(49) // NOTE: do not change this value, it is the TabBar's default height
        
        var homeScrollView = UIScrollView()
        homeScrollView.frame = self.view.frame
        homeScrollView.delegate = self
        homeScrollView.showsVerticalScrollIndicator = false
        homeScrollView.pagingEnabled = true
        homeScrollView.bounces = false
        homeScrollView.contentSize = CGSize(width: homeScrollView.frame.width, height:  homeScrollView.frame.height * 2 - 20)
        self.view.addSubview(homeScrollView)
        
        var viewHomePage = UIView()
        viewHomePage.backgroundColor = Color.red
        viewHomePage.frame = CGRectMake(0, 0, homeScrollView.frame.width, homeScrollView.frame.height)
        
        
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
        
        var todayRecommend = UILabel(frame: CGRect(x: 10, y: 10, width: homeBody.frame.width - 10, height: 30))
        todayRecommend.backgroundColor = UIColor.redColor()
        todayRecommend.text = "今日推荐"
        homeBody.addSubview(todayRecommend)
        
        var startLearn = UIView(frame: CGRect(x: homeBody.frame.width / 2 - 50, y: homeBody.frame.height - 150, width: 100, height: 100))
        startLearn.backgroundColor = Color.gray
        startLearn.layer.cornerRadius = 50
        startLearn.layer.masksToBounds = true
        startLearn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onStartLearnTapped:"))
        
        var startLearnLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 100))
        startLearnLabel.text = "开始受虐"
        startLearnLabel.textColor = UIColor.greenColor()
        startLearn.addSubview(startLearnLabel)
        homeBody.addSubview(startLearn)
        
        viewHomePage.addSubview(homeBody)
        
        homeScrollView.addSubview(viewHomePage)
        homeScrollView.bringSubviewToFront(viewHomePage)
        
        // create tabbar view
        var viewTab = UITabBar()
        viewTab.delegate = self
        viewTab.frame = CGRectMake(0, homeScrollView.bounds.height, homeScrollView.bounds.width, tabHeight)
        viewTab.tintColor = UIColor.whiteColor()
        viewTab.backgroundImage = Util.createImageWithColor(Color.gray, width: 1.0, height: 1.0)
        viewTab.shadowImage = Util.createImageWithColor(UIColor.clearColor(), width: 1.0, height: 1.0)
        viewTab.selectionIndicatorImage = Util.createImageWithColor(Color.red, width: 76.0, height: 49.0)
        var viewTabBarItemForRank = UITabBarItem(title: "排行", image: UIImage(named: "tabbar.png"), tag: 1)
        var viewTabBarItemForStatistics = UITabBarItem(title: "统计", image: UIImage(named: "tabbar.png"), tag: 2)
        var viewTabBarItemForDictionary = UITabBarItem(title: "词库", image: UIImage(named: "tabbar.png"), tag: 3)
        var viewTabBarItemForSettings = UITabBarItem(title: "设置", image: UIImage(named: "tabbar.png"), tag: 4)
        
        var viewTabBarItemForAccount = UITabBarItem(title: "账户", image: UIImage(named: "tabbar.png"), tag: 5)
        viewTab.setItems([
            viewTabBarItemForRank,
            viewTabBarItemForStatistics,
            viewTabBarItemForDictionary,
            viewTabBarItemForSettings,
            viewTabBarItemForAccount
            ], animated: true)
        
        viewTab.selectedItem   = viewTabBarItemForDictionary
        
        homeScrollView.addSubview(viewTab)
        
        
        // scroll view for tab items.
        var viewWidth = homeScrollView.frame.width
        var viewHeight = homeScrollView.frame.height - 49 - 20
        
        var scrollViewForTabItems = UIScrollView()
        scrollViewForTabItems.frame = CGRectMake(0, homeScrollView.frame.height + 49, viewWidth, viewHeight)
        scrollViewForTabItems.backgroundColor = UIColor.purpleColor()
        scrollViewForTabItems.pagingEnabled = true
        scrollViewForTabItems.showsHorizontalScrollIndicator = false
        scrollViewForTabItems.bounces = false
        scrollViewForTabItems.delegate = self
        scrollViewForTabItems.contentSize = CGSize(width: viewWidth * 5, height: viewHeight)
        scrollViewForTabItems.contentOffset = CGPoint(x: viewWidth * 2, y: 0)
        homeScrollView.addSubview(scrollViewForTabItems)
        
        var rankController = RankController()
        self.addChildViewController(rankController)
        rankController.view.frame = CGRectMake(0, 0, viewWidth, viewHeight)
        scrollViewForTabItems.addSubview(rankController.view)
        
        var statisticsController = StatisticsController()
        self.addChildViewController(statisticsController)
        statisticsController.view.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight)
        scrollViewForTabItems.addSubview(statisticsController.view)
        
        var dictionaryController = DictionaryController()
        self.addChildViewController(dictionaryController)
        dictionaryController.view.frame = CGRectMake(viewWidth * 2, 0, viewWidth, viewHeight)
        scrollViewForTabItems.addSubview(dictionaryController.view)
        
        var settingsController = SettingsController()
        self.addChildViewController(settingsController)
        settingsController.view.frame = CGRectMake(viewWidth * 3, 0, viewWidth, viewHeight)
        scrollViewForTabItems.addSubview(settingsController.view)
        
        var accountController = AccountController()
        self.addChildViewController(accountController)
        accountController.view.frame = CGRectMake(viewWidth * 4, 0, viewWidth, viewHeight)
        scrollViewForTabItems.addSubview(accountController.view)
    }
    
    func onStartLearnTapped(sender: UIView) {
        var parentController = self.parentViewController as ApplicationController
        println(parentController.scrollToPage(page: 3))
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        println(scrollView)
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        println(searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        switch (item.tag) {
//        case 1:
//            self.presentViewController(RankController(), animated: true, completion: nil)
//        case 2:
//        case 3:
//        case 4:
//        case 5:
        default:
            break
        }
    }
    
    
    
    
    
    
    
    
    
    
        

    
    
//    func userTrial(data: AnyObject) {
//        var username = data["username"] as? String
//        label.text = username
//        
//        var params: NSMutableDictionary = NSMutableDictionary()
//        params.setValue(username, forKey: "username")
//        params.setValue("sfas", forKey: "password")
//        params.setValue(self.udid, forKey: "udid")
//        API.instance.get("/user/login", delegate: self, params: params)
//    }
//    
//    func userRegister(data: AnyObject) {
//        
//    }
//    
//    func userLogin(data: AnyObject) {
//        var params: NSMutableDictionary = NSMutableDictionary()
//        params.setValue(60, forKey: "seconds")
//        params.setValue("fasffs", forKey: "sign")
//        API.instance.post("/user/activeTime", delegate: self, params: params)
//        
//        var borad = UIStoryboard(name: "Main", bundle: nil)
//
//        self.presentViewController(borad.instantiateViewControllerWithIdentifier("dictionaryController") as UIViewController, animated: true, completion: nil)
//        var navigationController = UINavigationController()
//        
//        navigationController.pushViewController(borad.instantiateViewControllerWithIdentifier("dictionaryController") as UIViewController, animated: true)
//    }
//    
//    func error(error: Error, api: String) {
//        println("\(api) error -->>>>>>>>>>\(error.getMessage())")
//    }

    
}

