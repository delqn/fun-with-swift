import UIKit
import ParseUI


class CoachesViewController: PFQueryTableViewController {

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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if let o = object {
            let name = o.valueForKey("name")!
            cell?.textLabel?.text = "coach: \(name)"
        }
        return cell;
    }
    /*
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("didDeselectRowAtIndexPath")
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("accessoryButtonTappedForRowWithIndexPath")
    }
    */
}
