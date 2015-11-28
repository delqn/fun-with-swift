import Foundation
import UIKit

class GradingViewController: UIViewController, UINavigationBarDelegate {

    var playerName: String = ""
    var PC = UISlider()
    var TE = UISlider()
    var TA = UISlider()
    var tagToLabel = [Int:UILabel]()
    
    init(playerName: String) {
        super.init(nibName: nil, bundle: nil)
        self.playerName = playerName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeSlider(slider: UISlider, y: CGFloat, label lbl: String, tag: Int, startValue: Int, color: UIColor) {
        let padding: CGFloat = 5
        let frameBWidth: CGFloat = 50
        
        let labelA = UILabel(frame: CGRectMake(padding, y, self.view.frame.size.width - padding - frameBWidth, 67))
        labelA.text = lbl
        self.view.addSubview(labelA)

        let labelB = UILabel(frame: CGRectMake(self.view.frame.size.width - frameBWidth - padding, y, self.view.frame.size.width - padding, 67))
        labelB.text = String(startValue)
        self.tagToLabel[tag] = labelB
        self.view.addSubview(labelB)
        
        slider.frame = CGRectMake(padding*2, y + 15, self.view.frame.size.width - padding*2, 67)
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.continuous = true
        slider.tintColor = color
        slider.value = Float(startValue)
        slider.tag = tag
        slider.addTarget(self, action: "sliderChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(slider)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func addGradeButtonPressed(sender: UIBarButtonItem) {
        let gameScore = PFObject(className:"ReportCard")
        gameScore["PassCompletion"] = round(self.PC.value)
        gameScore["Technical"] = round(self.TE.value)
        gameScore["Tactical"] = round(self.TA.value)
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
        makeSlider(self.PC, y: 250, label: "Passing Completion", tag: 1, startValue: 5, color: UIColor.redColor())
        makeSlider(self.TE, y: 350, label: "Technical", tag: 2, startValue: 5, color: UIColor.greenColor())
        makeSlider(self.TA, y: 450, label: "Tactical", tag: 3, startValue: 5, color: UIColor.yellowColor())
        
        print("GradeViewController made an appearance")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addGradeButtonPressed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelButtonPressed:")
        self.navigationItem.title = "Add a grade"
    }
    
    func sliderChange(sender: UISlider!) {
        let newValue = Int(sender.value)
        if let label = self.tagToLabel[sender.tag] {
            label.text = "\(newValue)"
        }
    }
}