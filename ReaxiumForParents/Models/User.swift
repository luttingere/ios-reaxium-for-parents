//
//  UserProfile.swift
//  NewProject
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

class User: ReaxiumResponse{
    
    var ID: NSNumber!
    var name: String!
    var lastname: String!
    var imageUrl: String!
    var children:[Children]!
    

    required init?(_ map: Map){
        super.init(map)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ID = aDecoder.decodeObjectForKey("ID") as! NSNumber
        name = aDecoder.decodeObjectForKey("name") as! String
        lastname = aDecoder.decodeObjectForKey("lastname") as! String
        imageUrl = aDecoder.decodeObjectForKey("imageUrl") as! String
        children = aDecoder.decodeObjectForKey("children") as! [Children]
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(ID, forKey: "ID")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(lastname, forKey: "lastname")
        aCoder.encodeObject(imageUrl, forKey: "imageUrl")
        aCoder.encodeObject(children, forKey: "children")
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        ID <- map["ReaxiumResponse.object.0.parent.user_id"]
        name <- map["ReaxiumResponse.object.0.parent.first_name"]
        lastname <- map["ReaxiumResponse.object.0.parent.first_last_name"]
        imageUrl <- map["ReaxiumResponse.object.0.parent.user_photo"]
        children <- map["ReaxiumResponse.object.0.parentRelationship"]
    }
}