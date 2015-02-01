
import Foundation

class API: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    class var instance: API {
        
        return API(host: Config.HOST_URL, port: Config.HOST_PORT)
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
        self.apiEntry = self.host + ":" + self.port
    }
    
    func request(api: String, method: String = "GET", params: DMNetParam, file: NSData? = nil) -> Void {
        self.api = api
        
        var queryString: String = "?"
        for (key, value) in params.httpParams {
            queryString += "&\(key)=\(value)"
        }
        
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

                for (key, value) in params.httpParams {
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
        LogUtil.log(self.api! + " request--------------------------------------")
        LogUtil.log("API: \(self.connection?.originalRequest.HTTPMethod) \(self.connection?.originalRequest.URL)")
        LogUtil.log(self.api! + " params: " + queryString)
    }
    
    func get(api: String, delegate: APIDataDelegate, params: DMNetParam) {
        self.request(api, method: "GET", params: params)
        self.delegate = delegate
    }
    
    func post(api: String, delegate: APIDataDelegate, params: DMNetParam, file: NSData? = nil) {
        self.request(api, method: "POST", params: params, file: file)
        self.delegate = delegate
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        LogUtil.log("http request failed!!!!!");
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
                //self.delegate!.dictionarySyncDictionary!(self.attachmentSavePath!, progress: Float(self.attachmentReceivedSize) / Float(self.attachmentSize!))
                
                var progressData:NSMutableDictionary = NSMutableDictionary()
                
                progressData.setValue(Float(self.attachmentReceivedSize) / Float(self.attachmentSize!), forKey: "progress")
                
                self.delegate!.dateReqBack("/dictionary/syncDictionary", data: progressData, code: 200, message: "Not matched API")
                
            default:
                //self.delegate!.error?(Error(message: "Not matched API"), api: self.api!)
            
                self.delegate!.dateReqBack("", data: "", code: 400, message: "Not matched API")
            }
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        LogUtil.log(self.api! + " Response: \(self.responseCode)")
        
        var data: AnyObject?
        var dataString: NSString?
        if (self.attachmentFilename != nil && self.attachmentSize > 0) {
            self.responseData.writeToFile(self.attachmentSavePath!, atomically: true)
            println("save file to: " + self.attachmentSavePath!)
            data = self.attachmentSavePath!
        } else {
            data = NSJSONSerialization.JSONObjectWithData(self.responseData, options: NSJSONReadingOptions.MutableContainers, error:nil)
            
            dataString = NSString(data: self.responseData, encoding: NSUTF8StringEncoding)!
        }
        
        LogUtil.log("data=\(dataString)")
        
        //我本来的想法是，向返回的json结构中插入code和message以及字典下载的progress键值对。这样返回的数据就整齐了
        if self.responseCode==200 {
            self.delegate!.dateReqBack(self.api!, data: data!, code: self.responseCode!, message: dataString!)
        }else {
            self.delegate!.dateReqBack(self.api!, data: dataString!, code: self.responseCode!, message: dataString!)
        }

    }
}