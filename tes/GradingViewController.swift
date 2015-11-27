import Foundation
import UIKit

class GradingViewController: UIViewController, UINavigationBarDelegate {

    var playerName: String = ""
    var PC = UISlider()
    var TE = UISlider()
    var TA = UISlider()
    
    init(playerName: String) {
        super.init(nibName: nil, bundle: nil)
        self.playerName = playerName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeSlider(slider: UISlider, y: CGFloat, label lbl: String, tag: Int) {
        let padding: CGFloat = 5
        let label = UILabel(frame: CGRectMake(padding, y, self.view.frame.size.width - padding, 67))
        label.text = lbl
        label.tag = tag
        self.view.addSubview(label)
        
        slider.frame = CGRectMake(padding, y + 15, self.view.frame.size.width - padding, 67)
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.continuous = false
        slider.tintColor = UIColor.redColor()
        slider.value = 5
        slider.tag = tag
        slider.addTarget(self, action: "sliderChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(slider)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func addGradeButtonPressed(sender: UIBarButtonItem) {
        let gameScore = PFObject(className:"ReportCard")
        gameScore["PassCompletion"] = self.PC.value
        gameScore["Technical"] = self.TE.value
        gameScore["Tactical"] = self.TA.value
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
        makeSlider(self.PC, y: 250, label: "Passing Completion", tag: 1)
        makeSlider(self.TE, y: 350, label: "Technical", tag: 2)
        makeSlider(self.TA, y: 450, label: "Tactical", tag: 3)
        
        print("GradeViewController made an appearance")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addGradeButtonPressed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelButtonPressed:")
        self.navigationItem.title = "Add a grade"
    }
    
    func sliderChange(sender: UISlider!) {
        for view in self.view.subviews {
            if view is UILabel && view.tag == sender.tag {
                let v = view as! UILabel
                let txt = v.text!.characters.split { $0 == ":" }
                // you get it
            }
        }
    }
}