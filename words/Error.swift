
import Foundation

class Error: NSObject {
    
    let code: Int
    let message: String
    
    init(message: String, code: Int = 500) {
        self.code = code
        self.message = message
    }
    
    func getCode() -> Int {
        return self.code
    }
    
    func getMessage() -> String {
        return self.message
    }
}