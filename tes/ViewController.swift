import UIKit
import CloudKit

import Parse
import FBSDKLoginKit
import FBSDKCoreKit
import ParseFacebookUtilsV4

struct User {
    var pfUser: PFUser?
    var name: String?
    var email: String?
    var photoURL: String?
    var photo: UIImage?
}

var loggedInUser = User()

class ViewController: UIViewController, UINavigationBarDelegate {
    
    let loginButtonFB = UIButton(type: .System)
    let loginButtonIC = UIButton(type: .System)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButtonFB.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 300, 150, 50)
        self.loginButtonFB.setTitle("Login with facebook", forState: .Normal)
        self.loginButtonFB.addTarget(self, action: "fbLogin:", forControlEvents: .TouchUpInside)

        self.view.addSubview(self.loginButtonFB)
        
        self.loginButtonIC.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 200, 150, 50)
        self.loginButtonIC.setTitle("Login with iCloud", forState: .Normal)
        self.loginButtonIC.addTarget(self, action: "iCloudLogin:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.loginButtonIC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iCloudLogin(sender: UIButton) {
        self.loginButtonIC.hidden = true
        iCloudUserIDAsync() {
            recordID, error in
            if let userID = recordID?.recordName {
                print("received iCloudID \(userID)")
                self.userLoggedInSucessfully(nil, iCloudUserID: userID)
            } else {
                print("Fetched iCloudID was nil")
            }
        }
    }
    
    /// async gets iCloud record ID object of logged-in iCloud user
    func iCloudUserIDAsync(complete: (instance: CKRecordID?, error: NSError?) -> ()) {
        let container = CKContainer.defaultContainer()
        container.fetchUserRecordIDWithCompletionHandler() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(instance: nil, error: error)
            } else {
                print("fetched ID \(recordID?.recordName)")
                complete(instance: recordID, error: nil)
            }
        }
    }
    
    func fbLogin(sender: UIButton) {
        self.loginButtonFB.hidden = true
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
                self.userLoggedInSucessfully(user, iCloudUserID: nil)
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
                self.loginButtonFB.hidden = false
            }
        }
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
                    let imgUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=large")!
                    NSURLSession.sharedSession().dataTaskWithURL(imgUrl) { (data, response, error) in
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            guard let data = data where error == nil else { return }
                            print("Finished downloading \"\(imgUrl.URLByDeletingPathExtension!.lastPathComponent!)\".")
                            loggedInUser.photo = UIImage(data: data)
                        }
                        }.resume()
                }
            }
        })
    }
    
    private func userLoggedInSucessfully(pfUser: PFUser?, iCloudUserID: String?) {
        let tabBarController = UITabBarController()
        
        let reportCardViewController = GamesViewController.init()
        reportCardViewController.title = "Games"
        let gamesNavController = UINavigationController(rootViewController: reportCardViewController)
        
        let profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        
        let coachesViewController = CoachesViewController(className: "Coaches")
        coachesViewController.title = "Coaches"
        let coachesNavController = UINavigationController(rootViewController: coachesViewController)

        let teamsViewController = TeamsViewController.init(className: "Teams")
        teamsViewController.title = "Teams"
        let teamsNavController = UINavigationController(rootViewController: teamsViewController)
        teamsNavController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addTeamsButtonPressed:")

        tabBarController.viewControllers = [gamesNavController, coachesNavController, profileViewController, teamsNavController]
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
}

