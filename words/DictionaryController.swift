import UIKit

class DictionaryController: UIViewController, APIDataDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("dsfasdfsafsafsafsafsafasdfasdfasfd")
        API.instance.get("/dictionary/list", delegate: self)
    }
    
    func dictionaryList(data: AnyObject) {
        var params: NSMutableDictionary = NSMutableDictionary()
        params.setValue(2, forKey: "sync")

        API.instance.post("/dictionary/syncDictionary", delegate: self,  params: params)
    }
    
    func dictionarySyncDictionary(filePath: AnyObject, progress: Float) {
        println(filePath)
        println(progress)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}