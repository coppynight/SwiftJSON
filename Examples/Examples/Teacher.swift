//
//  Teacher.swift
//  Examples
//
//  Created by qiyu.tqy on 9/20/15.
//  Copyright © 2015 JustinTan. All rights reserved.
//

import Foundation

import JSONModel

class Teacher: JSONModel {
    var name: String?
    var gender: Bool = false
    var classes: [String]?
    var age: Int=0
}