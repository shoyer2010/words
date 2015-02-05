import UIKit

class HomeController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UIScrollViewDelegate, APIDataDelegate {
    
    var searchBar: UISearchBar!
    var scrollViewForTabItems: UIScrollView!
    var viewTab: UITabBar!
    var homeScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.initView()
        
        
        //        var params: NSMutableDictionary = NSMutableDictionary()
        //        params.setValue(self.udid, forKey: "udid")
        //        API.instance.post("/user/trial", delegate: self, params: params)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func initView() {
        var tabHeight = CGFloat(49) // NOTE: do not change this value, it is the TabBar's default height
        
        self.homeScrollView = UIScrollView()
        self.homeScrollView.frame = self.view.frame
        self.homeScrollView.delegate = self
        self.homeScrollView.showsVerticalScrollIndicator = false
        self.homeScrollView.pagingEnabled = true
        self.homeScrollView.bounces = false
        self.homeScrollView.contentSize = CGSize(width: self.homeScrollView.frame.width, height:  self.homeScrollView.frame.height * 2 - 20)
        self.view.addSubview(self.homeScrollView)
        
        var viewHomePage = UIView()
        viewHomePage.backgroundColor = Color.red
        viewHomePage.frame = CGRectMake(0, 0, self.homeScrollView.frame.width, self.homeScrollView.frame.height)
        
        var homeTopBar = UIView(frame: CGRect(x: 0, y: 20, width: self.homeScrollView.frame.width, height: 35))
        homeTopBar.backgroundColor = Color.red
        
        var leftArticleIcon = UIView(frame: CGRect(x: 15, y: 4, width: 24, height: 24))
        leftArticleIcon.backgroundColor = UIColor(patternImage: UIImage(named: "favorite.png")!)
        leftArticleIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapArticleIcon:"))
        homeTopBar.addSubview(leftArticleIcon)
        
        
        self.searchBar = UISearchBar(frame: CGRect(x: 50, y: 4, width: viewHomePage.frame.width - 50 * 2, height: 25))
        self.searchBar.delegate = self
        self.searchBar.layer.cornerRadius = 12
        self.searchBar.layer.masksToBounds = true
        self.searchBar.layer.borderColor = Color.gray.CGColor
        self.searchBar.barTintColor = UIColor.whiteColor()
        self.searchBar.placeholder = "单词列队完毕，请您检阅"
        homeTopBar.addSubview(self.searchBar)
        
        var rightHelpIcon = UIView(frame: CGRect(x: homeTopBar.frame.width - 15 - 24, y: 4, width: 24, height: 24))
        rightHelpIcon.backgroundColor = UIColor(patternImage: UIImage(named: "help.png")!)
        rightHelpIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapHelpIcon:"))
        homeTopBar.addSubview(rightHelpIcon)
        
        viewHomePage.addSubview(homeTopBar)
        
        var homeBody = UIView(frame: CGRect(x: 0, y: 55, width: viewHomePage.frame.width, height: viewHomePage.frame.height - 55))
        homeBody.backgroundColor = Color.homeBackground
        
        var todayRecommend = UILabel(frame: CGRect(x: 15, y: 10, width: homeBody.frame.width - 30, height: 30))
        todayRecommend.font = UIFont(name: todayRecommend.font.fontName, size: CGFloat(15))
        todayRecommend.text = "今日推荐"
        homeBody.addSubview(todayRecommend)
        
        var recommendView = UITextView(frame: CGRect(x: 15, y: 40, width: viewHomePage.frame.width - 30, height: 60))
        recommendView.backgroundColor = UIColor(red: 0.98, green: 0.90, blue: 0.90, alpha: 1)
        recommendView.editable = false
        recommendView.text = "If you shed teas when you miss the sun, If you shed teas when you miss the sun ou shed teas when you miss the sun ou shed teas when you miss the sun"
        recommendView.font = UIFont(name: recommendView.font.fontName, size: CGFloat(14))
        recommendView.scrollEnabled = false
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        var attributes = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: recommendView.font,
            NSForegroundColorAttributeName: Color.red
            ])
        recommendView.attributedText = NSAttributedString(string: recommendView.text, attributes: attributes)
        recommendView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onRecommendTapped:"))
        homeBody.addSubview(recommendView)
        
        var recommendViewForChinese = UITextView(frame: CGRect(x: 15, y: 87, width: viewHomePage.frame.width - 30, height: 53))
        recommendViewForChinese.backgroundColor = UIColor(red: 0.98, green: 0.90, blue: 0.90, alpha: 1)
        recommendViewForChinese.editable = false
        recommendViewForChinese.text = "总体来说个性化定制UITextView中的内容有两种方法总体来说个性化定制UITextView中的内容有两种方法"
        recommendViewForChinese.font = UIFont(name: recommendViewForChinese.font.fontName, size: CGFloat(12))
        var paragraphStyleForChinese = NSMutableParagraphStyle()
        paragraphStyleForChinese.lineSpacing = 7
        var attributesForChinese = NSDictionary(dictionary: [
            NSParagraphStyleAttributeName: paragraphStyleForChinese,
            NSFontAttributeName: recommendViewForChinese.font,
            NSForegroundColorAttributeName: UIColor(red: 0.41, green: 0.42, blue: 0.42, alpha: 1)
            ])
        recommendViewForChinese.attributedText = NSAttributedString(string: recommendViewForChinese.text, attributes: attributesForChinese)
        recommendViewForChinese.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onRecommendTapped:"))
        homeBody.addSubview(recommendViewForChinese)
        
        var needToLearnIcon = UIView(frame: CGRect(x: 60, y: 180, width: 24, height: 24))
        needToLearnIcon.backgroundColor = Color.red
        homeBody.addSubview(needToLearnIcon)
        
        var needToLearnLabel = UILabel(frame: CGRect(x: 90, y: 180, width: 250, height: 24))
        needToLearnLabel.text = "45个单词需要复习"
        homeBody.addSubview(needToLearnLabel)
        
        var rankIcon = UIView(frame: CGRect(x: 60, y: 220, width: 24, height: 24))
        rankIcon.backgroundColor = Color.red
        homeBody.addSubview(rankIcon)
        
        var rankLabel = UILabel(frame: CGRect(x: 90, y: 220, width: 250, height: 24))
        rankLabel.text = "活跃度排名347"
        homeBody.addSubview(rankLabel)
        
        var dictionaryIcon = UIView(frame: CGRect(x: 60, y: 260, width: 24, height: 24))
        dictionaryIcon.backgroundColor = Color.red
        homeBody.addSubview(dictionaryIcon)
        
        var dictionaryLabel = UILabel(frame: CGRect(x: 90, y: 260, width: 250, height: 24))
        dictionaryLabel.text = "大学英语4级"
        homeBody.addSubview(dictionaryLabel)
        
        var startLearn = UIView(frame: CGRect(x: homeBody.frame.width / 2 - 50, y: homeBody.frame.height - 120, width: 100, height: 100))
        startLearn.backgroundColor = Color.red
        startLearn.layer.cornerRadius = 50
        startLearn.layer.masksToBounds = true
        startLearn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onStartLearnTapped:"))
        
        var startLearnLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 100))
        startLearnLabel.text = "开始受虐"
        startLearnLabel.textColor = UIColor.whiteColor()
        startLearn.addSubview(startLearnLabel)
        homeBody.addSubview(startLearn)
        
        viewHomePage.addSubview(homeBody)
        
        self.homeScrollView.addSubview(viewHomePage)
        self.homeScrollView.bringSubviewToFront(viewHomePage)
        
        // create tabbar view
        // NOTE: prevent from sliding to left or right, but allow up and down, this is a trick.
        var srollViewForWrapViewTab = UIScrollView(frame: CGRectMake(0, self.homeScrollView.bounds.height, self.homeScrollView.bounds.width, tabHeight)
        )
        srollViewForWrapViewTab.bounces = false
        srollViewForWrapViewTab.contentSize = CGSize(width: srollViewForWrapViewTab.frame.width + 0.001, height: srollViewForWrapViewTab.frame.height)

        self.viewTab = UITabBar()
        self.viewTab.delegate = self
        self.viewTab.frame = CGRectMake(0, 0, self.homeScrollView.bounds.width, tabHeight)//CGRectMake(0, homeScrollView.bounds.height, homeScrollView.bounds.width, tabHeight)
        self.viewTab.tintColor = UIColor.whiteColor()
        self.viewTab.backgroundImage = Util.createImageWithColor(Color.gray, width: 1.0, height: 1.0)
        self.viewTab.shadowImage = Util.createImageWithColor(UIColor.clearColor(), width: 1.0, height: 1.0)
        self.viewTab.selectionIndicatorImage = Util.createImageWithColor(Color.red, width: 74.0, height: 49.0) // TODO: need to check deveice 6+ set to 84
        var viewTabBarItemForRank = UITabBarItem(title: "排行", image: UIImage(named: "ranking.png"), tag: 1)
        var viewTabBarItemForStatistics = UITabBarItem(title: "统计", image: UIImage(named: "statistics.png"), tag: 2)
        var viewTabBarItemForDictionary = UITabBarItem(title: "词库", image: UIImage(named: "dictionary.png"), tag: 3)
        var viewTabBarItemForSettings = UITabBarItem(title: "设置", image: UIImage(named: "settings.png"), tag: 4)
        
        var viewTabBarItemForAccount = UITabBarItem(title: "账户", image: UIImage(named: "account.png"), tag: 5)
        self.viewTab.setItems([
            viewTabBarItemForRank,
            viewTabBarItemForStatistics,
            viewTabBarItemForDictionary,
            viewTabBarItemForSettings,
            viewTabBarItemForAccount
            ], animated: true)
        srollViewForWrapViewTab.addSubview(self.viewTab)
        self.homeScrollView.addSubview(srollViewForWrapViewTab)
        
        
        // scroll view for tab items.
        var viewWidth = self.homeScrollView.frame.width
        var viewHeight = self.homeScrollView.frame.height - 49 - 20
        
        self.scrollViewForTabItems = UIScrollView()
        self.scrollViewForTabItems.frame = CGRectMake(0, self.homeScrollView.frame.height + 49, viewWidth, viewHeight)
        self.scrollViewForTabItems.backgroundColor = UIColor.purpleColor()
        self.scrollViewForTabItems.pagingEnabled = true
        self.scrollViewForTabItems.showsHorizontalScrollIndicator = false
        self.scrollViewForTabItems.bounces = false
        self.scrollViewForTabItems.delegate = self
        self.scrollViewForTabItems.contentSize = CGSize(width: viewWidth * 5, height: viewHeight)
        self.scrollViewForTabItems.contentOffset = CGPoint(x: viewWidth * 2, y: 0)
        self.homeScrollView.addSubview(self.scrollViewForTabItems)
        
        var rankController = RankController()
        self.addChildViewController(rankController)
        self.scrollViewForTabItems.addSubview(rankController.view)
        
        var statisticsController = StatisticsController()
        self.addChildViewController(statisticsController)
        self.scrollViewForTabItems.addSubview(statisticsController.view)
        
        var dictionaryController = DictionaryController()
        self.addChildViewController(dictionaryController)
        self.scrollViewForTabItems.addSubview(dictionaryController.view)
        
        var settingsController = SettingsController()
        self.addChildViewController(settingsController)
        self.scrollViewForTabItems.addSubview(settingsController.view)
        
        var accountController = AccountController()
        self.addChildViewController(accountController)
        self.scrollViewForTabItems.addSubview(accountController.view)
        
        self.scrollToPage(page: 2)
    }
    
    func getFrameOfSubTabItem(page: Int) -> CGRect {
        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height - 49 - 20
        return CGRectMake(viewWidth * CGFloat(page), 0, viewWidth, viewHeight)
    }
    
    func getPageIndex() -> Int {
        return self.viewTab.selectedItem!.tag - 1
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var parentController = self.parentViewController as ApplicationController
        
        if (scrollView == self.scrollViewForTabItems) {
            var page = Int(scrollView.contentOffset.x / self.view.frame.width)
            self.scrollToPage(page: page)
            
            switch(page) {
            case 0:
                parentController.setCurrentPage(PageCode.Rank)
            case 1:
                parentController.setCurrentPage(PageCode.Statistics)
            case 2:
                parentController.setCurrentPage(PageCode.Dictionary)
            case 3:
                parentController.setCurrentPage(PageCode.Settings)
            case 4:
                parentController.setCurrentPage(PageCode.Account)
            default:
                break
            }
        }
        
        if (scrollView == self.homeScrollView) {
            var page = Int(round(scrollView.contentOffset.y / self.view.frame.height))
            var subPage = self.getPageIndex()
            if (page == 0) {
                parentController.setCurrentPage(PageCode.Home)
            } else {
                switch(subPage) {
                case 0:
                    parentController.setCurrentPage(PageCode.Rank)
                case 1:
                    parentController.setCurrentPage(PageCode.Statistics)
                case 2:
                    parentController.setCurrentPage(PageCode.Dictionary)
                case 3:
                    parentController.setCurrentPage(PageCode.Settings)
                case 4:
                    parentController.setCurrentPage(PageCode.Account)
                default:
                    break
                }
            }
        }
    }
    
    func scrollToPage(page: Int = 2) {
        self.scrollViewForTabItems.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(page), y: 0), animated: true)
        
        var items: Array = self.viewTab.items! as Array
        self.viewTab.selectedItem = items[page] as? UITabBarItem
        
        var parentController = self.parentViewController as ApplicationController
        switch(page) {
        case 0:
            parentController.setCurrentPage(PageCode.Rank)
        case 1:
            parentController.setCurrentPage(PageCode.Statistics)
        case 2:
            parentController.setCurrentPage(PageCode.Dictionary)
        case 3:
            parentController.setCurrentPage(PageCode.Settings)
        case 4:
            parentController.setCurrentPage(PageCode.Account)
        default:
            break
        }
    }
    
    func onTapArticleIcon(sender: UIView) {
        var favouriteArticleController = FavouriteArticleController()
        self.addChildViewController(favouriteArticleController)
        self.view.addSubview(favouriteArticleController.view)
        self.searchBar.resignFirstResponder()
    }
    
    
    func onTapHelpIcon(sender: UIView) {
        var helpController = HelpController()
        self.addChildViewController(helpController)
        self.view.addSubview(helpController.view)
        self.searchBar.resignFirstResponder()
    }
    
    func onRecommendTapped(recognizer: UITapGestureRecognizer) {
        var parentController = self.parentViewController as ApplicationController
        parentController.scrollToPage(page: 1)    }
    
    func onStartLearnTapped(sender: UIView) {
        var parentController = self.parentViewController as ApplicationController
        parentController.scrollToPage(page: 3)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        var searchWordResultController = SearchWordResultController()
        self.addChildViewController(searchWordResultController)
        self.view.addSubview(searchWordResultController.view)
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        self.scrollToPage(page: item.tag - 1)
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