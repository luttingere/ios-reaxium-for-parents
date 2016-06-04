//
//  LoginWebService.swift
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

class LoginWebService: Service {
    
    func callServiceObject(parameters: [String : AnyObject]?, withCompletionBlock: ((AnyObject?, error: NSError?) -> Void)) {
        
        Alamofire.request(.POST, GlobalConstants.APIendpoint.login, parameters: parameters, encoding: .JSON)
            .responseObject { (response: Response<User, NSError>) in
                if response.result.error == nil{
                    
                    let responseValue = response.result.value
                    if responseValue?.code == 0{
                        let loggedUser = responseValue
                        withCompletionBlock(loggedUser,error: nil)
                    }else{
                        /*NSMutableDictionary* details = [NSMutableDictionary dictionary];
                        [details setValue:@"ran out of money" forKey:NSLocalizedDescriptionKey];
                        // populate the error object with the details
                        *error = [NSError errorWithDomain:@"world" code:200 userInfo:details];*/
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
