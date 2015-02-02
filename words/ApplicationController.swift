
import UIKit

class ApplicationController: UIViewController, UIScrollViewDelegate, APIDataDelegate {
    
    var scrollView: UIScrollView!
    
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
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

