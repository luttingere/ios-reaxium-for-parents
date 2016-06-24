//
//  Children.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

class Children: NSObject, NSCoding, Mappable{
    
    var ID: NSNumber!
    var name: String!
    var lastname: String!
    var imageUrl: String!
    var documentID: String!
    var schoolName: String!
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        ID = aDecoder.decodeObjectForKey("ID") as! NSNumber
        name = aDecoder.decodeObjectForKey("name") as! String
        lastname = aDecoder.decodeObjectForKey("lastname") as! String
        imageUrl = aDecoder.decodeObjectForKey("imageUrl") as! String
        documentID = aDecoder.decodeObjectForKey("documentID") as! String
        schoolName = aDecoder.decodeObjectForKey("schoolName") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(ID, forKey: "ID")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(lastname, forKey: "lastname")
        aCoder.encodeObject(imageUrl, forKey: "imageUrl")
        aCoder.encodeObject(documentID, forKey: "documentID")
        aCoder.encodeObject(schoolName, forKey: "schoolName")
    }
    
    required init?(_ map: Map){

    }
    
    func mapping(map: Map) {
        ID <- map["user_id"]
        name <- map["first_name"]
        lastname <- map["first_last_name"]
        imageUrl <- map["user_photo"]
        documentID <- map["document_id"]
        schoolName <- map["busines.business_name"]
    }
}