
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
        self.api = api
        
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
        
        self.connection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
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
        println("http request failed!!!!!");
        println(error)
        self.delegate!.error?(Error(message: "服务器正在维护，请稍候再试", code: 500), api: self.api!)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSHTTPURLResponse) {
//        println("start response done!")
        self.responseCode = response.statusCode
        
//        println(response)
        self.attachmentReceivedSize = 0
        if (response.allHeaderFields["Content-Disposition"] != nil) {
            self.attachmentFilename = NSString(string: response.allHeaderFields["Content-Disposition"] as String).componentsSeparatedByString("=")[1] as? String
            self.attachmentSize = (response.allHeaderFields["Content-Length"] as String).toInt()
            self.attachmentSavePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(self.attachmentFilename!)
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
                self.delegate!.dictionarySyncDictionary!(self.attachmentSavePath!, progress: Float(self.attachmentReceivedSize) / Float(self.attachmentSize!))
            case "/dictionary/download":
                self.delegate!.dictionaryDownloadDictionary!(self.attachmentSavePath!, progress: Float(self.attachmentReceivedSize) / Float(self.attachmentSize!))
            default:
                self.delegate!.error?(Error(message: "Not matched API"), api: self.api!)
            }
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        println(self.api! + " Response: \(self.responseCode)")

        var data: AnyObject?
        var dataString: NSString?
        if (self.attachmentFilename != nil && self.attachmentSize > 0) {
            self.responseData.writeToFile(self.attachmentSavePath!, atomically: true)
            println("save file to: " + self.attachmentSavePath!)
            data = self.attachmentSavePath!
        } else {
            data = NSJSONSerialization.JSONObjectWithData(self.responseData, options: NSJSONReadingOptions.MutableContainers, error:nil) // TODO: need error handle
            dataString = NSString(data: self.responseData, encoding: NSUTF8StringEncoding)!
        }

        println(dataString)
        
        if (self.responseCode == 200) {
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
            case "/dictionary/list":
                self.delegate!.dictionaryList!(data!)
            case "/dictionary/syncDictionary":
                self.delegate!.dictionarySyncDictionary!(data!, progress: 1.0)
            case "/dictionary/download":
                self.delegate!.dictionaryDownloadDictionary!(data!, progress: 1.0)
            case "/word/search":
                self.delegate!.wordSearch!(data!)
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
            default:
                self.delegate!.error?(Error(message: "Not matched API"), api: self.api!)
            }
        } else {
            if (data?["message"] as? String != nil) {
                self.delegate!.error?(Error(message: data!["message"] as String, code: self.responseCode!), api: self.api!)
            } else {
                self.delegate!.error?(Error(message: dataString!, code: self.responseCode!), api: self.api!)
            }
        }
    }
}