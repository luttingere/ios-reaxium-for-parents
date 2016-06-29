//
//  LoginViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 1/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import MMDrawerController
import Alamofire
import KSToastView

class LoginViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var loadingView: UIView = UIView()
    var loginWebService = LoginWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = attributedStringForTextFieldPlaceholder("Username")
        passwordTextField.attributedPlaceholder = attributedStringForTextFieldPlaceholder("Password")
        // Do any additional setup after loading the view.
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        mainViewTapGesture.delegate = self
        self.view.addGestureRecognizer(mainViewTapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = ReaxiumHelper().loadLoggedUserWithKey("loggedUser"){
            GlobalVariable.loggedUser = user
            self.performSegueWithIdentifier("DRAWER_SEGUE", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attributedStringForTextFieldPlaceholder(text: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string:text,                                                               attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        return attributedString
    }
    
    func handleViewTap() -> Void {
        if usernameTextField.isFirstResponder(){
            usernameTextField.resignFirstResponder()
        }else if passwordTextField.isFirstResponder(){
            passwordTextField.resignFirstResponder()
        }
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {

        if ReaxiumHelper().isEmptyField(usernameTextField) {
            KSToastView.ks_showToast("The username field can't be empty", duration: 3.0)
        }else if ReaxiumHelper().isEmptyField(passwordTextField) {
            KSToastView.ks_showToast("The password field can't be empty", duration: 3.0)
        }else{
            logUserWithCredentials(usernameTextField.text!, password: passwordTextField.text!)
        }

    }
    
    func logUserWithCredentials(username: String, password: String)-> Void{
        
        showActivityIndicator()
        
        let parameters = ["ReaxiumParameters":
            ["UserAccessData":
                ["user_login_name":username,
                    "user_password":password,
                    "device_token":GlobalVariable.deviceToken,
                    "device_platform":GlobalConstants.devicePlatform]
            ]
        ]
        
        loginWebService.callServiceObject(parameters, withCompletionBlock: { (result, error) in
            self.hideActivityIndicator()
            if error == nil {
                if let user = result as? User{
                    GlobalVariable.loggedUser = user
                    ReaxiumHelper().saveLoggedUser(user, key: "loggedUser")
                    self.performSegueWithIdentifier("DRAWER_SEGUE", sender: self)
                }
            }else{
                KSToastView.ks_showToast(error?.localizedDescription, duration: 3.0)
            }
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DRAWER_SEGUE" {
            ReaxiumHelper().loadStudentsAccessNotificationsArray(GlobalVariable.loggedUser.children)
            
            if let destinationViewController = segue.destinationViewController as? MMDrawerController{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                // Instantitate and set the center view controller.
                let centerViewController:UIViewController = (mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController"))
                let centerNav = UINavigationController(rootViewController: centerViewController)
                destinationViewController.centerViewController = centerNav
                
                // Instantiate and set the right drawer controller.
                let rightViewController:UIViewController = (mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController"))
                let rightNav = UINavigationController(rootViewController: rightViewController)
                destinationViewController.rightDrawerViewController = rightNav
                
                destinationViewController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;
                destinationViewController.showsShadow = false
            }
        }
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
