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
        code = aDecoder.decodeObject(forKey: "code") as! NSNumber
        message = aDecoder.decodeObject(forKey: "message") as! String
        object = aDecoder.decodeObject(forKey: "object") as AnyObject
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(object, forKey: "object")
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["ReaxiumResponse.code"]
        message <- map["ReaxiumResponse.message"]
        object <- map["ReaxiumResponse.object"]
    }
    
}
