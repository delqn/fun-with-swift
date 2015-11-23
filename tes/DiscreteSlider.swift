//
//  DiscreteSlider.swift
//  tes
//
//  Created by de on 11/23/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit

class DiscreteSlider: UISlider {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    init(frame: CGRect, actionTarget: AnyObject, actionSelector: Selector) {
        super.init(frame: frame)
        minimumValue = 0
        maximumValue = 10
        continuous = true
        tintColor = UIColor.redColor()
        value = 5
        addTarget(actionTarget, action: actionSelector, forControlEvents: .ValueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
