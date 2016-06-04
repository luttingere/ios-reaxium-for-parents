//
//  ReaxiumHelper.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/4/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class ReaxiumHelper{
    
    func isEmptyField(textField: UITextField) -> Bool {
        
        let whitespace:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let trimmed: NSString? = textField.text?.stringByTrimmingCharactersInSet(whitespace)
        
        if let text = textField.text where text.isEmpty{
            return true
        }else if trimmed!.length == 0{
            return true
        }else{
            return false
        }
    }
    
}