//
//  SlidersViewController.swift
//  tes
//
//  Created by de on 11/15/15.
//  Copyright © 2015 misli. All rights reserved.
//

import Foundation
import UIKit

class SlidersViewController: UIViewController, UINavigationBarDelegate {

    func makeSlider(actionSelector: Selector, y: CGFloat) {
        let slider = UISlider(frame:CGRectMake(0, y, self.view.frame.size.width, 67))
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.continuous = true
        slider.tintColor = UIColor.redColor()
        slider.value = 50
        slider.addTarget(self, action: actionSelector, forControlEvents: .ValueChanged)
        self.view.addSubview(slider)
        
    }
    
    func makeNavbar() {
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "TES"
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(title: "Logout?", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    override func viewDidAppear(animated: Bool) {
        makeNavbar()
    }
    override func viewDidLoad() {
        print("already the new view just loaded")
        self.view.backgroundColor = UIColor.whiteColor()
        
        // todo - use self.view.frame.size.width?
        makeSlider("sliderValueDidChange:", y: 250)
        makeSlider("sliderValueDidChange:", y: 350)
        makeSlider("sliderValueDidChange:", y: 450)
        
        
    }
    
    func sliderValueDidChange(sender:UISlider!)
    {
        print("value--\(sender.value)")
    }
}