import UIKit

class CoachViewController: UIViewController {

    var button = UIButton(type: .System)
    
    func getCoach(objectId: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let query = PFQuery(className: "Coaches").whereKey("objectId", equalTo: objectId)
            do {
                let coach = try query.findObjects().first! as PFObject
                if let name = coach.valueForKey("name") {
                    self.button.setTitle(name as! String, forState: .Normal)
                }
            } catch {
                print("Could not find the object")
            }
        }
    }
    
    convenience init(objectId: String) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.button.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 300, 150, 50)
        self.view.addSubview(self.button)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
