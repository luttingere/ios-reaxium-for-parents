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

    @IBOutlet var studentTableView: UITableView!
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    var locationUpdate = LocationUpdateWebService()
    var targetStudentID:NSNumber!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadView), name: NSNotification.Name(rawValue: GlobalConstants.accessHomeNotificationKey), object: nil)
        personalizeNavigationBar("YOUR STUDENTS")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadView() {
        studentTableView.reloadData()
    }
    
    @IBAction func showMenuAction(_ sender: AnyObject) {
        self.mm_drawerController.toggle(MMDrawerSide.right, animated: true, completion: nil)
        
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor.black
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ACCESS_INFORMATION" {
            if let destinationViewController = segue.destination as? AccessInformationViewController{
                destinationViewController.targetStudentID = targetStudentID.stringValue
            }
        } else if segue.identifier == "TRACK_STUDENT" {
            if let destinationViewController = segue.destination as? TrackStudentViewController{
                destinationViewController.targetStudentID = targetStudentID.stringValue
            }
        } else if segue.identifier == "ROUTES_INFORMATION" {
            if let destinationViewController = segue.destination as? RoutesViewController{
                destinationViewController.targetStudentID = targetStudentID.stringValue
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? StudentTableViewCell{
            cell.delegate = self
            cell.setStudentDataFromObject(GlobalVariable.loggedUser.children[indexPath.section])
            return cell
        }
        
        return StudentTableViewCell()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalVariable.loggedUser.children.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
}

extension HomeViewController: StudentTableViewCellDelegate{
    
    func accessInfoPressed(_ studentID: NSNumber) {
        print("accessInfoPressed")
        targetStudentID = studentID
        self.performSegue(withIdentifier: "ACCESS_INFORMATION", sender: self)
    }
    
    func trackStudentPressed(_ studentID: NSNumber) {
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
        
        locationUpdate.callServiceObject(parameters as [String : AnyObject]) { (result, error) in
            self.hideActivityIndicator()
            if error == nil{
                if (result as? LocationNotification) != nil{
                    self.performSegue(withIdentifier: "TRACK_STUDENT", sender: self)
                }
            }
            else{
                KSToastView.ks_showToast(error?.localizedDescription, duration: 3.0)
            }
        }
    }
    
    func routesInfoPressed(_ studentID: NSNumber) {
        print("routesInfoPressed")
        targetStudentID = studentID
        self.performSegue(withIdentifier: "ROUTES_INFORMATION", sender: self)
    }
}
