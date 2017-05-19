//
//  ParseConvenience.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/19/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

// MARK: - Add conveniention methods to the ParseClient class.
extension ParseClient {

    // MARK: Get Student Location Method.
    
    func getStudentLocations(completionHandlerForGetLocation: @escaping (_ result: [StudentInformation]?, _ error: String?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method = Methods.StudentLocation
        var parameters = [String: AnyObject]()
        parameters[ParameterKeys.Limit] = ParameterValues.Limit as AnyObject
        parameters[ParameterKeys.Order] = ParameterValues.Order as AnyObject
        
        /* Make the request */
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetLocation(nil, error.localizedDescription)
            } else {
                
                if let results = results?[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let locations = StudentInformation.locationsFromResults(results)
                    completionHandlerForGetLocation(locations, nil)
                    
                } else {
                    
                    completionHandlerForGetLocation(nil, "Could not parse getStudentLocations")
                }
            }
        }

    }
}
