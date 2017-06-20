//
//  StudentLocation.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/18/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

struct StudentInformation {
    
    // MARK: Properties
    
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    // MARK: Initializers
    
    // Construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]){
        
        objectId = dictionary["objectId"] as! String
        if let uniqueKey = dictionary["uniqueKey"] {
            self.uniqueKey = uniqueKey as! String
        } else {
            uniqueKey = ""
        }
        if let firstName = dictionary["firstName"], let lastName = dictionary["lastName"] {
            self.firstName = firstName as! String
            self.lastName = lastName as! String
        } else {
            firstName = ""
            lastName = ""
        }
        
        if let mapString = dictionary["mapString"], let mediaURL = dictionary["mediaURL"], let latitude = dictionary["latitude"], let longitude = dictionary["longitude"] {
            self.mapString = mapString as! String
            self.mediaURL = mediaURL as! String
            self.latitude = latitude as! Double
            self.longitude = longitude as! Double
        } else {
            mapString = ""
            mediaURL = ""
            latitude = 0.0
            longitude = 0.0
        }
    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var locations = [StudentInformation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            locations.append(StudentInformation(dictionary: result))
        }
        
        return locations
    }
}
