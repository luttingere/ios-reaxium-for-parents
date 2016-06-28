//
//  Constants.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import UIKit

struct GlobalConstants {
    //ENVIROMENT
    struct APIendpoint { //PRODUCTION
        static let baseUrl = "http://54.200.133.84/reaxium/"
        static let login = baseUrl+"Access/checkParentsAccess"
        static let locationUpdate = baseUrl+"DeviceUpdateLocation/requestDeviceUpdateLocation"
    }
    //DEVICE SIZES
    struct Device {
        static let screenWidth = UIScreen.mainScreen().bounds.width
        static let screenHeight = UIScreen.mainScreen().bounds.height
        static let isIphone4orLess = (screenHeight < 568.0)
        static let isIphone5 = (screenHeight == 568.0)
        static let isIphone6 = (screenHeight == 667.0)
    }
    /*struct Colors {
        
    }*/
    
    static let devicePlatform = "IOS"
    static let googleMapsAPIKey = "AIzaSyD-cOxOBGMNKteAFZggp1R_C4Uo3bKe9KQ"
    static let accessNotificationKey = "com.reaxium.accessNotificationKey"
    static let trackNotificationKey = "com.reaxium.trackNotificationKey"
// MORE CONSTANTS...

}

struct GlobalVariable {
    static var loggedUser:User!
    static var accessNotifications = [AccessNotification]()
    static var deviceToken = "simulator"
}