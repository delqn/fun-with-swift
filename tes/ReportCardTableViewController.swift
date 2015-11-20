//
//  ReportCardTableViewController.swift
//  tes
//
//  Created by de on 11/20/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit
import ParseUI

class ReportCardTableViewController: PFQueryTableViewController, UINavigationBarDelegate {

    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = className
    }
    
    required init(coder aDecoder:NSCoder) {
        fatalError("NSCoding not supported")  
    }
 
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className:self.parseClassName!)
        
        if(objects?.count == 0) {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        query.orderByAscending("name")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier:String = "Cell"
        
        var cell:PFTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        
        if(cell == nil) {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        if let pfObject = object {
            cell?.textLabel?.text = pfObject["name"] as? String
        }
        
        return cell;
    }
    
    override func viewDidAppear(animated: Bool) {
        makeNavbar() // this navigation bar is not good because it is pushed down when pull to refresh...
    }
    
    private func logoutButtonClicked () {
        NSLog("logoutButtonClicked")
    }
    
    func makeNavbar() {
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "nstahoesnuthasonteuh"
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = NavBarLeftButton.init(title: "blah", style: .Plain) //UIBarButtonItem(title: "Logout?", style: UIBarButtonItemStyle.Plain, target: self, action:"logoutButtonClicked")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
}
