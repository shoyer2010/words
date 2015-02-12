
import UIKit

class ApplicationController: UIViewController, UIScrollViewDelegate, APIDataDelegate {
    
    var scrollView: UIScrollView!
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.LightContent
    var currentPage: PageCode?
    
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
        
        var articleForChineseController = ArticleForChineseController()
        self.addChildViewController(articleForChineseController)
        articleForChineseController.view.frame = CGRectMake(0, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(articleForChineseController.view)
        
        var articleForEnglishController = ArticleForEnglishController()
        self.addChildViewController(articleForEnglishController)
        articleForEnglishController.view.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(articleForEnglishController.view)
        
        var homeController = HomeController()
        self.addChildViewController(homeController)
        homeController.view.frame = CGRectMake(viewWidth * 2, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(homeController.view)
        
        var learnWordController = LearnWordController()
        self.addChildViewController(learnWordController)
        learnWordController.view.frame = CGRectMake(viewWidth * 3, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(learnWordController.view)
        
        var wordDetailController = WordDetailController()
        self.addChildViewController(wordDetailController)
        wordDetailController.view.frame = CGRectMake(viewWidth * 4, 0, viewWidth, viewHeight)
        self.scrollView.addSubview(wordDetailController.view)
        
        self.scrollToPage(page: 2)
        
    }

    
    func scrollToPage(page: Int = 2) {
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(page), y: 0), animated: true)
        
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

