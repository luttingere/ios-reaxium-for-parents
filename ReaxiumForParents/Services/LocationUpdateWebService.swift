//
//  LocationUpdateWebService.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class LocationUpdateWebService:  Service {
    
    func callServiceObject(parameters: [String : AnyObject]?, withCompletionBlock: ((AnyObject?, error: NSError?) -> Void)) {
        
        Alamofire.request(.POST, GlobalConstants.APIendpoint.locationUpdate, parameters: parameters, encoding: .JSON)
            .responseObject { (response: Response<LocationNotification, NSError>) in
                
                //debugPrint(response)
                
                if response.result.error == nil{
                    
                    let responseValue = response.result.value
                    if responseValue?.code == 0{
                        let locationUpdate = responseValue
                        withCompletionBlock(locationUpdate,error: nil)
                    }else{
                        let errorDetails = Dictionary(dictionaryLiteral: (NSLocalizedDescriptionKey, responseValue!.message))
                        let responseError = NSError(domain: "com.reaxium.ReaxiumForParents", code: responseValue!.code.integerValue, userInfo: errorDetails)
                        withCompletionBlock(nil,error: responseError)
                    }
                }else{
                    withCompletionBlock(nil,error: response.result.error)
                }
        }
    }
}