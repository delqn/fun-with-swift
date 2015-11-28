import UIKit
import ParseUI


class CoachesViewController: PFQueryTableViewController {
    
    let coachViewController = CoachViewController()
    var rowNumToObject = [Int:PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
        tableView.reloadData()
    }
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = className
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        cell?.accessoryType = .DetailDisclosureButton
        if let o = object {
            let name = o.valueForKey("name")!
            cell?.textLabel?.text = "coach: \(name)"
            rowNumToObject[indexPath.row] = o
        }
        return cell;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath")
        self.coachViewController.setCoach(self.rowNumToObject[indexPath.row]!)
        self.navigationController?.pushViewController(coachViewController, animated: true)
    }
 
    /*
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("accessoryButtonTappedForRowWithIndexPath")
        let coachViewController = CoachViewController()
        self.navigationController?.pushViewController(coachViewController, animated: true)
    }
    */
}
