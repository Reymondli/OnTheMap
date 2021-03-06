//
//  UdacityConstants.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-15.
//  Copyright © 2017 ziming li. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        
        // MARK: Udacity API URL
        static let udacityUrl = "https://www.udacity.com/api"
        
        // MARK: Extension of URL for Creating/Deleting a Session
        static let session = "/session"
        
        // MARK: Extension of URL for Getting User Info
        static let user = "/users"
        
        // MARK: Udacity Sign-up URL
        static let udacitySignup = "https://www.udacity.com/account/auth#!/signup"
        
        // MARK: Udacity Request Headers
        static let UdacityHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: HTTPMethod
    enum Method: String {
        case GET
        case POST
        case DELETE
    }
    
    struct JSONResponseKeys {
        
        // MARK: Account
        static let account = "account"
        static let register = "register"
        static let key = "key"
        
        // MARK: Session
        static let session = "session"
        static let session_id = "id"
        static let expiration = "expiration"
    }
}


