//
//  ReaxiumHelper.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class ReaxiumHelper{
    
    func isEmptyField(textField: UITextField) -> Bool {
        
        let whitespace:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let trimmed: NSString? = textField.text?.stringByTrimmingCharactersInSet(whitespace)
        
        if let text = textField.text where text.isEmpty{
            return true
        }else if trimmed!.length == 0{
            return true
        }else{
            return false
        }
    }
    
    func saveLoggedUser(user: User, key: String) -> Void {
        
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(user)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(encodedObject, forKey: key)
        userDefaults.synchronize()
        
    }
    
    func removeSavedUserWithKey(key: String)-> Void {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(key)
        userDefaults.synchronize()
    }
    
    func loadLoggedUserWithKey(key: String)-> User? {
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let decodedObject  = userDefaults.objectForKey(key) as? NSData{
            let user = NSKeyedUnarchiver.unarchiveObjectWithData(decodedObject) as! User
            return user
        }else{
            return nil
        }
        
        
    }
    
    func getDateFromString(dateAsString: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = dateFormatter.dateFromString(dateAsString)
        return newDate!
    }

    func getDateFromStringUTC(dateAsString: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "US_en")
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = dateFormatter.dateFromString(dateAsString)
        return newDate!
    }

    func loadStudentsAccessNotificationsArray(studentsArray: [Children]) -> Void {
        print("total students \(studentsArray.count)")
        for student in studentsArray{
            let key = student.ID.stringValue
            GlobalVariable.accessNotifications[key] = [AccessNotification]()
        }
        
    }
    
    func saveAccessNotification(notification: AccessNotification) -> Void {
        
        let key = notification.studentID!.stringValue
        
        if GlobalVariable.accessNotifications[key] != nil {
            GlobalVariable.accessNotifications[key]!.append(notification)
        }
        
    }
    
    func isAnEmergencyNotification(notification: Dictionary<String, AnyObject>) -> Bool {
        
        
        let typeRawValue = notification["traffic_type"]!["traffic_type_id"] as? NSNumber
        
        if (typeRawValue == 3) {
            return true
        }
        
        return false
    }
    
    func getTimeStringFromDate(date:NSDate?) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "America/New_York")
        dateFormatter.dateFormat = "h:mm a"
        let stringDate = dateFormatter.stringFromDate(date!)
        return stringDate
    }
 
}