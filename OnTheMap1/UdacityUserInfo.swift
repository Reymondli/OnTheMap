//
//  UdacityUserInfo.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-18.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation

struct UdacityUserInfo {
    
    var id: String?
    var firstName: String?
    var lastName: String?
    
    // MARK: Initialize Student Info into a Dictionary
    init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
    }
}
