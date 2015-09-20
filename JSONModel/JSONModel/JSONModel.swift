//
//  JSONModel.swift
//  JSONModel
//
//  Created by justintan on 9/19/15.
//  Copyright © 2015 justintan. All rights reserved.
//

import Foundation

public class JSONModel: NSObject {
    private static var supportedTypes:[Any.Type]!
    private class func getSupportedTypes() -> [Any.Type] {
        var types = [Any.Type]()
        types.append(Int.self)
        types.append(Int8.self)
        types.append(Int16.self)
        types.append(Int32.self)
        types.append(Int64.self)
        types.append([Int].self)
        types.append(([Int]?).self)
        
        types.append(UInt.self)
        types.append(UInt8.self)
        types.append(UInt16.self)
        types.append(UInt32.self)
        types.append(UInt64.self)
        types.append([UInt].self)
        types.append(([UInt]?).self)
        
        types.append(Bool.self)
        types.append(Double.self)
        types.append(Float.self)
        
        types.append(String.self)
        types.append((String?).self)
        types.append([String].self)
        types.append(([String]?).self)
        
        return types
    }
    
    private class func isSupported(type: Any.Type) -> Bool {
        for t in supportedTypes {
            if t == type {
                return true
            }
        }
        
        return false
    }
    
    public required init?(dict:JSONDict) {
        super.init()
        let properties = getProperties(self)
        let mapper = self.dynamicType.keyMapper()
        for p in properties {
            let name = mapper.map(p.name, isJSONToModel: true)
            if JSONModel.isSupported(p.value.dynamicType) {
                self.setValue(dict[name], forKey: p.name)
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
                        }
                    }
                }
            } else {
                print("SKIP", p.name, p.value.dynamicType)
            }
        }
    }
    
    public func toDict() ->JSONDict {
        var dict = JSONDict()
        let properties = getProperties(self)
        let mapper = self.dynamicType.keyMapper()
        for p in properties {
            let name = mapper.map(p.name, isJSONToModel: false)
            if JSONModel.isSupported(p.value.dynamicType) {
                dict[name] = self.valueForKey(p.name)
            } else if let model = p.value as? JSONModel {
                dict[name] = model.toDict()
            } else {
                print("SKIP", p.name, p.value.dynamicType)
            }
        }
        return dict
    }
    
    public class func keyMapper() -> JSONKeyMapper {
        return JSONKeyMapper.underscoreCaseToCamelCaseMapper()
    }
    
    
    public override class func initialize() {
        if supportedTypes == nil {
            supportedTypes = getSupportedTypes()
        }
    }
    
    public class func className() -> String {
        return NSStringFromClass(self)
    }
    
    public class func propertyClassName(propertyName: String) -> String {
        return ""
    }
    
    public class func unmarshal<T:JSONModel>(jsonString: String) -> T? {
        return unmarshal(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    public class func unmarshal<T:JSONModel>(data: NSData) -> T? {
        if let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONDict {
            return T(dict: dict!)
        }
        return nil
    }
    
    public class func unmarshal<T:JSONModel>(jsonString: String) -> [T]? {
        return unmarshal(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    public class func unmarshal<T:JSONModel>(data: NSData) -> [T]? {
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
    
    
    public class func marshal<T:JSONModel>(value: T) -> NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(value.toDict(), options: .PrettyPrinted)
    }
    
    public class func unmarshal<T:JSONModel>(values: [T]) -> NSData? {
        var objs = [JSONDict]()
        for v in values {
            objs.append(v.toDict())
        }
        return try? NSJSONSerialization.dataWithJSONObject(objs, options: .PrettyPrinted)
    }
}