//
//  Marshaling.swift
//  JSONModel
//
//  Created by qiyu.tqy on 9/21/15.
//  Copyright © 2015 dove. All rights reserved.
//

import Foundation

public func JSONUnmarshal<T:JSONModel>(jsonString: String) -> T? {
    return JSONUnmarshal(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
}

public func JSONUnmarshal<T:JSONModel>(data: NSData) -> T? {
    if let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONDict {
        return T(dict: dict!)
    }
    return nil
}

public func JSONUnmarshal<T:JSONModel>(jsonString: String) -> [T]? {
    return JSONUnmarshal(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
}

public func JSONUnmarshal<T:JSONModel>(data: NSData) -> [T]? {
    if let obj = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)  {
        if let dictList = obj as? [JSONDict] {
            var values = [T]()
            for d in dictList {
                if let v = T(dict: d) {
                    values.append(v)
                }
            }
            return values
        }
    }
    return nil
}


public func JSONMarshal<T:JSONModel>(value: T) -> NSData? {
    return try? NSJSONSerialization.dataWithJSONObject(value.toDict(), options: .PrettyPrinted)
}

public func JSONUnmarshal<T:JSONModel>(values: [T]) -> NSData? {
    var objs = [JSONDict]()
    for v in values {
        objs.append(v.toDict())
    }
    return try? NSJSONSerialization.dataWithJSONObject(objs, options: .PrettyPrinted)
}