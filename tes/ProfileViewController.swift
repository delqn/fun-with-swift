import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel()
        label.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 100, 150, 50)
        label.text = loggedInUser.name
        self.view.addSubview(label)
        let imageView = UIImageView(image: loggedInUser.photo)
        imageView.frame = CGRect(x: 5, y: 100, width: self.view.frame.width - 10, height: self.view.frame.width - 10)
        self.view.addSubview(imageView)
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
