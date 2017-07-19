//
//  ParseConstants.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-18.
//  Copyright © 2017 ziming li. All rights reserved.
//

extension ParseClient {
    struct Constants {
        
        // MARK: Parse API URL
        static let parseUrl = "https://parse.udacity.com/parse/classes/StudentLocation"

        
        // MARK: Udacity Request Headers
        static let parseHeaders = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: HTTPMethod
    enum Method: String {
        case GET
        case POST
        case POT
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
