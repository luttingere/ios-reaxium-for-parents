//
//  AppDelegate.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 5/19/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMaps
import MMDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        setupNavigationBarAppearance()
        
        //Initialize Fabric/Crashlytics
        Fabric.with([Crashlytics.self])
        
        GMSServices.provideAPIKey(GlobalConstants.googleMapsAPIKey)
        
//        loadFirstAccessNotifications() //TODO: Delete this
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        GlobalVariable.deviceToken = tokenString
        print("Device Token:", GlobalVariable.deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        /*let aps = userInfo["aps"]!["custom"] as! [String: AnyObject]
        print("remote notification payload: \(aps)")
        let info = AccessNotification(dictionary: aps)
        GlobalVariable.accessNotifications.append(info!)
        
        if UIApplication.sharedApplication().applicationState == .Active {
            if isAccessInfoViewControllerVisible() {
                NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.accessNotificationKey, object: self)
            }
        }else{
            
        }*/
        if let user = ReaxiumHelper().loadLoggedUserWithKey("loggedUser"){
            print("user: \(user)")
            let aps = userInfo["aps"]!["custom"] as! [String: AnyObject]
            print("local notification payload: \(aps)")
            
            let info = AccessNotification(dictionary: aps)
            GlobalVariable.accessNotifications.append(info!)
            
            if UIApplication.sharedApplication().applicationState == .Active {
                if isAccessInfoViewControllerVisible() {
                    NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.accessNotificationKey, object: self)
                }
            }else{
                if isAccessInfoViewControllerVisible() {
                    NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.accessNotificationKey, object: self)
                }else{
                    presentAccessInfoViewController()
                }
            }
            
        }

    }
    
    func setupNavigationBarAppearance() -> Void {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().barTintColor = UIColor(red: 221.0/255.0, green: 191.0/255.0, blue: 139.0/255.0, alpha: 1.0);
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // TODO: validar el tipo de notificacion
        if let user = ReaxiumHelper().loadLoggedUserWithKey("loggedUser"){
            print("user: \(user)")
            print("local notification: \(notification)")
            let aps = notification.userInfo as! [String: AnyObject]
            print("local notification payload: \(aps)")
            let info = AccessNotification(dictionary: aps)
            GlobalVariable.accessNotifications.append(info!)
            
            if UIApplication.sharedApplication().applicationState == .Active {
                if isAccessInfoViewControllerVisible() {
                    NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.accessNotificationKey, object: self)
                }
            }else{
                if isAccessInfoViewControllerVisible() {
                    NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.accessNotificationKey, object: self)
                }else{
                    presentAccessInfoViewController()
                }
            }

        }
    }
    
    func loadFirstAccessNotifications(){
        // TODO: remove this notifications
        let dict1 = ["traffic_id":1,
                     "traffic_type_id":1,
                     "traffic_info":"The student got on the bus at",
                     "access_id":141,
                     "datetime":NSDate()]
        
        let dict2 = ["traffic_id":2,
                     "traffic_type_id":2,
                     "traffic_info":"The student got off the bus at",
                     "access_id":141,
                     "datetime":NSDate()]
        
        let info1 = AccessNotification(dictionary: dict1)
        let info2 = AccessNotification(dictionary: dict2)
        
        GlobalVariable.accessNotifications.append(info1!)
        GlobalVariable.accessNotifications.append(info2!)
        
    }
    
    func isAccessInfoViewControllerVisible() -> Bool {
        
        if let topController = UIApplication.topViewController() {
            if let visibleController = topController as? MMDrawerController{
                if let navController = UIApplication.topViewController(visibleController.centerViewController){
                    debugPrint(navController)
                    return navController.isKindOfClass(AccessInformationViewController)
                }
            }
        }
        
        return false
    }
    
    func presentAccessInfoViewController()-> Void{
        if let topController = UIApplication.topViewController() {
            if let visibleController = topController as? MMDrawerController{
                if let centerViewController = visibleController.storyboard?.instantiateViewControllerWithIdentifier("AccessInformationViewController"){
                    let centerNav = UINavigationController(rootViewController: centerViewController)
                    visibleController.centerViewController = centerNav
                    
                    if let rightViewController = visibleController.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController"){
                        let rightNav = UINavigationController(rootViewController: rightViewController)
                        visibleController.rightDrawerViewController = rightNav
                    }
                    
                }
            }
        }
    }
    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

