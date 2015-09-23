//
//  FriendTypes.swift
//  JSONModel
//
//  Created by qiyu.tqy on 9/21/15.
//  Copyright © 2015 dove. All rights reserved.
//

import Foundation

//These types are supported by KVO
let FriendTypes:[Any.Type] = [
    Int.self,
    Int8.self,
    Int16.self,
    Int32.self,
    Int64.self,
    [Int].self,
    ([Int]?).self,
    UInt.self,
    UInt8.self,
    UInt16.self,
    UInt32.self,
    UInt64.self,
    [UInt].self,
    ([UInt]?).self,
    Bool.self,
    Double.self,
    Float.self,
    String.self,
    (String?).self,
    [String].self,
    ([String]?).self
]

func isFriendType(type: Any.Type) -> Bool {
    for t in FriendTypes {
        if t == type {
            return true
        }
    }
    
    return false
}