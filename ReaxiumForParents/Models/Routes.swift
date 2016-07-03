//
//  Routes.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 7/3/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import ObjectMapper

enum RouteType: NSInteger {
    case PickUp = 1
    case DropOff = 2
}

class Routes: ReaxiumResponse{
    
    var routeID: NSNumber!
    var stopID: NSNumber!
    var routeNumber: String!
    var routeTypeInt: NSInteger!
    var routeType: RouteType!
    var scheduleTime: String!
    var stopNumber: String!
    var startDateStr:String!
    var startDate:NSDate?
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        routeID <- map["ReaxiumResponse.object.0.id_route"]
        stopID <- map["ReaxiumResponse.object.0.id_stop"]
        routeNumber <- map["ReaxiumResponse.object.0.route.route_name"]
        routeTypeInt <- map["ReaxiumResponse.object.0.route.route_type"]
        startDateStr <- map["ReaxiumResponse.object.0.start_time"]
        stopNumber <- map["ReaxiumResponse.object.0.stop.stop_name"]
        
        if routeTypeInt != nil {
            routeType = RouteType(rawValue: routeTypeInt)
        }
        
        if startDateStr != nil {
            startDate = ReaxiumHelper().getDateFromStringUTC(startDateStr)
            scheduleTime = ReaxiumHelper().getTimeStringFromDate(startDate)
        }
        
        
    }
}