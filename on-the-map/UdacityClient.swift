//
//  UdacityClient.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/13/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

/// Udacity network client class that handles any network request to the Udacity endpoints.
class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    var userID: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: POST
    
    func taskForPOSTMethod (_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, configure the request
        let request = NSMutableURLRequest(url: udacityURLWithExtension(method))
        request.httpMethod = HTTPMethods.Post
        request.addValue(HeadersValue.AcceptValue, forHTTPHeaderField: HeadersKey.AcceptKey)
        request.addValue(HeadersValue.ContentTypeValue, forHTTPHeaderField: HeadersKey.ContentTypeKey)
        request.httpBody = jsonBody.data(using: .utf8)
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String){
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status code other than 2XX!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Delete 
    
    func taskForDELETEMethod (_ method: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, configure the request
        let request = NSMutableURLRequest(url: udacityURLWithExtension(method))
        request.httpMethod = HTTPMethods.Delete
        request.addValue(sessionID!, forHTTPHeaderField: HeadersKey.DeleteTokenKey)
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String){
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                sendError("Your request returned a status code other than 2XX!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
            
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // gevin raw JSON, return a usable Foundation object.
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // Create a URL from parameters
    private func udacityURLWithExtension(_ pathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (pathExtension ?? "")
        
        return components.url!
    }
    
    // MARK: Shared instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singletone {
            static var sharedInstance = UdacityClient()
        }
        return Singletone.sharedInstance
    }
}
