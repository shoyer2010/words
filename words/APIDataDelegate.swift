
@objc protocol APIDataDelegate {
    optional func error(error: Error, api: String)
    
    optional func userTrial(AnyObject)
    
    optional func userRegister(AnyObject)
    
    optional func userLogin(AnyObject)
    
    optional func activeTime(AnyObject)
}