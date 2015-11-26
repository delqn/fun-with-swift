import UIKit

import Parse
import FBSDKLoginKit
import FBSDKCoreKit
import ParseFacebookUtilsV4

struct User {
    var pfUser: PFUser? = nil
    var name: String? = nil
    var email: String? = nil
    var photoURL: String? = nil
}

var loggedInUser = User()

class ViewController: UIViewController, UINavigationBarDelegate {
    
    let loginButton = UIButton(type: .System)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 300, 150, 50)
        self.loginButton.setTitle("Login with facebook", forState: .Normal)
        self.loginButton.addTarget(self, action: "fbLogin:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.loginButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getFacebookProfile() {
        // TODO(delyan): graphPath needs to change
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                print("fetched user: \(result)")
                if let userName: NSString = result.valueForKey("name") as? NSString {
                    print("User Name is: \(userName)")
                    loggedInUser.name = userName as String
                }
                if let userEmail: NSString = result.valueForKey("email") as? NSString {
                    print("User Email is: \(userEmail)")
                    loggedInUser.email = userEmail as String
                }
                if let userID: NSString = result.valueForKey("id") as? NSString {
                    loggedInUser.photoURL = "https://graph.facebook.com/\(userID)/picture?type=large"
                }
            }
        })
    }
    
    func fbLogin(sender: UIButton) {
        self.loginButton.hidden = true
        // TODO(delyan): this should be trigered with a BUTTON - not automatically
        // See if you can reuse the button from FBSDKLoginKit
        let permissions = ["public_profile", "email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                    loggedInUser.pfUser = user
                    self.getFacebookProfile() // sideefects
                }
                self.userLoggedInSucessfully(user)
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
                self.loginButton.hidden = false
            }
        }
    }

    private func userLoggedInSucessfully(user: PFUser) {
        let tabBarController = UITabBarController()
        
        let vc = ReportCardViewController(className: "ReportCard")
        vc.title = "Games"
        let gamesNavController = UINavigationController(rootViewController: vc)
        
        let profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        
        let coachViewController = CoachViewController()
        coachViewController.title = "Coach"
        
        tabBarController.viewControllers = [gamesNavController, coachViewController, profileViewController]
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
}

