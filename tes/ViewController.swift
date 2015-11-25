import UIKit

import Parse
import FBSDKLoginKit
import FBSDKCoreKit
import ParseFacebookUtilsV4

var loggedInUser: PFUser?

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .System)
        button.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 300, 150, 50)
        button.setTitle("Login with facebook", forState: .Normal)
        button.addTarget(self, action: "fbLogin:", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fbLogin(sender: UIButton) {
        // TODO(delyan): this should be trigered with a BUTTON - not automatically
        // See if you can reuse the button from FBSDKLoginKit
        let permissions = ["public_profile", "email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                print (user)
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                    loggedInUser = user
                }
                self.userLoggedInSucessfully(user)
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
        } else {
            let loginView = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if (error != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("name") {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    private func userLoggedInSucessfully(user: PFUser) {
        let tabBarController = UITabBarController()
        
        let vc = ReportCardViewController(className: "ReportCard")        
        let gamesNavController = UINavigationController(rootViewController: vc)
        gamesNavController.title = "Games"
        
        let profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        
        let coachViewController = CoachViewController()
        coachViewController.title = "Coach"
        
        tabBarController.viewControllers = [gamesNavController, coachViewController, profileViewController]
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
}

