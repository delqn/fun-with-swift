import UIKit
import ParseUI
//import PromiseKit

class GamesViewController: PFQueryTableViewController, UINavigationBarDelegate {

    var deleteIndexPath: NSIndexPath? = nil
    var grades = [Int:PFObject]();
    
    convenience init() {
        let className = "ReportCard"
        self.init(className: className)
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        self.parseClassName = className
    }

    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
        
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
            self.grades[indexPath.row] = o
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteIndexPath = indexPath
            confirmDelete(indexPath.row)
        }
    }
    
    func confirmDelete(row: Int) {
        let alert = UIAlertController(title: "Delete rating", message: "Are you sure you want to permanently delete it?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDelete)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDelete(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteIndexPath {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
                self.tableView.beginUpdates()
                do {
                    try self.grades[indexPath.row]!.delete()
                } catch {}
                self.grades.removeValueForKey(indexPath.row)
                self.tableView.cellForRowAtIndexPath(indexPath)?.hidden = true
                self.loadObjects()
                // Note that indexPath is wrapped in an array:  [indexPath]
                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
            }
            deleteIndexPath = nil
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }
    
    func addGradeButtonPressed(sender: UIButton) {
        let navigationController  = self.parentViewController as! UINavigationController
        let vc = GradingViewController(playerName: loggedInUser.name!)
        navigationController.pushViewController(vc, animated: true)
    }
}
