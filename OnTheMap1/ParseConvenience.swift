//
//  ParseConvenience.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-18.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Preparation - Encode Parameters
    private func escapedParameters(_ parameters: [String: Any]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    // MARK: Step 1 - Initialize Request
    func InitialRequest(url: String, parameters: [String: Any], jsbody: Any? = nil, method: ParseClient.Method) -> NSMutableURLRequest {
        let url = url + escapedParameters(parameters)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = method.rawValue.uppercased()
        
        for (field,value) in ParseClient.Constants.parseHeaders {
            request.addValue(value, forHTTPHeaderField: field)
        }
        
        if jsbody != nil {
            request.httpBody = try! JSONSerialization.data(withJSONObject:jsbody!, options: [])
        }
        
        return request
    }
    
    // MARKL Step 2 - Execute Request
    func ExecuteRequest(request: NSMutableURLRequest, completionHandlerForExecute: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request")
                completionHandlerForExecute(nil, "Connection Error - Error")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForExecute(nil, "Connection Error - Status Code")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerForExecute(nil, "Connection Error - Data")
                return
            }
            print(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            } catch {
                print("JSON converting error")
                completionHandlerForExecute(nil, "Connection error - Parse")
                return
            }
            
            completionHandlerForExecute(parsedResult as AnyObject, nil)
        }
        task.resume()
    }
}
