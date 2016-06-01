//
//  ViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 5/19/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import MMDrawerController
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.performSegueWithIdentifier("DRAWER_SEGUE", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "DRAWER_SEGUE" {
            if let destinationViewController = segue.destinationViewController as? MMDrawerController{
                
                // Instantitate and set the center view controller.
                let centerViewController:UIViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController"))!
                
                destinationViewController.centerViewController = centerViewController
                
                // Instantiate and set the right drawer controller.
                let rightViewController:UIViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController"))!
                
                destinationViewController.rightDrawerViewController = rightViewController
            
            }
        }
    }
    

}

