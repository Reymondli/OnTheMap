//
//  OTMData.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-19.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation

// This is the Data Storage of the App
class OTMData {
    
    // MARK: User Info - Udacity
    var user: UdacityUserInfo? = nil
    
    // MARK: User Info - Parse
    var student: StudentInfo? = nil
    
    // MARK: List of Student Locations
    var studentList: [StudentInfo] = [StudentInfo]()
    
    class func sharedInstance() -> OTMData {
        struct Singleton {
            static var sharedInstance = OTMData()
        }
        return Singleton.sharedInstance
    }
}
