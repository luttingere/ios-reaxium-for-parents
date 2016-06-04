//
//  ReaxiumResponse.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

class ReaxiumResponse: Mappable {
    
    var code: NSNumber!
    var message: String!
    var object: AnyObject!
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["ReaxiumResponse.code"]
        message <- map["ReaxiumResponse.message"]
        object <- map["ReaxiumResponse.object"]
    }
    
}
