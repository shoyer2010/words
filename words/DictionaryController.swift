import UIKit

class DictionaryController: BaseUIController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var params:DMNetParam = DMNetParam(httpPath:"/dictionary/list")
        
        class DicListDe:APIDataDelegate{
            weak var parent:DictionaryController!=nil
            init(parent:DictionaryController) {
                self.parent=parent
            }
            
            func dateReqBack(httpPath:String, data:AnyObject, code:Int, message:String) {
                parent.dictionaryListBack(data)
            }
        }
        controller.getNetData(params, delegate: DicListDe(parent: self))
        
        //API.instance.get("/dictionary/list", delegate: self)
    }
    
    func dictionaryListBack(data: AnyObject) {
//        var params: NSMutableDictionary = NSMutableDictionary()
//        params.setValue(1, forKey: "sync")

        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("54cc5af6c5e20c9b492b39ae.db")
        var data: NSData? = NSData(contentsOfFile: path)
        //API.instance.post("/dictionary/syncDictionary", delegate: self,  params: params, file: data?)
        
        
        var params:DMNetParam = DMNetParam(httpPath:"/dictionary/syncDictionary")
        params.addParamValuePair("sync", value: "1")
        class DicSyncDe:APIDataDelegate{
            weak var parent:DictionaryController!=nil
            init(parent:DictionaryController) {
                self.parent=parent
            }
            
            func dateReqBack(httpPath:String, data:AnyObject, code:Int, message:String) {
                
            }
        }
        controller.getNetData(params, delegate: DicSyncDe(parent: self), file: data)
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