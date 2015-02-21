
@objc protocol APIDataDelegate {
    optional func error(error: Error, api: String)
    
    optional func userTrial(AnyObject)
    
    optional func userRegister(AnyObject)
    
    optional func userLogin(AnyObject)
    
    optional func changePassword(AnyObject)
    
    optional func activeTime(AnyObject)
    
    
    
    // 字典
    optional func dictionaryList(AnyObject)
    
    optional func dictionarySyncDictionary(filePath: AnyObject, progress: Float)
    
    optional func dictionaryDownloadDictionary(filePath: AnyObject, progress: Float)
    
    
    // 单词
    optional func wordSearch(AnyObject)
    
    // 文章
    optional func articleDetail(AnyObject)
    optional func articleFavourite(AnyObject)
    optional func articleFavouriteList(AnyObject)
    
    //排名
    optional func rankActive(AnyObject)
    optional func rankMasteredWords(AnyObject)
}