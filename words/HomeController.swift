import UIKit

class HomeController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UIScrollViewDelegate, APIDataDelegate, SearchWordResultDelegate, ArticleForEnglishDelegate {
    
    var searchBar: UISearchBar!
    var scrollViewForTabItems: UIScrollView!
    var viewTab: UITabBar!
    var homeScrollView: UIScrollView!
    
    var englishLabel: UILabel!
    var chineseLabel: UILabel!
    
    var dictionaryLabel: UILabel!
    
    var rankLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoginSuccess:", name: EventKey.ON_LOGIN_SUCCESS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLearningDictionaryChange:", name: EventKey.ON_LEARNING_DICTIONARY_CHANGED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDictionaryDeleted:", name: EventKey.ON_DICTIONARY_DELETED, object: nil)
        

        self.initView()
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
        homeBody.backgroundColor = Color.appBackground
        
        var todayRecommend = UILabel(frame: CGRect(x: 15, y: 10, width: homeBody.frame.width - 30, height: 30))
        todayRecommend.font = UIFont(name: todayRecommend.font.fontName, size: CGFloat(16))
        todayRecommend.text = "今日推荐"
        homeBody.addSubview(todayRecommend)
        
        var recommendView = UIView(frame: CGRect(x: 15, y: 40, width: viewHomePage.frame.width - 30, height: 102))
        recommendView.backgroundColor = Color.blockBackground
        recommendView.layer.cornerRadius = Layer.cornerRadius
        recommendView.layer.shadowColor = Layer.shadowColor
        recommendView.layer.shadowRadius = Layer.shadowRadius
        recommendView.layer.shadowOffset = Layer.shadowOffset
        recommendView.layer.shadowOpacity = Layer.shadowOpacity
        
        englishLabel = UILabel(frame: CGRect(x: 10, y: 3, width: recommendView.frame.width - 20, height: recommendView.frame.height / 2))
        recommendView.addSubview(englishLabel)
        
        chineseLabel = UILabel(frame: CGRect(x: 10, y: recommendView.frame.height / 2 + 2, width: recommendView.frame.width - 20, height: recommendView.frame.height / 2))
        recommendView.addSubview(chineseLabel)
        
        recommendView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onRecommendTapped:"))
        homeBody.addSubview(recommendView)
        self.setTodayRecommend()
        
        var needToLearnIcon = UIView(frame: CGRect(x: 60, y: 180, width: 24, height: 24))
        needToLearnIcon.backgroundColor = UIColor(patternImage: UIImage(named: "needToLearnIcon.png")!)
        homeBody.addSubview(needToLearnIcon)
        
        var needToLearnLabel = UILabel(frame: CGRect(x: 90, y: 180, width: 250, height: 24))
        needToLearnLabel.userInteractionEnabled = true
        needToLearnLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onNeedToLearnLabelTapped:"))
        needToLearnLabel.text = "45个单词需要复习"
        homeBody.addSubview(needToLearnLabel)
        
        var rankIcon = UIView(frame: CGRect(x: 60, y: 220, width: 24, height: 24))
        rankIcon.backgroundColor = UIColor(patternImage: UIImage(named: "rankIcon.png")!)
        homeBody.addSubview(rankIcon)
        
        rankLabel = UILabel(frame: CGRect(x: 90, y: 220, width: 250, height: 24))
        rankLabel.text = "活跃度排名"
        rankLabel.userInteractionEnabled = true
        rankLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onRankLabelTapped:"))
        homeBody.addSubview(rankLabel)
        self.setActiveRank()
        
        var dictionaryIcon = UIView(frame: CGRect(x: 60, y: 260, width: 24, height: 24))
        dictionaryIcon.backgroundColor = UIColor(patternImage: UIImage(named: "dictionaryIcon.png")!)
        homeBody.addSubview(dictionaryIcon)
        
        dictionaryLabel = UILabel(frame: CGRect(x: 90, y: 260, width: homeBody.frame.width - 105, height: 24))
        dictionaryLabel.userInteractionEnabled = true
        dictionaryLabel.text = "大学英语4级"
        dictionaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onDictionaryLabelTapped:"))
        homeBody.addSubview(dictionaryLabel)
        self.setLearingDictionaryLabel()
        
        var startLearn = UIView(frame: CGRect(x: homeBody.frame.width / 2 - 50, y: homeBody.frame.height - 120, width: 100, height: 100))
        startLearn.backgroundColor = UIColor(patternImage: UIImage(named: "startLearn.png")!)
        startLearn.layer.cornerRadius = 50
        startLearn.layer.masksToBounds = true
        startLearn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onStartLearnTapped:"))
        
        var startLearnLabel = UILabel(frame: CGRect(x: 20, y: 2, width: 100, height: 80))
        startLearnLabel.text = "开始受虐"
        startLearnLabel.font = UIFont(name: startLearnLabel.font.fontName, size: CGFloat(15))
        startLearnLabel.textColor = Color.red
        startLearnLabel.layer.shadowColor = UIColor.redColor().CGColor
        startLearnLabel.layer.shadowOpacity = 0.3
        startLearnLabel.layer.shadowRadius = 2
        startLearnLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
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
    
    func onLoginSuccess(notification: NSNotification) {
        self.setTodayRecommend()
        self.setLearingDictionaryLabel()
        self.setActiveRank()
    }
    
    func onLearningDictionaryChange(nofification: NSNotification) {
        self.setLearingDictionaryLabel()
    }
    
    func onDictionaryDeleted(nofification: NSNotification) {
        self.setLearingDictionaryLabel()
    }
    
    func setTodayRecommend() {
        var user: NSDictionary? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER) as? NSDictionary
        
        if (user != nil) {
            englishLabel.text = user!.valueForKeyPath("recommendArticle.titleEnglish") as? String
            englishLabel.numberOfLines = 2
            englishLabel.font = UIFont(name: "Cochin", size: CGFloat(16))
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            paragraphStyle.lineSpacing = 5
            var attributes = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: englishLabel.font,
                NSForegroundColorAttributeName: Color.red,
                NSStrokeWidthAttributeName: NSNumber(float: -1.0)
                ])
            englishLabel.attributedText = NSAttributedString(string: englishLabel.text!, attributes: attributes)
            
            chineseLabel.text = user!.valueForKeyPath("recommendArticle.titleChinese") as? String
            chineseLabel.numberOfLines = 2
            chineseLabel.font = UIFont(name: Fonts.kaiti, size: CGFloat(14))
            var paragraphStyleForChinese = NSMutableParagraphStyle()
            paragraphStyleForChinese.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            paragraphStyleForChinese.lineSpacing = 7
            var attributesForChinese = NSDictionary(dictionary: [
                NSParagraphStyleAttributeName: paragraphStyleForChinese,
                NSFontAttributeName: chineseLabel.font,
                NSForegroundColorAttributeName: Color.lightGray,
                NSStrokeWidthAttributeName: NSNumber(float: -1.0)
                ])
            chineseLabel.attributedText = NSAttributedString(string: chineseLabel.text!, attributes: attributesForChinese)
        }
    }
    
    func setLearingDictionaryLabel() {
        self.dictionaryLabel.text = Util.learningString()
        self.dictionaryLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    }
    
    func setActiveRank() {
        var user: NSDictionary? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER) as? NSDictionary
        
        if (user != nil) {
            var rank = user!.valueForKey("activeRank") as Int
            self.rankLabel.text = "活跃度排名 \(rank)"
        }
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
    
    func scrollToPageUpAndDown(page: Int = 0) {
        var parentController = self.parentViewController as ApplicationController
        
        if (page == 0) {
            self.homeScrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * CGFloat(page)), animated: true)
            parentController.setCurrentPage(PageCode.Home)
        } else {
            self.homeScrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height * CGFloat(page) - 20), animated: true)

            var subPage = self.getPageIndex()
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
        parentController.articleForEnglishController.delegate = self
        parentController.scrollToPage(page: 1)
    }
    
    func onNeedToLearnLabelTapped(recogizer: UITapGestureRecognizer) {
        var parentController = self.parentViewController as ApplicationController
        parentController.scrollToPage(page: 3)
    }
    
    func onDictionaryLabelTapped(recognizer: UITapGestureRecognizer) {
        self.scrollToPageUpAndDown(page: 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
            self.scrollToPage(page: 2)
        })
    }
    
    func onRankLabelTapped(recognizer: UITapGestureRecognizer) {
        self.scrollToPageUpAndDown(page: 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
            self.scrollToPage(page: 0)
        })
    }
    
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
        searchWordResultController.delegate = self
        self.addChildViewController(searchWordResultController)
        self.view.addSubview(searchWordResultController.view)
    }
    
    func searchWord() -> String {
        return self.searchBar.text
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        self.scrollToPage(page: item.tag - 1)
    }
    
    func setArticleId() -> String {
        var user: NSDictionary? = NSUserDefaults.standardUserDefaults().objectForKey(CacheKey.USER) as? NSDictionary
        
        if (user != nil) {
            return user!.valueForKeyPath("recommendArticle.id") as String
        }
            
        return ""
    }
    
    func error(error: Error, api: String) {
        ErrorView(view: self.view, message: error.getMessage())
    }
}