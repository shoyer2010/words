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
        homeScrollView.bounces = true
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
        viewTab.delegate = self
        viewTab.frame = CGRectMake(0, homeScrollView.bounds.height, homeScrollView.bounds.width, tabHeight)
        //        viewTab.barTintColor = Color.gray
        viewTab.tintColor = UIColor.whiteColor()
        viewTab.backgroundImage = Util.createImageWithColor(Color.gray, width: 1.0, height: 1.0)
        viewTab.shadowImage = Util.createImageWithColor(UIColor.clearColor(), width: 1.0, height: 1.0)
        viewTab.selectionIndicatorImage = Util.createImageWithColor(Color.red, width: 76.0, height: 49.0) //UIImage(named: "red")
        
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
        homeScrollView.bringSubviewToFront(viewTab)

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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

