//
//  ViewController.swift
//  words
//
//  Created by shoyer on 15/1/29.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import UIKit


// 首页,
class HomeController: BaseUIController, UISearchBarDelegate{
    
    @IBOutlet weak var wordSearchBar: UISearchBar!
    @IBOutlet weak var label: UILabel!
    
    let udid: String = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    var scrollView: UIScrollView!
    
    var viewArticleForChinese: UIView!
    var viewArticleForEnglish: UIView!
    var viewHome: UIView!
    var viewLearnWord: UIView!
    var viewWordDetail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrial()
    }
    
    @IBAction func gotoDicVC(sender: UIButton) {
        
        LogUtil.log("gotoDicVC")
        
        self.presentViewController(DictionaryController(), animated: true, completion: nil)
    }
    
    func getTrial() {
        var params: DMNetParam = DMNetParam(httpPath:"/user/trial")
        params.addParamValuePair("udid", value:self.udid)
        
        class TrialDe:APIDataDelegate{
            weak var parent:HomeController!=nil
            init(parent:HomeController) {
                self.parent=parent
            }
            
            func dateReqBack(httpPath:String, data:AnyObject, code:Int, message:String) {
                parent.loginUser(data)
            }
        }
        controller.getNetData(params, delegate: TrialDe(parent:self))
    }
    
    func loginUser(data: AnyObject) {
        LogUtil.log("loginUser")
        var username = data["username"] as? String
        
        LogUtil.log("username2=\(username)")
        
        label.text = username
        
        var params: DMNetParam = DMNetParam(httpPath:"/user/login")
        params.addParamValuePair("username", value:username!)
        params.addParamValuePair("password", value:"sfas")
        params.addParamValuePair("udid", value:self.udid)
        
        class LoginDe:APIDataDelegate{
            weak var parent:HomeController!=nil
            init(parent:HomeController) {
                self.parent=parent
            }
            func dateReqBack(httpPath:String, data:AnyObject, code:Int, message:String) {
                parent.getActiveTime(data)
            }
        }
        controller.getNetData(params, delegate: LoginDe(parent:self))
    }
    
    
    func userRegister(data: AnyObject) {
        
    }
    
    func getActiveTime(data: AnyObject) {
    
        var params: DMNetParam = DMNetParam(httpPath:"/user/activeTime")
        params.addParamValuePair("seconds", value:"60")
        params.addParamValuePair("sign", value:"fasffs")
        
        class ActiveTimeDe:APIDataDelegate{
            func dateReqBack(httpPath:String, data:AnyObject, code:Int, message:String) {
                
            }
        }
        controller.getNetData(params, delegate: ActiveTimeDe())
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

