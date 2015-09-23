//
//  Property.swift
//  JSONModel
//
//  Created by justintan.tqy on 9/20/15.
//  Copyright © 2015 dove. All rights reserved.
//

import Foundation

class Property {
    var name: String
    var value: Any
    var baseTypeName: String = ""
    var isOptional: Bool = false
    init(name:String, value:Any) {
        self.name = name
        self.value = value
        print(value.dynamicType, separator: "", terminator: "", toStream: &self.baseTypeName)
        self.isOptional = (self.baseTypeName as NSString).rangeOfString("Optional").length > 0
        let regx = try! NSRegularExpression(pattern: "(Optional<){1}(.+)(>){1}", options: .CaseInsensitive)
        let tmpStr = NSMutableString(string: self.baseTypeName)
        var n = 0
        repeat {
            n = regx.replaceMatchesInString(tmpStr, options: .ReportProgress, range: NSMakeRange(0, tmpStr.length), withTemplate: "$2")
        } while(n>0)
        self.baseTypeName = tmpStr as String
    }
}


func getProperties(value: Any) ->[Property] {
    var properties:[Property] = [Property]()
    let children = Mirror(reflecting:value).children
    for i in children.startIndex ..< children.endIndex {
        if let name = children[i].label {
            properties.append(Property(name: name, value:children[i].value))
        }
    }
    return properties
}