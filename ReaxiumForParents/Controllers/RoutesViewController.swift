//
//  RoutesViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 7/3/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import KSToastView

class RoutesViewController: UIViewController {

    @IBOutlet weak var routesTableView: UITableView!
    var routesWebService = RoutesWebService()
    var routesArray = [Routes]()
    var targetStudentID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        let parameters = ["ReaxiumParameters":
            ["UserBusinessInfo":
                ["user_id":targetStudentID,]
            ]
        ]
        
        routesWebService.callServiceObject(parameters, withCompletionBlock: { (result, error) in
            if error == nil {
                if let route = result as? Routes{
                    self.routesArray.append(route)
                    self.routesTableView.reloadData()
                }
            }else{
                KSToastView.ks_showToast(error?.localizedDescription, duration: 3.0)
            }
        })
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

}

extension RoutesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? RouteTableViewCell{
            cell.loadCellWithRouteInformation(routesArray[indexPath.row])
            return cell
        }
        
        return RouteTableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
