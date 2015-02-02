
import UIKit

class ApplicationController: UIViewController, UIScrollViewDelegate, APIDataDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height
        
        var scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.frame = self.view.frame
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: viewWidth * 5, height: viewHeight)
        scrollView.contentOffset = CGPoint(x: viewWidth * 2, y: 0)
        self.view.addSubview(scrollView)
        
        var articleForChineseController = ArticleForChineseController()
        self.addChildViewController(articleForChineseController)
        articleForChineseController.view.frame = CGRectMake(0, 0, viewWidth, viewHeight)
        scrollView.addSubview(articleForChineseController.view)
        
        var articleForEnglishController = ArticleForEnglishController()
        self.addChildViewController(articleForEnglishController)
        articleForEnglishController.view.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight)
        scrollView.addSubview(articleForEnglishController.view)
        
        var homeController = HomeController()
        self.addChildViewController(homeController)
        homeController.view.frame = CGRectMake(viewWidth * 2, 0, viewWidth, viewHeight)
        scrollView.addSubview(homeController.view)
        
        var learnWordController = LearnWordController()
        self.addChildViewController(learnWordController)
        learnWordController.view.frame = CGRectMake(viewWidth * 3, 0, viewWidth, viewHeight)
        scrollView.addSubview(learnWordController.view)
        
        var wordDetailController = WordDetailController()
        self.addChildViewController(wordDetailController)
        wordDetailController.view.frame = CGRectMake(viewWidth * 4, 0, viewWidth, viewHeight)
        scrollView.addSubview(wordDetailController.view)
    }
    
}

