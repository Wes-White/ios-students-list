//
//  Student.swift
//  Students
//
//  Created by Andrew R Madsen on 8/5/18.
//  Copyright © 2018 Lambda Inc. All rights reserved.
//

import Foundation

struct Student: Codable {
    var name: String
    var course: String
    
    //firstName is name split at the space " "
    var firstName: String {
        return  String(name.split(separator: " ")[0])
    }
    
    var lastName: String {
        //split at the space if there is no last name then return an empty string. Returns an optional
        return  String(name.split(separator: " ").last ?? "")
    }
}
