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
    
    func isEmptyField(_ textField: UITextField) -> Bool {
        
        let whitespace:CharacterSet = CharacterSet.whitespacesAndNewlines
        let trimmed: NSString? = textField.text?.trimmingCharacters(in: whitespace) as! NSString
        
        if let text = textField.text, text.isEmpty{
            return true
        }else if trimmed!.length == 0{
            return true
        }else{
            return false
        }
    }
    
    func saveLoggedUser(_ user: User, key: String) -> Void {
        
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: user)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedObject, forKey: key)
        userDefaults.synchronize()
        
    }
    
    func removeSavedUserWithKey(_ key: String)-> Void {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    func loadLoggedUserWithKey(_ key: String)-> User? {
        let userDefaults:UserDefaults = UserDefaults.standard
        if let decodedObject  = userDefaults.object(forKey: key) as? Data{
            let user = NSKeyedUnarchiver.unarchiveObject(with: decodedObject) as! User
            return user
        }else{
            return nil
        }
        
        
    }
    
    static func getComponentsFrom(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.day, .month, .year], from: date)
    }
    
    static func getTimeStringFromDate(date: NSDate) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let stringDate = dateFormatter.string(from: date as Date)
        return stringDate
    }
    
    func getDateFromString(_ dateAsString: String?) -> Date {
        let dateFormatter = DateFormatter()
        var date: Date?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let strDate = dateAsString else {
            return Date()
        }
        
        date = dateFormatter.date(from: strDate)
        
        guard date != nil else {
            return Date()
        }
        
        return date!
    }

    func getDateFromStringUTC(_ dateAsString: String) -> Date{
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "US_en")
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = dateFormatter.date(from: dateAsString)
        return newDate!
    }

    func loadStudentsAccessNotificationsArray(_ studentsArray: [Children]) -> Void {
        print("total students \(studentsArray.count)")
        for student in studentsArray{
            let key = student.ID.stringValue
            GlobalVariable.accessNotifications[key] = [AccessNotification]()
        }
        
    }
    
    func saveAccessNotification(_ notification: AccessNotification) -> Void {
        
        let key = notification.studentID!.stringValue
        
        if GlobalVariable.accessNotifications[key] != nil {
            GlobalVariable.accessNotifications[key]!.append(notification)
        }
        
    }
    
    func isAnEmergencyNotification(_ notification: Dictionary<String, AnyObject>) -> Bool {
        
        
        let typeRawValue = notification["traffic_type"]!["traffic_type_id"] as? NSNumber
        
        if (typeRawValue == 3) {
            return true
        }
        
        return false
    }
    
    func getTimeStringFromDate(_ date:Date?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
        dateFormatter.dateFormat = "h:mm a"
        let stringDate = dateFormatter.string(from: date!)
        return stringDate
    }
 
}
