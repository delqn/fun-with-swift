//
//  ReportCardTableViewController.swift
//  tes
//
//  Created by de on 11/20/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit
import ParseUI

class ReportCardViewController: PFQueryTableViewController, UINavigationBarDelegate {

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
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        
        if(cell == nil) {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        if let passCompletion = object?.valueForKey("PassCompletion"){
            cell?.textLabel?.text = "\(indexPath.row): passCompletion: \(passCompletion)"
        }
        return cell;
    }
    
    private func logoutButtonClicked () {
        NSLog("logoutButtonClicked")
    }
}