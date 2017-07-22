//
//  UdacityConvenience.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-15.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE - Udacity Only
    func ShiftedData(data: NSData?) -> NSData? {
        return data?.subdata(with: NSMakeRange(5, data!.length - 5)) as NSData?
    }
    
    // MARK: Step 1 - Initialize Request
    func initialRequest(url: String, jsbody: Any? = nil, method: UdacityClient.Method) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = method.rawValue.uppercased()
        
        for (field,value) in UdacityClient.Constants.UdacityHeaders {
            request.addValue(value, forHTTPHeaderField: field)
        }
        
        if jsbody != nil {
            request.httpBody = try! JSONSerialization.data(withJSONObject:jsbody!, options: [])
        }
        
        // MARK: Set Cookie Value When Deleting a Session
        if method == UdacityClient.Method.DELETE {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            return request
        } else {
            return request
        }
    }
    
    // MARK: Step 2 - Execute Request
    func executeRequest(request: NSMutableURLRequest, completionHandlerForExecute: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request")
                // Connection Error - Error
                completionHandlerForExecute(nil, "Connection Failure")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                // Connection Error - Status Code
                print("Your request returned a status code other than 2xx!")
                completionHandlerForExecute(nil, "Invalid Username or Password")
                return
            }
            
            /* GUARD: Was there any data returned? */
            /* subset response data! */
            guard let data = self.ShiftedData(data: data! as NSData) else {
                print("No data was returned by the request!")
                completionHandlerForExecute(nil, "No data returned, please check your username and password")
                return
            }
            // print(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            } catch {
                print("JSON converting error")
                completionHandlerForExecute(nil, "Invalid data retrieved, please check your username and password")
                return
            }
            
            completionHandlerForExecute(parsedResult as AnyObject, nil)
        }
        task.resume()
    }
    
}
