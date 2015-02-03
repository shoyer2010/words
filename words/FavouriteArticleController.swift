//
//  FavouriteArticleController.swift
//  words
//
//  Created by shoyer on 15/2/3.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class FavouriteArticleController: UIViewController, APIDataDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = UIColor(red:0, green:1, blue:0, alpha: 1)
        
        var button = UIButton(frame: CGRect(x:100, y: 100, width: 100, height: 100))
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(self, action: "onButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var label = UILabel(frame: CGRect(x:0, y: 0, width: 100, height: 100))
        label.text = "返回"
        button.addSubview(label)
        
        var helpLabel = UILabel(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        helpLabel.text = "文章收藏页面"
        self.view.addSubview(helpLabel)
        self.view.addSubview(button)
    }
    
    func onButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    
}