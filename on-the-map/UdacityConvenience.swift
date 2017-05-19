//
//  UdacityConvenience.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/14/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

// MARK: - Add conveniention methods to the UdacityClient class.
extension UdacityClient {
    
    // MARK: Login method
    
    func login(email: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method = Methods.Session
        let jsonBody = "{\"udacity\": { \"\(JSONBodyKeys.UserName)\": \"\(email)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        /* Make the request */
        let _ = taskForPOSTMethod(method, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogin(false, error.localizedDescription)
            } else {
                if let account = results?[JSONResponseKeys.Account] as? [String:AnyObject], let session = results?[JSONResponseKeys.Session] as? [String:AnyObject]{
                    
                    let accountId = account[JSONResponseKeys.AccountKey] as! String
                    let sessionId = session[JSONResponseKeys.SessionID] as! String
                    
                    self.sessionID = sessionId
                    self.userID = accountId
                    
                    completionHandlerForLogin(true, nil)
                } else {
                    
                    completionHandlerForLogin(false, "Could not parse postToFavoritesList")
                }
            }
        }
    }
    
    // MARK: Logout method
    
    func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ erro: String?) -> Void){
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method = Methods.Session
        
        /* Make the request */
        let _ = taskForDELETEMethod(method) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogout(false, error.localizedDescription)
            } else {
                if let _ = results?[JSONResponseKeys.Session] as? [String:AnyObject] {
                    completionHandlerForLogout(true, nil)
                } else {
                    
                    completionHandlerForLogout(false, "Could not parse postToFavoritesList")
                }
            }
        }

    }
}
