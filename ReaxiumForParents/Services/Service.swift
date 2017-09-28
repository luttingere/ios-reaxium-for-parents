//
//  Service.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation

@objc protocol Service{
    
    @objc optional func callServiceObject(_ parameters:[String: AnyObject]?, withCompletionBlock: ((AnyObject?, _ error: NSError?) -> Void))
    
    @objc optional func callServiceArray(_ parameters:[String: AnyObject]?, withCompletionBlock: ([AnyObject]?, _ error: NSError?) -> Void)
    
}
