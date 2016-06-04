//
//  Children.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

class Children: Mappable{
    
    var ID: NSNumber!
    var name: String!
    var lastname: String!
    var imageUrl: String!
    var documentID: String!
    var schoolName: String!
    
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