import UIKit
import ParseUI
//import PromiseKit

class ReportCardViewController: PFQueryTableViewController, UINavigationBarDelegate {

    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = className
    }
    
    required init(coder aDecoder:NSCoder) {
        fatalError("NSCoding not supported")  
    }
 
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className:self.parseClassName!)
        
        if(objects?.count == 0) {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        query.orderByAscending("name")
        return query
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        
        if(cell == nil) {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            let button = UIButton(type: .ContactAdd)
            button.frame = CGRectMake(cell!.frame.width - 30, cell!.frame.origin.y + 5, 100, 30)
            button.addTarget(self, action: "addGradeButtonPressed:", forControlEvents: .TouchUpInside)
            button.tag = indexPath.row
            cell!.addSubview(button)
        }

        if let o = object {
            let pc = o.valueForKey("PassCompletion")!
            let te = o.valueForKey("Technical")!
            let ta = o.valueForKey("Tactical")!
            cell?.textLabel?.text = "\(indexPath.row): pass: \(pc), tech: \(te), tact: \(ta)"
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let pfObject = self.objects?[indexPath.row] as! PFObject
            let backgroundDelete: PFBooleanResultBlock = { (success, error) in
                self.loadObjects()
            }
            pfObject.deleteInBackgroundWithBlock(backgroundDelete)
        }
    }
    
    func addGradeButtonPressed(sender: UIButton) {
        let navigationController  = self.parentViewController as! UINavigationController
        let vc = GradingViewController(playerName: loggedInUser.name!)
        navigationController.pushViewController(vc, animated: true)
    }
}
