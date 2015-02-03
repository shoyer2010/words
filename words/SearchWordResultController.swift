//
//  SearchWordResultController.swift
//  words
//
//  Created by shoyer on 15/2/3.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation
import UIKit

class SearchWordResultController: UIViewController, APIDataDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = UIColor(red:1, green:1, blue:0, alpha: 1)
        self.view.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        
        
    }
}