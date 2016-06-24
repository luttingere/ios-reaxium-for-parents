//
//  ReaxiumResponse.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import ObjectMapper

class ReaxiumResponse: NSObject, NSCoding, Mappable {
    
    var code: NSNumber!
    var message: String!
    var object: AnyObject!
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        code = aDecoder.decodeObjectForKey("code") as! NSNumber
        message = aDecoder.decodeObjectForKey("message") as! String
        object = aDecoder.decodeObjectForKey("object")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(message, forKey: "message")
        aCoder.encodeObject(object, forKey: "object")
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["ReaxiumResponse.code"]
        message <- map["ReaxiumResponse.message"]
        object <- map["ReaxiumResponse.object"]
    }
    
}
