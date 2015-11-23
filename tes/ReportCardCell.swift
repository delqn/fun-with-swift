import UIKit
import ParseUI

class ReportCardCell: PFTableViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let button = UIButton(type: .Custom)
        button.setTitle("rate", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRectMake(self.frame.width - 30, self.frame.origin.y + 5, 100, 30)
        button.addTarget(self, action: "buttonPressed", forControlEvents: .TouchUpInside)
        self.addSubview(button)
    }
    
    
    func buttonPressed() {
        print("button pressed", self.tag)
        let navigationController  = self.window!.rootViewController as! UINavigationController
        let vc = RatingViewController(playerName: "Diego")
        navigationController.pushViewController(vc, animated: true)

    }
    
}
