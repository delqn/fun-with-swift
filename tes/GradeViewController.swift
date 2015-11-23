import Foundation
import UIKit

class GradeViewController: UIViewController, UINavigationBarDelegate {

    var playerName: String = ""
    
    init(playerName: String) {
        super.init(nibName: nil, bundle: nil)
        self.playerName = playerName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func addGradeButtonPressed(sender: UIBarButtonItem) {
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
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        // todo - use self.view.frame.size.width?
        makeSlider("sliderValueDidChange:", y: 250)
        makeSlider("sliderValueDidChange:", y: 350)
        makeSlider("sliderValueDidChange:", y: 450)
        
        print("GradeViewController made an appearance")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addGradeButtonPressed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelButtonPressed:")
        self.navigationItem.title = "Add a grade"
    }
    
    func sliderValueDidChange(sender:UISlider!) {
        print("value: \(sender.value)")
    }
}