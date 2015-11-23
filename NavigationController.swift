import UIKit

class NavigationController: UINavigationController {
    var navBar: UINavigationBar?
    var navItem: UINavigationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navItem = UINavigationItem(title: "Report Cards")
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "barButtonItemPressed:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Nothing Yet", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        self.navBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44))
        self.navBar!.items = [navigationItem]
        self.view.addSubview(navigationBar)
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
