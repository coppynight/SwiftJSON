//
//  JSONDict.swift
//  JSONModel
//
//  Created by justintan on 9/19/15.
//  Copyright © 2015 justintan. All rights reserved.
//

import Foundation

public typealias JSONDict = [String:AnyObject]

public func read<T>(dict:JSONDict, key: String, inout value:T) -> Bool {
    guard let obj = dict[key] else {
        return false
    }
    
    if let v =  obj as? T {
        value = v
        return true
    } else if let num = obj as? NSNumber {
        let i:T? = num.value()
        if i != nil {
            value = i!
        }
        return i != nil 
    } else {
        print("unsupported type", value.dynamicType)
        return false
    }
}

public func read<T>(dict:JSONDict, key: String, inout value:T?) -> Bool {
    guard let obj = dict[key] else {
        return false
    }
    
    if let v =  obj as? T {
        value = v
        return true
    } else if let num = obj as? NSNumber {
        value = num.value()
        return value != nil
    } else {
        print("unsupported type", value.dynamicType)
        return false
    }
}


public func read<T:JSONModel>(dict:JSONDict, key: String, inout value:T?) -> Bool {
    guard let subDict = dict[key] as? JSONDict else {
        return false
    }
    
    value = T(dict:subDict)
    return value != nil
}

public func read<T>(dict:JSONDict, key: String, inout value:[T]) -> Bool {
    guard let objs = dict[key] as? [AnyObject] else {
        return false
    }
    
    for obj in objs {
        if let v = obj as? T {
            value.append(v)
        } else if let num = obj as? NSNumber {
            if let v:T = num.value() {
                value.append(v)
            }
        }
    }
    
    return true
}

public func read<T>(dict:JSONDict, key: String, inout value:[T]?) -> Bool {
    guard let objs = dict[key] as? [AnyObject] else {
        return false
    }
    
    value = [T]()
    for obj in objs {
        if let v = obj as? T {
            value!.append(v)
        } else if let num = obj as? NSNumber {
            if let v:T = num.value() {
                value!.append(v)
            }
        } else {
            print("unsupported type", value.dynamicType)
        }
    }
    
    return true
}

public func read<T:JSONModel>(dict:JSONDict, key: String, inout value:[T]) -> Bool {
    guard let objs = dict[key] as? [JSONDict] else {
        return false
    }
    
    for obj in objs {
        if let v = T(dict: obj) {
            value.append(v)
        }
    }
    
    return true
}

public func read<T:JSONModel>(dict:JSONDict, key: String, inout value:[T]?) -> Bool {
    guard let objs = dict[key] as? [JSONDict] else {
        return false
    }
    
    value = [T]()
    for obj in objs {
        if let v = T(dict: obj) {
            value!.append(v)
        }
    }
    
    return true
}

public func write<T>(inout dict:JSONDict, key: String, value:T) {
    if let obj = value as? AnyObject {
        dict[key] = obj
    } else if let num = NSNumber(value: value) {
        dict[key] = num
    } else {
        print("unsupported type", value.dynamicType)
    }
}

public func write<T>(inout dict:JSONDict, key: String, value:T?) {
    guard let v = value else {
        return
    }
    
    write(&dict, key: key, value: v)
}

public func write<T:JSONModel>(inout dict:JSONDict, key: String, value:T) {
    dict[key] = value.toDict()
}

public func write<T:JSONModel>(inout dict:JSONDict, key: String, value:T?) {
    guard let v = value else {
        return
    }
    
    write(&dict, key: key, value: v)
}

public func write<T>(inout dict:JSONDict, key: String, value:[T]) {
    if value.count == 0 {
        return
    }
    
    if NSNumber(value: value[0]) != nil {
        var nums = [NSNumber]()
        for v in value {
            nums.append(NSNumber(value: v)!)
        }
    } else {
        print("unsupported type", value.dynamicType)
    }
}

public func write<T>(inout dict:JSONDict, key: String, value:[T]?) {
    guard let v = value else {
        return
    }
    
    write(&dict, key: key, value: v)
}

public func write<T:JSONModel>(inout dict:JSONDict, key: String, value:[T]) {
    if value.count == 0 {
        return
    }
    
    var vals = [JSONDict]()
    for v in value {
        vals.append(v.toDict())
    }
    dict[key] = vals
}

public func write<T:JSONModel>(inout dict:JSONDict, key: String, value:[T]?) {
    guard let v = value else {
        return
    }
    
    write(&dict, key: key, value: v)
}