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

}