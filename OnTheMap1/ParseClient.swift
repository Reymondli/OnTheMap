//
//  ParseClient.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-18.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: GETting a Single Student Location
    // UniqueKey: Udacity Account ID
    func getSingleLocation(uniqueKey: String, completionHandlerForMultipleLocation: @escaping (_ students: StudentInfo?, _ error: String?)-> Void) {
        
        // Set Parameters
        let parameters: [String: Any] = ["where": "{\"uniqueKey\":\"\(uniqueKey)\"}"]
        
        // Set Request
        let request = InitialRequest(url: ParseClient.Constants.parseUrl, parameters: parameters, method: ParseClient.Method.GET)
        
        ExecuteRequest(request: request) { (result, error) in
            // Was there an error
            guard error == nil else {
                completionHandlerForMultipleLocation(nil, error)
                return
            }
            
            // Get Students Info - Array of Dictionary with Only 1 Element
            guard let results = result!["results"] as? [[String: AnyObject]] else {
                completionHandlerForMultipleLocation(nil, "Failed to Get Results")
                return
            }
            
            // Create an Empty StudentInfo Type Dictionary to Load Results Above
            if let dictionary = results.first {
                completionHandlerForMultipleLocation(StudentInfo(dictionary: dictionary), nil)
            } else {
                completionHandlerForMultipleLocation(nil, nil)
            }
        }
    }
    
    // MARK: GETting Multiple Students Locations
    func getMultipleLocation(completionHandlerForSingleLocation: @escaping (_ students: [StudentInfo]?, _ error: String?)-> Void) {
        
        // Set Parameters
        let parameters: [String: Any] = ["limit": 100,
                                          "skip": 0,
                                          "order": "-updatedAt"]
        // Set Request
        let request = InitialRequest(url: ParseClient.Constants.parseUrl, parameters: parameters, method: ParseClient.Method.GET)
        
        ExecuteRequest(request: request) { (result, error) in
            // Was there an error
            guard error == nil else {
                completionHandlerForSingleLocation(nil, error)
                return
            }
            
            // Get Students Info - Arrays of Dictionary
            guard let results = result!["results"] as? [[String: AnyObject]] else {
                completionHandlerForSingleLocation(nil, "Failed to Get Results")
                return
            }
            
            // Create an Empty Array of StudentInfo Type Dictionary to Load Results Above
            var studentLocations: [StudentInfo] = []
            
            for eachStudent in results {
                // Insert Each Student Location
                studentLocations.append(StudentInfo(dictionary: eachStudent))
            }
            
            completionHandlerForSingleLocation(studentLocations, nil)
        }
    }
    
    // MARK: POSTing a Student Location
    func postLocation(student: StudentInfo, completionHandlerForPostLocation: @escaping (_ error: String?)-> Void) {
        
        // Set JSON Body
        let jsbody: [String: Any] = ["uniqueKey": student.uniqueKey!,
                                         "firstName": student.firstName!,
                                         "lastName": student.lastName!,
                                         "latitude": student.latitude!,
                                         "longitude": student.longitude!,
                                         "mediaURL": student.mediaURL!]
        // Set Request
        let request = InitialRequest(url: ParseClient.Constants.parseUrl, parameters: [:], jsbody: jsbody, method: ParseClient.Method.POST)
        
        ExecuteRequest(request: request) { (result, error) in
            // Was there an error
            guard error == nil else {
                completionHandlerForPostLocation(error)
                return
            }
            completionHandlerForPostLocation(nil)
        }
    }
    
    // MARK: PUTting (Updating) a Student Location - ObjectID Needed
    func putLocation(student: StudentInfo, completionHandlerForPutLocation: @escaping (_ error: String?)-> Void) {
        // Set Parameters
        let objectId = student.objectId!
        let url = ParseClient.Constants.parseUrl + "/" + objectId
        // Set JSON Body
        let jsbody: [String: Any] = ["uniqueKey": student.uniqueKey!,
                                     "firstName": student.firstName!,
                                     "lastName": student.lastName!,
                                     "latitude": student.latitude!,
                                     "longitude": student.longitude!,
                                     "mediaURL": student.mediaURL!]
        // Set Request
        let request = InitialRequest(url: url, parameters: [:], jsbody: jsbody, method: ParseClient.Method.PUT)
        
        ExecuteRequest(request: request) { (result, error) in
            // Was there an error
            guard error == nil else {
                completionHandlerForPutLocation(error)
                return
            }
            completionHandlerForPutLocation(nil)
        }
    }
    
}
