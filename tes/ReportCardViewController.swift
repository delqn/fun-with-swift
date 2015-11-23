import UIKit
import ParseUI

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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        
        if(cell == nil) {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            let button = UIButton(type: .ContactAdd)
            button.frame = CGRectMake(cell!.frame.width - 30, cell!.frame.origin.y + 5, 100, 30)
            button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            button.tag = indexPath.row
            cell!.addSubview(button)
        }
        
        if let o = object {
            let pc = o.valueForKey("PassCompletion")!
            let te = o.valueForKey("Technical")!
            let ta = o.valueForKey("Tactical")!
            cell?.textLabel?.text = "\(indexPath.row): passCompletion: \(pc), tech: \(te), tact: \(ta)"
        }
        return cell;
    }
    
    func buttonPressed(sender: UIButton) {
        print("button pressed", sender.tag)
        let navigationController  = self.parentViewController as! UINavigationController
        let vc = GradeViewController(playerName: "Diego")
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func logoutButtonClicked () {
        NSLog("logoutButtonClicked")
    }
}
