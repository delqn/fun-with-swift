//
//  ProfileViewController.swift
//  tes
//
//  Created by de on 11/25/15.
//  Copyright © 2015 misli. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.greenColor()
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 300, 150, 50)
        button.setTitle("blah", forState: .Normal)
        self.view.addSubview(button)
        
        let label = UILabel()
        label.frame = CGRectMake(self.view.frame.width / 2 - 75, self.view.frame.height - 100, 150, 50)
        label.text = loggedInUser.name
        self.view.addSubview(label)
        
        if let url = loggedInUser.photoURL, imgUrl = NSURL(string: url) {
            NSURLSession.sharedSession().dataTaskWithURL(imgUrl) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    print("Finished downloading \"\(imgUrl.URLByDeletingPathExtension!.lastPathComponent!)\".")
                    let image = UIImage(data: data)
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
                    self.view.addSubview(imageView)
                }
            }.resume()
        }
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

}
