import CloudKit
import LocalAuthentication
import Security
import UIKit

import FBSDKLoginKit
import FBSDKCoreKit
import Locksmith
import Parse
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

        UIApplication.sharedApplication().statusBarHidden = true
        self.navigationController?.navigationBarHidden = true
        /*
        let randNum = Int(arc4random_uniform(2)+1)
        switch randNum {
        case 1:
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tes1.png")!)
        case 2:
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tes2.png")!)
        default:
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tes0.png")!)

        }
        */
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tes0.png")!)

        let label = UILabel()
        label.frame = CGRectMake(
            0, 150,
            self.view.frame.width, 50)
        label.textAlignment = .Center
        label.text = "TES COACHING"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)

        let labelA = UILabel()
        labelA.frame = CGRectMake(
            0, 200,
            self.view.frame.width, 50)
        labelA.textAlignment = .Center
        labelA.text = "The power of information"
        labelA.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        labelA.textColor = UIColor.whiteColor()
        self.view.addSubview(labelA)


        //let dictionary = Locksmith.loadDataForUserAccount("myUserAccount")
        //let dictionary = Locksmith.loadDataForUserAccount("tes")

        /*
        if let iCloudID = dictionary?["iCloudID"] as? String {
            self.userLoggedInSucessfully(nil, iCloudUserID: iCloudID)
        } else if authenticateWithTouchID() {
            print("performing touchID login")
        } else {
        */


        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }

        if true {
            self.loginButtonFB.frame = CGRectMake(
                75, self.view.frame.height - 200,
                self.view.frame.width - 150, 50)
            self.loginButtonFB.layer.cornerRadius = 5
            self.loginButtonFB.clipsToBounds = true
            self.loginButtonFB.backgroundColor = UIColorFromRGB(0x2CCCE4)
            self.loginButtonFB.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.loginButtonFB.setTitle("Login with facebook", forState: .Normal)
            self.loginButtonFB.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            self.loginButtonFB.addTarget(self, action: "fbLogin:", forControlEvents: .TouchUpInside)

            self.view.addSubview(self.loginButtonFB)

            self.loginButtonIC.frame = CGRectMake(
                75, self.view.frame.height - 100,
                self.view.frame.width - 150, 50)
            self.loginButtonIC.layer.cornerRadius = 5
            self.loginButtonIC.clipsToBounds = true
            self.loginButtonIC.backgroundColor = UIColorFromRGB(0x2CCCE4)
            self.loginButtonIC.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.loginButtonIC.setTitle("Login with iCloud", forState: .Normal)
            self.loginButtonIC.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            self.loginButtonIC.addTarget(self, action: "iCloudLogin", forControlEvents: .TouchUpInside)
        
            self.view.addSubview(self.loginButtonIC)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func authenticateWithTouchID() -> Bool {
        print("authenticateUser")
        let context : LAContext = LAContext()
        var error : NSError?
        let myLocalizedReasonString = "Authentication is required"
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("the device does support touchID")
        } else {
            var message = ""
            switch error!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                message = "TouchID not enrolled"
            case LAError.PasscodeNotSet.rawValue:
                message = "Passcode not set"
            default:
                message = "TouchID not available"
            }
            print(message)
            self.showAlert(message)
            return false
        }
        context.evaluatePolicy(
            LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            localizedReason: myLocalizedReasonString,
            reply: {(success : Bool, evaluationError : NSError?) -> Void in
                if success {
                    self.iCloudLogin()
                    /*
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        //self.userLoggedInSucessfully(nil, iCloudUserID: nil)
                        self.iCloudLogin()
                    })
                    */
                } else {
                    // Authentification failed
                    print(evaluationError?.localizedDescription)
                    var message = ""
                    switch evaluationError!.code {
                    case LAError.SystemCancel.rawValue:
                        message = "Authentication cancelled by the system"
                    case LAError.UserCancel.rawValue:
                        message = "Authentication cancelled by the user"
                    case LAError.UserFallback.rawValue:
                        message = "User wants to use a password"
                        // We show the alert view in the main thread (always update the UI in the main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showAlert(message)
                        })
                    default:
                        message = "Authentication failed"
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showAlert(message)
                        })
                    }
                    print(message)
                }
        })
        return true
    }
    
    func iCloudLogin() {
        self.loginButtonFB.hidden = true
        self.loginButtonIC.hidden = true
        iCloudUserIDAsync() {
            recordID, error in
            if let userID = recordID?.recordName {
                print("received iCloudID \(userID)")
                do {
                    try Locksmith.saveData(["iCloudID": userID], forUserAccount: "tes")
                } catch {}
                self.userLoggedInSucessfully(nil, iCloudUserID: userID)
            } else {
                print("Fetched iCloudID was nil")
                let alert = UIAlertController(title: "Alert", message: "Fetched iCloudID was nil", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
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
        self.loginButtonIC.hidden = true
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
                print("Uh oh. The user canceled the Facebook login.")
                print("Fetched iCloudID was nil")
                let alert = UIAlertController(title: "Alert", message: "Facebook login was canceled.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
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
    
    private func XXuserLoggedInSucessfully(pfUser: PFUser?, iCloudUserID: String?) {
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

    private func userLoggedInSucessfully(pfUser: PFUser?, iCloudUserID: String?) {
        let meViewController = GamesViewController.init()
        meViewController.title = "Me"
        let meNavController = UINavigationController(rootViewController: meViewController)

        let teamViewController = CoachesViewController(className: "Coaches")
        teamViewController.navigationController?.navigationBarHidden = false
        teamViewController.title = "Team"
        let temNavController = UINavigationController(rootViewController: teamViewController)

        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = UIColorFromRGB(0x2CCCE4)
        tabBarController.view.tintColor = UIColorFromRGB(0x2CCCE4)
        tabBarController.tabBar.tintColor = UIColorFromRGB(0x2CCCE4)
        tabBarController.viewControllers = [meNavController, temNavController]
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
}

