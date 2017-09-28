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
    var businessInformation: BusinessInformation!
    

    required init?(map: Map){
        super.init(map: map)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ID = aDecoder.decodeObject(forKey: "ID") as! NSNumber
        name = aDecoder.decodeObject(forKey: "name") as! String
        lastname = aDecoder.decodeObject(forKey: "lastname") as! String
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as! String
        children = aDecoder.decodeObject(forKey: "children") as! [Children]
        businessInformation = aDecoder.decodeObject(forKey: "businessInformation") as! BusinessInformation
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(ID, forKey: "ID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(lastname, forKey: "lastname")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(children, forKey: "children")
        aCoder.encode(businessInformation, forKey: "businessInformation")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        ID <- map["ReaxiumResponse.object.0.parent.user_id"]
        name <- map["ReaxiumResponse.object.0.parent.first_name"]
        lastname <- map["ReaxiumResponse.object.0.parent.first_last_name"]
        imageUrl <- map["ReaxiumResponse.object.0.parent.user_photo"]
        children <- map["ReaxiumResponse.object.0.parentRelationship"]
        businessInformation <- map["ReaxiumResponse.object.0.business_information"]
    }
}
