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
    
    func callServiceObject(_ parameters: [String : AnyObject]?, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)) {
        
        Alamofire.request(GlobalConstants.APIendpoint.login, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseObject { (response: DataResponse<User>) in
                
                print(response)
                
                if response.result.error == nil{
                    
                    let responseValue = response.result.value
                    if responseValue?.code == 0{
                        let loggedUser = responseValue
                        withCompletionBlock(loggedUser, nil)
                    }else{
                        let errorDetails = Dictionary(dictionaryLiteral: (NSLocalizedDescriptionKey, responseValue!.message))
                        let responseError = NSError(domain: "com.reaxium.ReaxiumForParents", code: responseValue?.code as! Int, userInfo: errorDetails)
                        withCompletionBlock(nil, responseError)
                    }
                }else{
                    withCompletionBlock(nil, response.result.error as NSError?)
                }
        }
    }
}
