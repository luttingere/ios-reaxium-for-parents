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
    
    override func mapping(map: Map) {
        super.mapping(map)
        ID <- map["ReaxiumResponse.object.0.parent.user_id"]
        name <- map["ReaxiumResponse.object.0.parent.first_name"]
        lastname <- map["ReaxiumResponse.object.0.parent.first_last_name"]
        imageUrl <- map["ReaxiumResponse.object.0.parent.user_photo"]
        children <- map["ReaxiumResponse.object.0.parentRelationship"]
    }
}