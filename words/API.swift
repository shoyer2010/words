
import Foundation

class API: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
//    struct Inner {
//        static let instance: API = API(host: "dev.coolhey.cn", port: "1337")
//    }
    
    class var instance: API {
//        return Inner.instance
//        return API(host: "dev.coolhey.cn", port: "1337")
        return API(host: "localhost", port: "1337")
    }
    
    let host: String
    let port: String
    let apiEntry: String
    var connection: NSURLConnection?
    var responseData: NSMutableData = NSMutableData()
    var responseCode: Int?
    var delegate: APIDataDelegate?
    var api: String?
    
    init(host: String, port: String = "80") {
        self.host = host
        self.port = port
        self.apiEntry = "http://" + self.host + ":" + self.port
    }
    
    func request(api: String, method: String = "GET", params: NSMutableDictionary = NSMutableDictionary()) -> Void {
        self.api = api
        
        var queryString: String = "?"
        for (key, value) in params {
            queryString += "&\(key)=\(value)"
        }
        
        var url: NSURL = NSURL(string: self.apiEntry + self.api!)!
        if (method == "GET") {
            url = NSURL(string: self.apiEntry + self.api! + queryString)!
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        
        if (method == "POST") {
            request.HTTPBody = NSString(string: queryString).dataUsingEncoding(NSUTF8StringEncoding)
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
    
    func post(api: String, delegate: APIDataDelegate, params: NSMutableDictionary = NSMutableDictionary()) {
        self.request(api, method: "POST", params: params)
        self.delegate = delegate
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("http request failed!!!!!");
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSHTTPURLResponse) {
//        println("start response done!")
        self.responseCode = response.statusCode
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
//        println("data coming")
        self.responseData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
//        println("data load done")
        var data: AnyObject = NSJSONSerialization.JSONObjectWithData(self.responseData, options: NSJSONReadingOptions.MutableContainers, error:nil)! // TODO: need error handle
        
        
        println(self.api! + " Response: \(self.responseCode)")
        
        var dataString = NSString(data: self.responseData, encoding: NSUTF8StringEncoding)!
        println(dataString)
        
        if (self.responseCode == 200) {
            switch(self.api!) {
            case "/user/trial":
                self.delegate!.userTrial?(data)
            case "/user/register":
                self.delegate!.userRegister?(data)
            case "/user/login":
                self.delegate!.userLogin?(data)
            case "/user/activeTime":
                self.delegate!.activeTime?(data)
            default:
                self.delegate!.error?(Error(message: "Not matched API"), api: self.api!)
            }
        } else {
            self.delegate!.error?(Error(message: dataString, code: self.responseCode!), api: self.api!)
        }
    }
}