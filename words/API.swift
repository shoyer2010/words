
import Foundation

class API: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
//    struct Inner {
//        static let instance: API = API(host: "dev.coolhey.cn", port: "1337")
//    }
    
    class var instance: API {
//        return Inner.instance
        return API(host: Server.host, port: Server.port)
    }
    
    let host: String
    let port: String
    let apiEntry: String
    var connection: NSURLConnection?
    var responseData: NSMutableData = NSMutableData()
    var responseCode: Int?
    var delegate: APIDataDelegate?
    var api: String?
    var params: NSMutableDictionary?
    var attachmentFilename: String?
    var attachmentSize: Int?
    var attachmentSavePath: NSString?
    var attachmentReceivedSize: Int = 0
    
    init(host: String, port: String = "80") {
        self.host = host
        self.port = port
        self.apiEntry = "http://" + self.host + ":" + self.port
    }
    
    func request(api: String, method: String = "GET", params: NSMutableDictionary = NSMutableDictionary(), file: NSData? = nil) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.api = api
        self.params = params
        
        var queryString: String = "?"
        for (key, value) in params {
            queryString += "&\(key)=\(value)"
        }
        queryString = queryString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var url: NSURL = NSURL(string: self.apiEntry + self.api!)!
        if (method == "GET") {
            url = NSURL(string: self.apiEntry + self.api! + queryString)!
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        
        if (method == "POST") {
            if (file == nil) {
                request.HTTPBody = NSString(string: queryString).dataUsingEncoding(NSUTF8StringEncoding)
            } else {
                self.attachmentSavePath = ""
                var boundary = "||"
                request.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
                var sendBody = NSMutableData()

                for (key, value) in params {
                    sendBody.appendData(NSString(string: "--" + boundary + "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                    sendBody.appendData(NSString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                    sendBody.appendData(NSString(string: "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                    sendBody.appendData(NSString(string: "\(value)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                }

                sendBody.appendData(NSString(string: "--" + boundary + "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                sendBody.appendData(NSString(string: "Content-Disposition: form-data; name=\"file\"; filename=\"file.db\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//                sendBody.appendData(NSString(string: "Content-Type: application/octet-stream\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                sendBody.appendData(NSString(string: "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                sendBody.appendData(file!)
                sendBody.appendData(NSString(string: "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)

                sendBody.appendData(NSString(string: "--" + boundary + "--\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                sendBody.appendData(NSString(string: "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                request.HTTPBody = sendBody
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.connection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
            self.connection!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            self.connection!.start()
        })
        
        println(self.api! + " request--------------------------------------")
        println("API: \(self.connection?.originalRequest.HTTPMethod) \(self.connection?.originalRequest.URL)")
        println(self.api! + " params: " + queryString)
    }
    
    func get(api: String, delegate: APIDataDelegate, params: NSMutableDictionary = NSMutableDictionary()) {
        self.request(api, method: "GET", params: params)
        self.delegate = delegate
    }
    
    func post(api: String, delegate: APIDataDelegate, params: NSMutableDictionary = NSMutableDictionary(), file: NSData? = nil) {
        self.request(api, method: "POST", params: params, file: file)
        self.delegate = delegate
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        println("http request failed!!!!! \(error.code) \(error.localizedDescription)");
        
        var message = "网络请求失败:\(error.code) \(error.localizedDescription)"
        switch error.code {
        case -1001:
            message = "网络请求超时"
        case -1004:
            message = "服务器正在自我修复，请稍候再试^_-"
        case -1009:
            message = "网络不畅通，词圣无法与服务器约会了^_^"
        default:
            break
        }
        
        self.delegate!.error?(Error(message: message, code: error.code), api: self.api!)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSHTTPURLResponse) {
//        println("start response done!")
        self.responseCode = response.statusCode
        
        self.attachmentReceivedSize = 0
        if (response.allHeaderFields["Content-Disposition"] != nil) {
            self.attachmentFilename = NSString(string: response.allHeaderFields["Content-Disposition"] as String).componentsSeparatedByString("=")[1] as? String
            self.attachmentSize = (response.allHeaderFields["Content-Length"] as String).toInt()
            self.attachmentSavePath = Util.getFilePath(self.attachmentFilename!)
        } else {
            self.attachmentFilename = nil
            self.attachmentSize = 0
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
//        println("data coming")
        self.responseData.appendData(data)

        if (self.attachmentFilename != nil && self.attachmentSize > 0) {
            self.attachmentReceivedSize += data.length
            switch(self.api!) {
            case "/dictionary/syncDictionary":
                self.delegate!.dictionarySyncDictionary!(Float(self.attachmentReceivedSize) / Float(self.attachmentSize!), params: self.params!)
            case "/dictionary/download":
                self.delegate!.dictionaryDownload!(Float(self.attachmentReceivedSize) / Float(self.attachmentSize!), params: self.params!)
            default:
                self.delegate!.error?(Error(message: "Not matched API"), api: self.api!)
            }
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        println(self.api! + " Response: \(self.responseCode)")

        var data: AnyObject?
        var dataString: NSString?
        if (self.attachmentFilename != nil && self.attachmentSize > 0) {
            self.responseData.writeToFile(self.attachmentSavePath!, atomically: true)
            println("save file to: " + self.attachmentSavePath!)
            data = ["code": 0]
        } else {
            data = NSJSONSerialization.JSONObjectWithData(self.responseData, options: NSJSONReadingOptions.MutableContainers, error:nil) // TODO: need error handle
            dataString = NSString(data: self.responseData, encoding: NSUTF8StringEncoding)!
        }

        println(dataString)
        
        if (self.responseCode == 200 && (data!["code"] as Int) == 0) {
            var data: AnyObject? = data!["data"]
            
            if (data == nil) {
                data = []
            }
            
            switch(self.api!) {
            case "/user/trial":
                self.delegate!.userTrial?(data!)
            case "/user/register":
                self.delegate!.userRegister?(data!)
            case "/user/login":
                self.delegate!.userLogin?(data!)
            case "/user/changePassword":
                self.delegate!.changePassword?(data!)
            case "/user/activeTime":
                self.delegate!.activeTime?(data!)
            case "/user/serviceList":
                self.delegate!.userServiceList?(data!)
            case "/user/order":
                self.delegate!.userOrder?(data!)
            case "/dictionary/list":
                self.delegate!.dictionaryList!(data!)
            case "/dictionary/syncDictionary":
                self.delegate!.dictionarySyncDictionary!(1.0, params: self.params!)
            case "/dictionary/download":
                self.delegate!.dictionaryDownload!(1.0, params: self.params!)
            case "/dictionary/customWord":
                self.delegate!.dictionaryCustomWord!(data!, params: self.params!)
            case "/word/search":
                self.delegate!.wordSearch!(data!)
            case "/word/wrongWords":
                self.delegate!.wordWrongWords!(data!)
            case "/article/detail":
                self.delegate!.articleDetail!(data!)
            case "/article/favourite":
                self.delegate!.articleFavourite!(data!)
            case "/article/favouriteList":
                self.delegate!.articleFavouriteList!(data!)
            case "/rank/active":
                self.delegate!.rankActive!(data!)
            case "/rank/masteredWords":
                self.delegate!.rankMasteredWords!(data!)
            case "/sentence/getByWordId":
                self.delegate!.sentenceGetByWordId!(data!)
            case "/version/check":
                self.delegate!.versionCheck!(data!)
            case "/version/url":
                self.delegate!.versionUrl!(data!)
            default:
                self.delegate!.error?(Error(message: "No API matched"), api: self.api!)
            }
        } else {
            var code = data!["code"] as Int
            if (self.responseCode == 200 && code != 0) {
                self.delegate!.error?(Error(message: data!["message"] as String, code: code), api: self.api!)
            } else {
                self.delegate!.error?(Error(message: dataString!, code: self.responseCode!), api: self.api!)
            }
        }
    }
}