import UIKit
import ParseUI

class TeamsViewController: PFQueryTableViewController {
    
    var deleteIndexPath: NSIndexPath? = nil
    var teams = [Int:PFObject]();
    
    convenience init() {
        let className = "Teams"
        self.init(style: .Plain, className: className)
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        self.parseClassName = className
    }
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        if let o = object {
            let teamName = o.valueForKey("teamName")!
            cell?.textLabel?.text = "\(indexPath.row): name: \(teamName)"
            self.teams[indexPath.row] = o
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
        let alert = UIAlertController(title: "Delete team", message: "Are you sure you want to permanently delete it?", preferredStyle: .ActionSheet)
        
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
                do {
                    try self.teams[indexPath.row]!.delete()
                } catch {}
                dispatch_async(dispatch_get_main_queue()) {
                    self.teams.removeValueForKey(indexPath.row)
                    self.loadObjects()
                }
            }
        }
        deleteIndexPath = nil
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }
    
    func addTeamsButtonPressed(sender: UIButton) {
        let navigationController  = self.parentViewController as! UINavigationController
        let vc = GradingViewController(playerName: loggedInUser.name!)
        navigationController.pushViewController(vc, animated: true)
    }
}
