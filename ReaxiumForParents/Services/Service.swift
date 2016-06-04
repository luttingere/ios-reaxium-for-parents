//
//  Service.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation

@objc protocol Service{
    
    optional func callServiceObject(parameters:[String: AnyObject]?, withCompletionBlock: ((AnyObject?, error: NSError?) -> Void))
    
    optional func callServiceArray(parameters:[String: AnyObject]?, withCompletionBlock: ([AnyObject]?, error: NSError?) -> Void)
    
}