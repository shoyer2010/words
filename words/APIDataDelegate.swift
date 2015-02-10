
@objc protocol APIDataDelegate {
    optional func error(error: Error, api: String)
    
    optional func userTrial(AnyObject)
    
    optional func userRegister(AnyObject)
    
    optional func userLogin(AnyObject)
    
    optional func activeTime(AnyObject)
    
    
    
    // 字典
    optional func dictionaryList(AnyObject)
    
    optional func dictionarySyncDictionary(filePath: AnyObject, progress: Float)
    
    optional func dictionaryDownloadDictionary(filePath: AnyObject, progress: Float)

}