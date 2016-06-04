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
    
    static let deviceToken = "dasdasdhalksdjhflakshf938487"
    static let devicePlatform = "IOS"
// MORE CONSTANTS...

}

struct GlobalVariable {
    static var loggedUser:User!
}