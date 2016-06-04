//
//  MenuViewController.swift
//  swiftHamburgerMenu
//
//  Created by Jorge Rodriguez on 23/5/16.
//  Copyright © 2016 Teravision Technologies. All rights reserved.
//

import UIKit
import MMDrawerController

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    var homeOption: [String: String] = ["option": "HOME", "image": "home_icon"]
    var logoutOption: [String: String] = ["option": "LOG OUT", "image": "logout_icon"]
    var menuOptions = [Dictionary<String, String>]()
    var navItemTitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItemTitle = "\(GlobalVariable.loggedUser.name) \(GlobalVariable.loggedUser.lastname)"
        self.title = navItemTitle.uppercaseString
        menuOptions.append(homeOption)
        menuOptions.append(logoutOption)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.layoutSubviews()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        menuTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
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
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MenuTableViewCell
        cell.setMenuCellContentWithData(menuOptions[indexPath.row])
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            if let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController"){
                let centerNav = UINavigationController(rootViewController: centerViewController)
                self.mm_drawerController.setCenterViewController(centerNav, withCloseAnimation: true, completion: nil)
            }
        }else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
                let centerNav = UINavigationController(rootViewController: centerViewController)
                self.mm_drawerController.setCenterViewController(centerNav, withCloseAnimation: true, completion: nil)
        }
    }

}
