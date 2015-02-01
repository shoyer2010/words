import UIKit

class DictionaryController: UIViewController, APIDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        API.instance.get("/dictionary/list", delegate: self)
    }
    
    func dictionaryList(data: AnyObject) {
        println(self.view)
        var params: NSMutableDictionary = NSMutableDictionary()
//        params.setValue(1, forKey: "sync")
//
//        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("54cc5af6c5e20c9b492b39ae.db")
//        var data: NSData? = NSData(contentsOfFile: path)
//        API.instance.post("/dictionary/syncDictionary", delegate: self,  params: params, file: data?)
    }
    
    func dictionarySyncDictionary(filePath: AnyObject, progress: Float) {
        println(filePath)
        println(progress)
    }
    
    @IBAction func onValueChanged(sender: UISwitch) {
        println(sender.on)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}