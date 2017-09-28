//
//  LogoutWebService.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 28/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class LogoutWebService: Service {
    
    func callServiceObject(_ parameters: [String : AnyObject]?, withCompletionBlock: @escaping ((AnyObject?, _ error: NSError?) -> Void)) {
        
        Alamofire.request(GlobalConstants.APIendpoint.logout, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseObject { (response: DataResponse<ReaxiumResponse>) in
                if response.result.error == nil{
                    
                    let responseValue = response.result.value
                    if responseValue?.code == 0{
                        withCompletionBlock(responseValue, nil)
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
