//
//  Student.swift
//  Examples
//
//  Created by qiyu.tqy on 9/20/15.
//  Copyright © 2015 JustinTan. All rights reserved.
//

import Foundation

import JSONModel

class Student: JSONModel {
    var name: String?
    var score: Double = 0
    var teacher: Teacher?
    
    override func toDict() -> JSONDict {
        var dict = super.toDict()
        write(&dict, key: "teacher", value: self.teacher)
        return dict
    }
}