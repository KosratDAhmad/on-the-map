//
//  UdacityConstants.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/13/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

// MARK: - Add Constants to the UdacityClient class.
extension UdacityClient{
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: HTTP methods
    struct HTTPMethods {
        static let Post = "POST"
        static let Get = "GET"
        static let Delete = "DELETE"
    }
    
    // MARK: JSON Header keys
    struct HeadersKey {
        static let AcceptKey = "Accept"
        static let ContentTypeKey = "Content-Type"
        static let DeleteTokenKey = "X-XSRF-TOKEN"
    }
    
    // Mark: JSON Header values
    struct HeadersValue {
        static let AcceptValue = "application/json"
        static let ContentTypeValue = "application/json"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Session
        static let Session = "/session"
        
        // MARK: User Info
        static let UserInfo = "/user/{id}"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UserName = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Key
    struct JSONResponseKeys {
        
        // MARK: Account
        static let Account = "account"
        static let AccountKey = "key"
        
        // MARK: Session
        static let Session = "session"
        static let SessionID = "id"
    }
}
