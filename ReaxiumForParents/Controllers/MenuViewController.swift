//
//  MenuViewController.swift
//  swiftHamburgerMenu
//
//  Created by Jorge Rodriguez on 23/5/16.
//  Copyright © 2016 Teravision Technologies. All rights reserved.
//

import UIKit
import MMDrawerController
import KSToastView

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet var parentNameLabel: UILabel!
    var homeOption: [String: String] = ["option": "HOME", "image": "home_icon"]
    var logoutOption: [String: String] = ["option": "LOG OUT", "image": "logout_icon"]
    var menuOptions = [Dictionary<String, String>]()
    var screenTitle:String!
    var logoutWebService = LogoutWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.statusBarStyle = .lightContent
        screenTitle = "\(GlobalVariable.loggedUser.name!) \(GlobalVariable.loggedUser.lastname!)"
        parentNameLabel.text = screenTitle.uppercased()
        menuOptions.append(homeOption)
        menuOptions.append(logoutOption)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.layoutSubviews()
        let indexPath = IndexPath(row: 0, section: 0)
        menuTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    func logoutUser()-> Void{
        
        let parameters = ["ReaxiumParameters":
            ["LogOut":
                ["user_id":GlobalVariable.loggedUser.ID,
                 "device_platform":GlobalConstants.devicePlatform]
            ]
        ]
        
        logoutWebService.callServiceObject(parameters as [String : AnyObject], withCompletionBlock: { (result, error) in
            if error == nil {
                ReaxiumHelper().removeSavedUserWithKey("loggedUser")
                for oneEvent in UIApplication.shared.scheduledLocalNotifications! {
                    let notification = oneEvent as UILocalNotification
                    UIApplication.shared.cancelLocalNotification(notification)
                }
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
                let centerNav = UINavigationController(rootViewController: centerViewController)
                self.mm_drawerController.setCenterView(centerNav, withCloseAnimation: true, completion: nil)
            }else{
                KSToastView.ks_showToast(error?.localizedDescription, duration: 3.0)
            }
        })
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

extension MenuViewController:UITableViewDelegate, UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        cell.setMenuCellContentWithData(menuOptions[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"){
                let centerNav = UINavigationController(rootViewController: centerViewController)
                self.mm_drawerController.setCenterView(centerNav, withCloseAnimation: true, completion: nil)
            }
        }else{
            logoutUser()
        }
    }

}
