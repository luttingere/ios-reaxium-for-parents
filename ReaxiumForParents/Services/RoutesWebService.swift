//
//  RoutesWebService.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 7/3/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RoutesWebService: Service {
    
    func callServiceObject(parameters: [String : AnyObject]?, withCompletionBlock: ((AnyObject?, error: NSError?) -> Void)) {
        
        Alamofire.request(.POST, GlobalConstants.APIendpoint.routes, parameters: parameters, encoding: .JSON)
            .responseObject { (response: Response<Routes, NSError>) in
                if response.result.error == nil{
                    debugPrint(response)
                    
                    let responseValue = response.result.value
                    if responseValue?.code == 0{
                        let loggedUser = responseValue
                        withCompletionBlock(loggedUser,error: nil)
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
