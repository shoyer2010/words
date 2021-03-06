
@objc protocol APIDataDelegate {
    optional func error(error: Error, api: String)
    
    optional func userTrial(AnyObject)
    
    optional func userRegister(AnyObject)
    
    optional func userLogin(AnyObject)
    
    optional func changePassword(AnyObject)
    
    optional func activeTime(AnyObject)
    
    optional func userServiceList(AnyObject)
    
    optional func userOrder(AnyObject)
    
    optional func userReclaimShareService(AnyObject)
    
    
    // 字典
    optional func dictionaryList(AnyObject)
    
    optional func dictionarySyncDictionary(progress: Float, params: NSMutableDictionary)
    
    optional func dictionaryDownload(progress: Float, params: NSMutableDictionary)
    
    optional func dictionaryCustomWord(AnyObject, params: NSMutableDictionary)
    
    
    // 单词
    optional func wordSearch(AnyObject)
    
    optional func wordWrongWords(AnyObject)
    
    // 例句
    optional func sentenceGetByWordId(AnyObject)
    
    // 文章
    optional func articleDetail(AnyObject)
    
    optional func articleFavourite(AnyObject)
    
    optional func articleCancelFavourite(AnyObject)
    
    optional func articleFavouriteList(AnyObject)
    
    //排名
    optional func rankActive(AnyObject)
    
    optional func rankMasteredWords(AnyObject)
    
    //版本
    optional func versionCheck(AnyObject)
    
    optional func versionUrl(AnyObject)
}