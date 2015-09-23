//
//  UnicodeScalar+Extension.swift
//  JSONModel
//
//  Created by justintan on 9/20/15.
//  Copyright © 2015 justintan. All rights reserved.
//

import Foundation

public extension UnicodeScalar {
    public func isDigit() -> Bool {
        return self.value >= 48 && self.value <= 57
    }
    
    public func isUpperCase() -> Bool {
        return self.value >= 65 && self.value <= 90
    }
    
    public func isLowerCase() -> Bool {
        return self.value >= 97 && self.value <= 122
    }
    
    public func upperCase() -> UnicodeScalar {
        if self.isLowerCase() {
            return UnicodeScalar(self.value - 32)
        } else {
            return self
        }
    }
    
    public func lowerCase() -> UnicodeScalar {
        if self.isUpperCase() {
            return UnicodeScalar(self.value + 32)
        } else {
            return self
        }
    }
}