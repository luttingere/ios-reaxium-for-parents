//
//  HomeViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 1/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import MMDrawerController
import KSToastView

class HomeViewController: UIViewController {

    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var loadingView: UIView = UIView()
    var locationUpdate = LocationUpdateWebService()
    var targetStudentID:NSNumber!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenuAction(sender: AnyObject) {
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    func showActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor.blackColor()
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ACCESS_INFORMATION" {
            if let destinationViewController = segue.destinationViewController as? AccessInformationViewController{
                destinationViewController.targetStudentID = targetStudentID.stringValue
            }
        } else if segue.identifier == "TRACK_STUDENT" {
            if let destinationViewController = segue.destinationViewController as? TrackStudentViewController{
                destinationViewController.targetStudentID = targetStudentID.stringValue
            }
        } else if segue.identifier == "ROUTES_INFORMATION" {
            if let destinationViewController = segue.destinationViewController as? RoutesViewController{
                destinationViewController.targetStudentID = targetStudentID.stringValue
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StudentTableViewCell
        cell.delegate = self
        cell.setStudentDataFromObject(GlobalVariable.loggedUser.children[indexPath.section])
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clearColor()
        return header
    }
    
}

extension HomeViewController: StudentTableViewCellDelegate{
    
    func accessInfoPressed(studentID: NSNumber) {
        print("accessInfoPressed")
        targetStudentID = studentID
        self.performSegueWithIdentifier("ACCESS_INFORMATION", sender: self)
    }
    
    func trackStudentPressed(studentID: NSNumber) {
        print("trackStudentPressed")
        targetStudentID = studentID
        showActivityIndicator()
        let parameters = ["ReaxiumParameters":
            ["DeviceUpdateLocation":
                ["user_in_track_id":studentID,
                    "user_stakeholder_id":GlobalVariable.loggedUser.ID,
                    "device_token":GlobalVariable.deviceToken,
                    "device_platform":GlobalConstants.devicePlatform]
            ]
        ]
        
        locationUpdate.callServiceObject(parameters) { (result, error) in
            self.hideActivityIndicator()
            if error == nil{
                if (result as? LocationNotification) != nil{
                    self.performSegueWithIdentifier("TRACK_STUDENT", sender: self)
                }
            }
            else{
                KSToastView.ks_showToast(error?.localizedDescription, duration: 3.0)
            }
        }
    }
    
    func routesInfoPressed(studentID: NSNumber) {
        print("routesInfoPressed")
        targetStudentID = studentID
        self.performSegueWithIdentifier("ROUTES_INFORMATION", sender: self)
    }
}