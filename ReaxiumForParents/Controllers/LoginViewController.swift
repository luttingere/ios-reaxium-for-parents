//
//  LoginViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 1/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import MMDrawerController

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = attributedStringForTextFieldPlaceholder("Username")
        passwordTextField.attributedPlaceholder = attributedStringForTextFieldPlaceholder("Password")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attributedStringForTextFieldPlaceholder(text: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string:text,                                                               attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        return attributedString
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DRAWER_SEGUE" {
            if let destinationViewController = segue.destinationViewController as? MMDrawerController{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                // Instantitate and set the center view controller.
                let centerViewController:UIViewController = (mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController"))
                destinationViewController.centerViewController = centerViewController
                
                // Instantiate and set the right drawer controller.
                let rightViewController:UIViewController = (mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController"))
                destinationViewController.rightDrawerViewController = rightViewController
                
                destinationViewController.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
                destinationViewController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;
                destinationViewController.showsShadow = false
            }
        }
    }

}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true;
    }
}
