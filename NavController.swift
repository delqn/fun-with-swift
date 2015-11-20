//
//  NavController.swift
//  tes
//
//  Created by de on 11/20/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit

class NavController: UINavigationController, UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create the navigation bar
        let nb = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        //nb.tintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0)
        //nb.barTintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0)
        //nb.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        //nb.backgroundColor = UIColor.whiteColor()
        nb.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Recent Report Cards"
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = NavBarLeftButton.init(title: "blah", style: .Plain) //UIBarButtonItem(title: "Logout?", style: UIBarButtonItemStyle.Plain, target: self, action:"logoutButtonClicked")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        // Assign the navigation item to the navigation bar
        nb.items = [navigationItem]
        
        self.view.addSubview(nb)
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
