//
//  ReportCardTableViewController.swift
//  tes
//
//  Created by de on 11/20/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit

class ReportCardTableViewController: PFQueryTableViewController {

    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = className
    }
    
    required init(coder aDecoder:NSCoder)
    {
        fatalError("NSCoding not supported")  
    }
    
}
