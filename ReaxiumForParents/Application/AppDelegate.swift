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
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        setupNavigationBarAppearance()
        
        //Initialize Fabric/Crashlytics
        Fabric.with([Crashlytics.self])
        
        GMSServices.provideAPIKey(GlobalConstants.googleMapsAPIKey)
        
//        loadFirstAccessNotifications() //TODO: Delete this
//        application.listenForRemoteNotifications() // SimulatorRemoteNotifications Pod
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        GlobalVariable.deviceToken = tokenString
        print("Device Token:", GlobalVariable.deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        if let user = ReaxiumHelper().loadLoggedUserWithKey("loggedUser"){
            print("user: \(user)")
            
            var aps = (userInfo["aps"] as? [AnyHashable: Any])?["custom"] as? [AnyHashable: Any]
            var studentId:String?
            print("local notification payload: \(String(describing: aps))")
            
            if ReaxiumHelper().isAnEmergencyNotification(aps as! Dictionary<String, AnyObject>){
                if let childrens = aps?["users_id"] as? [AnyObject] {
                    for children in childrens{
                        aps?["user_id"] = children
                        let notification = AccessNotification(dictionary: aps as! Dictionary<String, AnyObject>)
                        CoreDataManager.shared.save(notification: notification!)
                        ReaxiumHelper().saveAccessNotification(notification!)
                    }
                }
            }else{
                let notification = AccessNotification(dictionary: aps as! Dictionary<String, AnyObject>)
                studentId = notification?.studentID?.stringValue
                CoreDataManager.shared.save(notification: notification!)
                ReaxiumHelper().saveAccessNotification(notification!)
            }
            
            if UIApplication.shared.applicationState == .active {
                playNotificationSound()
                if isViewControllerVisible(AccessInformationViewController.self) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConstants.accessNotificationKey), object: self)
                }
                else if isViewControllerVisible(HomeViewController.self) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConstants.accessHomeNotificationKey), object: self)
                }
            }else{
                if isViewControllerVisible(AccessInformationViewController.self) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConstants.accessNotificationKey), object: self)
                }
                else if isViewControllerVisible(HomeViewController.self) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConstants.accessHomeNotificationKey), object: self)
                }
                else {
//                    if !ReaxiumHelper().isAnEmergencyNotification(aps as! Dictionary<String, AnyObject>){
                        presentAccessInfoViewControllerForStudent(studentId!)
//                    }
                }
            }
            
        }

    }
    
    func setupNavigationBarAppearance() -> Void {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = ApplicationColors.orange
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // TODO: validar el tipo de notificacion
    }
    
    func isViewControllerVisible(_ aClass: Swift.AnyClass) -> Bool {
        
        if let topController = UIApplication.topViewController() {
            if let visibleController = topController as? MMDrawerController{
                if let navController = UIApplication.topViewController(visibleController.centerViewController){
                    debugPrint(navController)
                    return navController.isKind(of: aClass)
                }
            }
        }
        
        return false
    }
    
    func presentAccessInfoViewControllerForStudent(_ studenID:String)-> Void{
        if let topController = UIApplication.topViewController() {
            if let visibleController = topController as? MMDrawerController{
                if let centerViewController = visibleController.storyboard?.instantiateViewController(withIdentifier: "AccessInformationViewController"){
                    
                    if let centerVC = centerViewController as? AccessInformationViewController{
                        centerVC.targetStudentID = studenID
                        centerVC.showBackButton = true
                    }
                    
                    
                    let centerNav = UINavigationController(rootViewController: centerViewController)
                    visibleController.centerViewController = centerNav
                    
                    if let rightViewController = visibleController.storyboard?.instantiateViewController(withIdentifier: "MenuViewController"){
                        let rightNav = UINavigationController(rootViewController: rightViewController)
                        visibleController.rightDrawerViewController = rightNav
                    }
                    
                }
            }
        }
    }
    
    func playNotificationSound() -> Void {
        var soundID = SystemSoundID()
        let mainBundle = CFBundleGetMainBundle()
        let ref = CFBundleCopyResourceURL(mainBundle, "sound.caf" as CFString, nil, nil)
        AudioServicesCreateSystemSoundID(ref!, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let screenRect = UIScreen.main.bounds
        
        return CGSize(width: screenRect.size.width, height: 64)
    }
}

extension UIViewController {
    func personalizeNavigationBar(_ title: String) {
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 150, height: 64))
        
        let titleView:UIView = UIView.init(frame: rect)
        /* image */
        let image:UIImage = UIImage.init(named: "logo_reaxium_signal")!
        let image_view:UIImageView = UIImageView.init(image: image)
        image_view.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        image_view.center = CGPoint.init(x: titleView.center.x, y: titleView.center.y - 10)
        image_view.layer.cornerRadius = image_view.bounds.size.width / 2.0
        image_view.layer.masksToBounds = true
        titleView.addSubview(image_view)
        
        /* label */
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 35, width: 150, height: 24))
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        titleView.addSubview(label)
        
        self.navigationItem.titleView = titleView
    }
}
