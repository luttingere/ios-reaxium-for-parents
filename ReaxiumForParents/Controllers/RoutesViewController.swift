//
//  RoutesViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 7/3/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import KSToastView
import ObjectMapper
import MMDrawerController

class RoutesViewController: UIViewController {

    @IBOutlet weak var routesTableView: UITableView!
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    var routesWebService = RoutesWebService()
    var routesArray = [Routes]()
    var targetStudentID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        personalizeNavigationBar("USER INFORMATION")
        
        showActivityIndicator()
        let parameters = ["ReaxiumParameters":
            ["UserBusinessInfo":
                ["user_id":targetStudentID,]
            ]
        ]
        
        routesWebService.callServiceObject(parameters as [String : AnyObject], withCompletionBlock: { (result, error) in
            self.hideActivityIndicator()
            if error == nil {
                
                if let objects = result?.object as? NSArray{
//                    print("object \(object)")
                    for object in objects {
                        let route:Routes = Routes(JSON: object as! [String : Any])!;
                        self.routesArray.append(route)
                    }
                    self.routesTableView.reloadData()
                }
                
                print("route \(self.routesArray)")
                /*if let route = result as? Routes{
                    self.routesArray.append(route)
                    self.routesTableView.reloadData()
                }*/
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RouteTableViewCell{
            cell.loadCellWithRouteInformation(routesArray[indexPath.row])
            return cell
        }
        
        return RouteTableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
