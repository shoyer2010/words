//
//  CacheDataUitls.swift
//  words
//
//  Created by ios on 15-2-11.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation

struct CacheDataUtils {
    
    static let key_user_info = "key_user_info"
    static let key_user_id = "key_user_id"
    static let key_user_is_trial = "key_user_is_trial"
    
    static let key_dictionary_list = "key_dictionary_list"
    
    
    static func updateUserPassword(newPassword:String) {
        let userInfo:NSDictionary = getUserInfo() as NSDictionary
        
        saveUserInfo(userInfo.valueForKey("id")!, userName: userInfo.valueForKey("userName")!, passWord: newPassword, holyWater: userInfo.valueForKey("holyWater")!, isTrial: false)
    }
    
    
    static func saveUserInfo(id:AnyObject, userName:AnyObject, passWord:AnyObject?, holyWater:AnyObject, isTrial:Bool) {
        
        saveLocalData(key_user_is_trial, value: isTrial)
        
        if(isTrial) {
            let userTrialInfoDic = ["id":id, "userName":userName, "holyWater":holyWater]
            saveLocalData(key_user_info, value: userTrialInfoDic)
        }
        else {
            let userInfoDic = ["id":id, "userName":userName, "passWord":passWord!, "holyWater":holyWater]
            saveLocalData(key_user_info, value: userInfoDic)
        }
        
        saveLocalData(key_user_id, value: id)
    }
    
    static func getUserInfo() -> AnyObject? {
        if((getLocalData(key_user_info)) != nil) {
            return getLocalData(key_user_info)
        }
        
        return nil
    }
    
    static func isHasAnUser() ->Bool {
        var user: AnyObject? = getLocalData(key_user_id)
        
        LogUtils.log("isHasAnUser():user=\(user)")
        
        if(user != nil) {
            return true
        }
        
        return false
    }
    
    static func isUserTrial() ->Bool {
        return getLocalData(key_user_is_trial) as Bool
    }
    
    
    static func saveLocalData(key: String, value:AnyObject?) {
        var data:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        data.setObject(value, forKey: key)
    }
    
    static func getLocalData(key: String) -> AnyObject? {
        var data:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return data.objectForKey(key)
    }
    
}