import Foundation
import UIKit

class GradingViewController: UIViewController, UINavigationBarDelegate {

    var playerName: String = ""
    var PC: Int = 0;
    var TE: Int = 0;
    var TA: Int = 0;
    
    init(playerName: String) {
        super.init(nibName: nil, bundle: nil)
        self.playerName = playerName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeSlider(actionSelector: Selector, y: CGFloat, label lbl: String) {
        let padding: CGFloat = 5
        let label = UILabel(frame: CGRectMake(padding, y, self.view.frame.size.width - padding, 67))
        label.text = lbl
        self.view.addSubview(label)
        
        let slider = UISlider(frame:CGRectMake(padding, y + 12, self.view.frame.size.width - padding, 67))
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.continuous = false
        slider.tintColor = UIColor.redColor()
        slider.value = 5
        slider.addTarget(self, action: actionSelector, forControlEvents: .ValueChanged)
        self.view.addSubview(slider)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func addGradeButtonPressed(sender: UIBarButtonItem) {
        let gameScore = PFObject(className:"ReportCard")
        gameScore["PassCompletion"] = self.PC
        gameScore["Technical"] = self.TE
        gameScore["Tactical"] = self.TA
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
        makeSlider("sliderPCValueDidChange:", y: 250, label: "Passing Completion")
        makeSlider("sliderTEValueDidChange:", y: 350, label: "Technical")
        makeSlider("sliderTAValueDidChange:", y: 450, label: "Tactical")
        
        print("GradeViewController made an appearance")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addGradeButtonPressed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelButtonPressed:")
        self.navigationItem.title = "Add a grade"
    }
    
    func sliderPCValueDidChange(sender:UISlider!) {
        self.PC = Int(sender.value)
    }
    
    func sliderTEValueDidChange(sender:UISlider!) {
        self.TE = Int(sender.value)
    }
    
    func sliderTAValueDidChange(sender:UISlider!) {
        self.TA = Int(sender.value)
    }
}