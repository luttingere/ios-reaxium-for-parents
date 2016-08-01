//
//  AccessInformationViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 2/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import MMDrawerController

class AccessInformationViewController: UIViewController {

    @IBOutlet weak var notificationsTableView: UITableView!
    
    var notificationsArray = [AccessNotification]()
    var targetStudentID = ""
    var showBackButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if GlobalVariable.accessNotifications[targetStudentID] != nil {
            notificationsArray = GlobalVariable.accessNotifications[targetStudentID]!
            
            if notificationsArray.count > 0 {
                updateTableContentInset()
                refreshAccessNotificationTable()
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AccessInformationViewController.refreshAccessNotificationTable), name: GlobalConstants.accessNotificationKey, object: nil)
        
        if !showBackButton {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fill the cells starting from the bottom
    func updateTableContentInset() -> Void{
        let numRows = self.tableView(notificationsTableView, numberOfRowsInSection: 0)
        notificationsTableView.numberOfRowsInSection(0)
        var contentInsetTop = notificationsTableView.bounds.size.height
        
        for _ in 1 ..< numRows {
            contentInsetTop -= 90
            if (contentInsetTop <= 0) {
                contentInsetTop = 0
                break
            }
        }
        notificationsTableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
    }
    
    func refreshAccessNotificationTable(){
        notificationsArray = GlobalVariable.accessNotifications[targetStudentID]!
        notificationsTableView.reloadData()
        notificationsTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: notificationsArray.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        
    }

    @IBAction func showMenuAction(sender: AnyObject) {
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }

}

extension AccessInformationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NotificationTableViewCell
        cell.showMessageViewForNotification(notificationsArray[indexPath.row])
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func back(sender: AnyObject) {
        if let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController"){
            let centerNav = UINavigationController(rootViewController: centerViewController)
            self.mm_drawerController.setCenterViewController(centerNav, withCloseAnimation: true, completion: nil)
        }
    }
}

