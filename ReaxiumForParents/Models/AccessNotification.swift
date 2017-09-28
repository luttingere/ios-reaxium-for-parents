//
//  AccessNotification.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/24/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit

struct AccessType {
    static let boarding: Int32 = 1
    static let arriving: Int32 = 2
    static let emergency: Int32 = 3
}

class AccessNotification: NSObject, NSCoding {
    
    var ID: NSNumber!
    var type: Int32!
    var message: String!
    var studentID: NSNumber?
    var date:Date?
    
    init?(dictionary: Dictionary<String, AnyObject>){
        
        if let accessId = dictionary["access_message_id"] as? NSNumber{
            self.ID = accessId
        }else{
            self.ID = (dictionary["access_message_id"] as! NSString).integerValue as NSNumber
        }
        
        if let accesstype = dictionary["traffic_type"]!["traffic_type_id"] as? NSNumber{
            self.type = accesstype.int32Value
        }else{
            self.type = (dictionary["traffic_type"]!["traffic_type_id"] as! NSString).intValue
        }
        
        let message = dictionary["traffic_info"] as! String
        
        self.message = message.replacingOccurrences(of: "@Time@", with: "")
        
        if let studentId = dictionary["user_id"] as? NSNumber{
            self.studentID = studentId
        }else{
            self.studentID = (dictionary["user_id"] as! NSString).integerValue as NSNumber
        }
        
        self.date = ReaxiumHelper().getDateFromString(dictionary["datetime"] as? String)
    }
    
    required init(coder aDecoder: NSCoder) {
        ID = aDecoder.decodeObject(forKey: "ID") as! NSNumber
        type = aDecoder.decodeObject(forKey: "type") as! Int32
        message = aDecoder.decodeObject(forKey: "message") as! String
        studentID = aDecoder.decodeObject(forKey: "studentID") as? NSNumber
        date = aDecoder.decodeObject(forKey: "date") as? Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID, forKey: "ID")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(studentID, forKey: "studentID")
        aCoder.encode(date, forKey: "date")
    }
    
    func getTimeStringFromDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let stringDate = dateFormatter.string(from: date!)
        return stringDate
    }
    

}
