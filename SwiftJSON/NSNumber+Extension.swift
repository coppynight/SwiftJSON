//
//  NSNumber+Convert.swift
//  JSONModel
//
//  Created by justintan on 9/19/15.
//  Copyright © 2015 justintan. All rights reserved.
//

import Foundation
public extension NSNumber {
    public convenience init?<T>(value:T) {
        switch value {
        case let i as Bool:
            self.init(bool:i)
        case let i as Int8:
            self.init(char:i)
        case let i as Int16:
            self.init(short:i)
        case let i as Int32:
            self.init(int:i)
        case let i as Int:
            self.init(integer:i)
        case let i as Int64:
            self.init(longLong:i)
        case let i as UInt8:
            self.init(unsignedChar:i)
        case let i as UInt16:
            self.init(unsignedShort:i)
        case let i as UInt32:
            self.init(unsignedInt:i)
        case let i as UInt:
            self.init(unsignedInteger:Int(i))
        case let i as UInt64:
            self.init(unsignedLongLong:i)
        default:
            return nil
        }
    }
    
    public func value<T>() -> T? {
        if T.self == Bool.self {
            return self.boolValue as? T
        } else if T.self == Int8.self {
            return self.charValue as? T
        } else if T.self == Int16.self {
            return self.shortValue as? T
        } else if T.self == Int32.self {
            return self.intValue as? T
        } else if T.self == Int64.self {
            return self.longLongValue as? T
        } else if T.self == UInt8.self {
            return self.unsignedCharValue as? T
        } else if T.self == UInt16.self {
            return self.unsignedShortValue as? T
        } else if T.self == UInt32.self {
            return self.unsignedIntValue as? T
        } else if T.self == UInt.self {
            return UInt(self.unsignedIntegerValue) as? T
        } else if T.self == UInt64.self {
            return self.unsignedLongLongValue as? T
        } else {
            return nil
        }
    }
}