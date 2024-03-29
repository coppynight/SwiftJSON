//
//  JSONKeyMapper.swift
//  JSONModel
//
//  Created by justintan on 9/20/15.
//  Copyright © 2015 justintan. All rights reserved.
//

import Foundation

public class JSONKeyMapper {
    public typealias MapClosure = String -> String
    private var modelToJSON = [String:String]()
    private var jsonToModel = [String:String]()
    private var modelToJSONMapping:MapClosure?
    private var jsonToModelMapping:MapClosure?
    
    public func map(key: String, isJSONToModel: Bool) -> String {
        if isJSONToModel {
            if let str = self.jsonToModel[key] {
                return str
            } else if let str = self.jsonToModelMapping?(key){
                return str
            }
        } else {
            if let str = self.modelToJSON[key] {
                return str
            } else if let str = self.modelToJSONMapping?(key){
                return str
            }
        }
        return key
    }
    
    public var staticMap:[String:String] {
        get {
            return modelToJSON
        }
        set {
            modelToJSON = newValue
            for (k,v) in modelToJSON {
                jsonToModel[v] = k
            }
        }
    }
    
    class func underscoreCaseToCamelCaseMapper() -> JSONKeyMapper {
        let m = JSONKeyMapper()
        m.modelToJSONMapping = {
            (var key: String) -> String
            in
            var result = ""
            var converting = false
            for x in key.unicodeScalars {
                if x.isDigit() || x.isUpperCase() {
                    if !converting {
                        converting = true
                        if !result.isEmpty {
                            result.appendContentsOf("_")
                        }
                    }
                } else {
                    converting = false
                }
                
                result.append(x.lowerCase())
            }
            
            return result
        }
        
        m.jsonToModelMapping = {
            (key: String) -> String
            in
            var result = ""
            var converting = false
            for x in key.unicodeScalars {
                if x.value == 95 { //95 is ASCII value of '_'
                    converting = true
                } else {
                    if converting && x.isLowerCase() {
                        result.append(x.upperCase())
                    } else {
                        result.append(x)
                    }
                    converting = false
                }
            }
            
            return result
        }
        
        return m
    }
}