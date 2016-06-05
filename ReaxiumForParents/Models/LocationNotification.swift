//
//  LocationNotification.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import ObjectMapper

class LocationNotification: ReaxiumResponse{
        
    var deviceLocationID: NSNumber!
    var userID: NSNumber!
    var deviceID: NSNumber!
    var latitude: String!
    var longitude: String!
    var dateLocation: NSDate!
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        deviceLocationID <- map["ReaxiumResponse.object.0.device_location_id"]
        userID <- map["ReaxiumResponse.object.0.user_id"]
        deviceID <- map["ReaxiumResponse.object.0.device_id"]
        latitude <- map["ReaxiumResponse.object.0.latitude"]
        longitude <- map["ReaxiumResponse.object.0.longitude"]
        dateLocation <- (map["ReaxiumResponse.object.0.date_location"], DateTransform())
    }
}