//
//  ProfileViewController.swift
//  tes
//
//  Created by de on 11/25/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.greenColor()
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 300, 150, 50)
        button.setTitle("blah", forState: .Normal)
        self.view.addSubview(button)
        
        let label = UILabel()
        label.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 100, 150, 50)

        // TODO(delyan): graphPath needs to change
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                print("fetched user: \(result)")
                if let userName : NSString = result.valueForKey("name") as? NSString {
                    print("User Name is: \(userName)")
                    label.text = userName as String
                }
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    print("User Email is: \(userEmail)")
                }
            }
        })
        self.view.addSubview(label)
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
