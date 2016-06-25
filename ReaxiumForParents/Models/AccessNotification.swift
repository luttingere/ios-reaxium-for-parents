//
//  AccessNotification.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/24/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

enum AccessType: NSInteger {
    case Boarding = 1
    case Arriving = 2
    case Emergency = 3
}

class AccessNotification: NSObject, NSCoding {
    
    var ID: NSNumber!
    var type:AccessType!
    var message: String!
    var studentID: NSNumber?
    var date:NSDate?
    
    init?(dictionary: Dictionary<String, AnyObject?>){
        
        self.ID = dictionary["traffic_id"] as! NSNumber
        self.type = AccessType(rawValue: dictionary["traffic_type_id"] as! NSInteger)
        self.message = dictionary["traffic_info"] as! String
        self.studentID = dictionary["access_id"] as? NSNumber
        self.date = dictionary["datetime"] as? NSDate
    }
    
    required init(coder aDecoder: NSCoder) {
        ID = aDecoder.decodeObjectForKey("ID") as! NSNumber
        type = aDecoder.decodeObjectForKey("type") as! AccessType
        message = aDecoder.decodeObjectForKey("message") as! String
        studentID = aDecoder.decodeObjectForKey("studentID") as? NSNumber
        date = aDecoder.decodeObjectForKey("date") as? NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(ID, forKey: "ID")
        aCoder.encodeInteger(type.rawValue, forKey: "type")
        aCoder.encodeObject(message, forKey: "message")
        aCoder.encodeObject(studentID, forKey: "studentID")
        aCoder.encodeObject(date, forKey: "date")
    }
    
    func getTimeStringFromDate() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let stringDate = dateFormatter.stringFromDate(date!)
        return stringDate
    }

}
