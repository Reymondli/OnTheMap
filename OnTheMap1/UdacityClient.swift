//
//  UdacityClient.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-13.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // MARK: Properties
    var session = URLSession.shared
    var sessionID: String? = nil
    var userID: String? = nil
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Creat Session - Authentication
    func authenticationByUdacity(username: String, password: String, completionHandlerForAuth: @escaping (_ error: String?)-> Void){
        
        let jsbody = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        let url = UdacityClient.Constants.udacityUrl + UdacityClient.Constants.session
        let request = InitialRequest(url: url, jsbody: jsbody, method: UdacityClient.Method.POST)
        ExecuteRequest(request: request) { (result, error) in
            // Was there an error
            guard error == nil else {
                completionHandlerForAuth(error)
                return
            }
            
            // Parse JSON Data
            guard let account = result!["account"] as? [String : AnyObject], let userid = account["key"] as? String else {
                print("Failed to Get Account Key")
                completionHandlerForAuth("Username or password is incorrect")
                return
            }
            
            guard let session = result!["session"] as? [String : AnyObject], let sessionid = session["id"] as? String else {
                print("Failed to Get Session ID")
                completionHandlerForAuth("Username or password is incorrect")
                return
            }
            
            self.sessionID = sessionid
            self.userID = userid
            
            completionHandlerForAuth(nil)
        }
    }
    
    // MARK: Delete Session
    func logoutFromUdacity(completionHandlerForLogout: @escaping (_ error: String?)-> Void) {
        
        let url = UdacityClient.Constants.udacityUrl + UdacityClient.Constants.session
        let request = InitialRequest(url: url, jsbody: nil, method: UdacityClient.Method.DELETE)
        ExecuteRequest(request: request) { (result, error) in
            // Was there an error
            guard error == nil else {
                completionHandlerForLogout(error)
                return
            }
            
            // Parse JSON Data
            guard let session = result!["session"] as? [String: AnyObject], let sessionid = session["id"] as? String else {
                print("Failed to Get Session ID")
                completionHandlerForLogout("Logout Failed")
                return
            }
            
            self.sessionID = sessionid
            self.userID = nil
            
            completionHandlerForLogout(nil)
        }
        
    }
    
    // MARK: Manage User Info
    

}
