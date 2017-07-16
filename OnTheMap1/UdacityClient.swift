//
//  UdacityClient.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-13.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func authenticationByUdacity(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?)-> Void){
        let request = NSMutableURLRequest(url: URL(string: Constants.udacityUrl)!)
        request.httpMethod = httpMethod.post
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                print(error!)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}
