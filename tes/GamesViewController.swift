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

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        
        if(cell == nil) {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            let button = UIButton(type: .ContactAdd)
            button.frame = CGRectMake(cell!.frame.width - 30, cell!.frame.origin.y + 45, 100, 30)
            button.addTarget(self, action: "addGradeButtonPressed:", forControlEvents: .TouchUpInside)
            button.tag = indexPath.row
            cell!.addSubview(button)
        }

        let ybuffer: CGFloat = 10;
        if let o = object {
            let pc = o.valueForKey("PassCompletion")!
            let te = o.valueForKey("Technical")!
            let ta = o.valueForKey("Tactical")!
            //cell?.textLabel?.text = "\(indexPath.row): pass: \(pc), tech: \(te), tact: \(ta)"
            //self.grades[indexPath.row] = o

            let label = UILabel()
            label.frame = CGRectMake(15, -10 + ybuffer, 100, 50)
            label.textAlignment = .Center
            label.text = "Game \(indexPath.row + 1)"
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
            label.textColor = UIColor.blackColor()
            label.textAlignment = .Left
            cell?.contentView.addSubview(label)

            let labelC = UILabel()
            labelC.frame = CGRectMake(275, -10 + ybuffer, 100, 50)
            labelC.textAlignment = .Center
            labelC.text = "View details"
            labelC.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
            labelC.textColor = UIColor.lightGrayColor()
            labelC.textAlignment = .Left
            cell?.contentView.addSubview(labelC)

            if let myScore: Float = ta as! Float, let coachScore: Float = te as!Float {
                let progress = UIProgressView()
                progress.frame = CGRectMake(120, 40 + ybuffer, cell!.frame.width-180, 30)
                progress.progress = myScore / 10
                // progress.center = CGPointMake(cell!.frame.width / 2, 21)
                progress.transform = CGAffineTransformMakeScale(1.0, 5.0)
                progress.layer.cornerRadius = 10
                progress.layer.masksToBounds = true
                progress.clipsToBounds = true
                cell?.contentView.addSubview(progress)

                let labelA = UILabel()
                labelA.frame = CGRectMake(15, 15 + ybuffer, 100, 50)
                labelA.textAlignment = .Center
                labelA.text = "My rating"
                labelA.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
                labelA.textColor = UIColor.grayColor()
                labelA.textAlignment = .Left
                cell?.contentView.addSubview(labelA)

                let progressB = UIProgressView()
                progressB.frame = CGRectMake(120, 65 + ybuffer, cell!.frame.width-180, 30)
                progressB.progress = coachScore / 10
                // progress.center = CGPointMake(cell!.frame.width / 2, 21)
                progressB.transform = CGAffineTransformMakeScale(1.0, 5.0)
                progressB.layer.cornerRadius = 10
                progressB.layer.masksToBounds = true
                progressB.clipsToBounds = true
                cell?.contentView.addSubview(progressB)

                let labelB = UILabel()
                labelB.frame = CGRectMake(15, 40 + ybuffer, 100, 50)
                labelB.textAlignment = .Center
                labelB.text = "Coach rating"
                labelB.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
                labelB.textColor = UIColor.grayColor()
                labelB.textAlignment = .Left
                cell?.contentView.addSubview(labelB)
            }
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
                do {
                    try self.grades[indexPath.row]!.delete()
                } catch {}
                dispatch_async(dispatch_get_main_queue()) {
                    self.grades.removeValueForKey(indexPath.row)
                    self.loadObjects()
                }
                
            }
        }
        deleteIndexPath = nil
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }
    
    func addGradeButtonPressed(sender: UIButton) {
        let navigationController  = self.parentViewController as! UINavigationController
        let name = loggedInUser.name ?? "Player"
        let vc = GradingViewController(playerName: name)
        navigationController.pushViewController(vc, animated: true)
    }
}
