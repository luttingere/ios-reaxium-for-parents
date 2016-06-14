//
//  UINavigationBar+Height.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 6/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import Foundation
import UIKit

private var AssociatedObjectHandle: UInt8 = 0

extension UINavigationBar {
    
    var height: CGFloat {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGFloat {
                return h
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        if self.height > 0 {
            return CGSizeMake(self.superview!.bounds.size.width, self.height);
        }
        return super.sizeThatFits(size)
    }
        
}