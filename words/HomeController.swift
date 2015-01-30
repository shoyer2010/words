//
//  ViewController.swift
//  words
//
//  Created by shoyer on 15/1/29.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import UIKit


// 首页
class HomeController: UIViewController, UISearchBarDelegate, APIDataDelegate {
    
    @IBOutlet weak var wordSearchBar: UISearchBar!
    @IBOutlet weak var label: UILabel!
    
    let udid: String = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var params: NSMutableDictionary = NSMutableDictionary()
        
        params.setValue(self.udid, forKey: "udid")
        API.instance.post("/user/trial", delegate: self, params: params)
    }
    
    func userTrial(data: AnyObject) {
        var username = data["username"] as? String
        label.text = username
        
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(username, forKey: "username")
        params.setValue("sfas", forKey: "password")
        params.setValue(self.udid, forKey: "udid")
        API.instance.get("/user/login", delegate: self, params: params)
    }
    
    func userRegister(data: AnyObject) {
        
    }
    
    func userLogin(data: AnyObject) {
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(60, forKey: "seconds")
        params.setValue("fasffs", forKey: "sign")
        API.instance.post("/user/activeTime", delegate: self, params: params)
    }
    
    func error(error: Error, api: String) {
        println("\(api) error -->>>>>>>>>>\(error.getMessage())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

