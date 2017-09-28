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
        self.performSegue(withIdentifier: "DRAWER_SEGUE", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "DRAWER_SEGUE" {
            if let destinationViewController = segue.destination as? MMDrawerController{
                
                // Instantitate and set the center view controller.
                let centerViewController:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
                
                destinationViewController.centerViewController = centerViewController
                
                // Instantiate and set the right drawer controller.
                let rightViewController:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController"))!
                
                destinationViewController.rightDrawerViewController = rightViewController
            
            }
        }
    }
    

}

