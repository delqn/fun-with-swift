//
//  NavBarLeftButton.swift
//  tes
//
//  Created by de on 11/20/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit

class NavBarLeftButton: UIBarButtonItem {
    
    convenience init(title: String?, style: UIBarButtonItemStyle) {
        self.init(title: "bbblah", style: style, target: nil, action: nil)
        self.title = "blah"
        self.target = self
        self.action = "barButtonItemPressed:"
    }
    
    func barButtonItemPressed(sender: UIBarButtonItem) {
        let gameScore = PFObject(className:"ReportCard")
        gameScore["PassCompletion"] = 5
        gameScore["Technical"] = 6
        gameScore["Tactical"] = 7
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                NSLog("Sucessfully logged data into Parse cloud.")
            } else {
                // There was a problem, check error.description
                NSLog("There was an error: @%", error!.description)
            }
        }

    }
}
