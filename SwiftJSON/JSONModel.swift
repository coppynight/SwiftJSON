//
//  JSONModel.swift
//  JSONModel
//
//  Created by justintan on 9/19/15.
//  Copyright © 2015 justintan. All rights reserved.
//

import Foundation

public class JSONModel: NSObject {
    public class func keyMapper() -> JSONKeyMapper {
        return JSONKeyMapper.underscoreCaseToCamelCaseMapper()
    }
    
    public class func className() -> String {
        return NSStringFromClass(self)
    }
    
    public class func propertyClassName(propertyName: String) -> String {
        return ""
    }
    
    public required init?(dict:JSONDict) {
        super.init()
        let properties = getProperties(self)
        let mapper = self.dynamicType.keyMapper()
        for p in properties {
            let name = mapper.map(p.name, isJSONToModel: true)
            var converted = false
            if isFriendType(p.value.dynamicType) {
                self.setValue(dict[name], forKey: p.name)
                converted = true
            } else if let modelDict = dict[name] as? JSONDict {
                var clsName = self.dynamicType.propertyClassName(p.name)
                if clsName.isEmpty {
                    let module = self.dynamicType.className().componentsSeparatedByString(".")[0]
                    clsName = module + "." + p.baseTypeName
                }
                
                if let cls = NSClassFromString(clsName) {
                    if let modelType = cls as? JSONModel.Type {
                        if let model = modelType.init(dict: modelDict) {
                            self.setValue(model, forKey: p.name)
                            converted = true
                        }
                    }
                }
            }
            
            if !converted {
                print("[WARN] please unmarshal property ", p.name, "[", p.value.dynamicType, "] manually", separator:"", terminator:"\n")
            }
        }
    }
    
    public func toDict() ->JSONDict {
        var dict = JSONDict()
        let properties = getProperties(self)
        let mapper = self.dynamicType.keyMapper()
        for p in properties {
            let name = mapper.map(p.name, isJSONToModel: false)
            if isFriendType(p.value.dynamicType) {
                dict[name] = self.valueForKey(p.name)
            } else if let model = p.value as? JSONModel {
                dict[name] = model.toDict()
            } else {
                print("[WARN] please marshal property ", p.name, "[", p.value.dynamicType, "] manually", separator:"", terminator:"\n")
            }
        }
        return dict
    }
}