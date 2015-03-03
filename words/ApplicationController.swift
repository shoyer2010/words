
import UIKit

class ApplicationController: UIViewController, UIScrollViewDelegate, APIDataDelegate {
    
    var scrollView: UIScrollView!
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.LightContent
    var currentPage: PageCode?
    var previousPage: PageCode?
    var articleForChineseController: ArticleForChineseController!
    var articleForEnglishController: ArticleForEnglishController!
    var homeController: HomeController!
    var learnWordController: LearnWordController!
    var wordDetailController: WordDetailController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height
        
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.frame = self.view.frame
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: viewWidth * 5, height: viewHeight)
        self.view.addSubview(self.scrollView)
        
        articleForChineseController = ArticleForChineseController()
        self.addChildViewController(articleForChineseController)
        articleForChineseController.view.frame = CGRectMake(0, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(articleForChineseController.view)
        
        articleForEnglishController = ArticleForEnglishController()
        self.addChildViewController(articleForEnglishController)
        articleForEnglishController.view.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(articleForEnglishController.view)
        
        homeController = HomeController()
        self.addChildViewController(homeController)
        homeController.view.frame = CGRectMake(viewWidth * 2, 0, viewWidth, viewHeight)
        articleForEnglishController.delegate = homeController
        self.scrollView.addSubview(homeController.view)
        
        learnWordController = LearnWordController()
        self.addChildViewController(learnWordController)
        learnWordController.view.frame = CGRectMake(viewWidth * 3, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(learnWordController.view)
        
        wordDetailController = WordDetailController()
        wordDetailController.delegate = learnWordController
        self.addChildViewController(wordDetailController)
        wordDetailController.view.frame = CGRectMake(viewWidth * 4, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(wordDetailController.view)
        
        self.scrollToPage(page: 2)
    }

    
    func scrollToPage(page: Int = 2) {
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(page), y: 0), animated: true)
        })
        
        switch (page) {
        case 0:
            self.setCurrentPage(PageCode.ArticleForChinese)
        case 1:
            self.setCurrentPage(PageCode.ArticleForEnglish)
        case 2:
            self.setCurrentPage(PageCode.Home)
        case 3:
            self.setCurrentPage(PageCode.LearnWord)
        case 4:
            self.setCurrentPage(PageCode.WordDetail)
        default:
            break
        }
    }
    
    func setCurrentPage(page: PageCode) {
        self.currentPage = page
        
        switch(page) {
        case PageCode.Home:
            self.setUIStatusBarStyle(UIStatusBarStyle.LightContent)
        case PageCode.ArticleForEnglish:
            self.setUIStatusBarStyle(UIStatusBarStyle.LightContent)
        case PageCode.ArticleForChinese:
            self.setUIStatusBarStyle(UIStatusBarStyle.LightContent)
        default:
            self.setUIStatusBarStyle(UIStatusBarStyle.Default)
        }
        
        if (self.previousPage != self.currentPage) {
            var info = NSMutableDictionary()
            info.setValue(page.rawValue, forKey: "currentPage")
            info.setValue(self.previousPage?.rawValue, forKey: "previousPage")
            NSNotificationCenter.defaultCenter().postNotificationName(EventKey.ON_PAGE_CHAGNE, object: self, userInfo: info)
        }
        self.previousPage = self.currentPage
    }
    
    func getCurrentPage() -> PageCode {
        return self.currentPage!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func setUIStatusBarStyle(style: UIStatusBarStyle) {
        self.statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView == self.scrollView) {
            var page = Int(scrollView.contentOffset.x / self.view.frame.width)
            self.scrollToPage(page: page)
        }
    }
}

