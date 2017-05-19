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
    
    let firstName: String
    let lastName: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    // MARK: Initializers 
    
    // Construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]){
        
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
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
