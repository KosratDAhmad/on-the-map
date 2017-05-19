//
//  TableViewController.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/18/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var studentLocations = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get temporary locations
        let locations = hardCodedLocationData()
        
        for dictionary in locations {
            
            studentLocations.append(StudentInformation.init(dictionary: dictionary))
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let location = studentLocations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell?.textLabel!.text = "\(location.firstName) \(location.lastName)"
        cell?.detailTextLabel?.text = location.mediaURL
        cell?.imageView!.image = UIImage(named: "icon_pin")
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = studentLocations[(indexPath as NSIndexPath).row]
        
        UIApplication.shared.open(URL(string: location.mediaURL)!, options: [:], completionHandler: { success in
            
            if !success {
                let alert = UIAlertController(title: "", message: "Invalide Link", preferredStyle: .alert)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // TODO: Remove temporary sample data.
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    
    func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z" as AnyObject,
                "firstName" : "Jessica" as AnyObject,
                "lastName" : "Uelmen" as AnyObject,
                "latitude" : 28.1461248 as AnyObject,
                "longitude" : -82.75676799999999 as AnyObject,
                "mapString" : "Tarpon Springs, FL" as AnyObject,
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en" as AnyObject,
                "objectId" : "kj18GEaWD8" as AnyObject,
                "uniqueKey" : 872458750 as AnyObject,
                "updatedAt" : "2015-03-09T22:07:09.593Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z" as AnyObject,
                "firstName" : "Gabrielle" as AnyObject,
                "lastName" : "Miller-Messner" as AnyObject,
                "latitude" : 35.1740471 as AnyObject,
                "longitude" : -79.3922539 as AnyObject,
                "mapString" : "Southern Pines, NC" as AnyObject,
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en" as AnyObject,
                "objectId" : "8ZEuHF5uX8" as AnyObject,
                "uniqueKey" : "2256298598" as AnyObject,
                "updatedAt" : "2015-03-11T03:23:49.582Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z" as AnyObject,
                "firstName" : "Jason" as AnyObject,
                "lastName" : "Schatz" as AnyObject,
                "latitude" : 37.7617 as AnyObject,
                "longitude" : -122.4216 as AnyObject,
                "mapString" : "18th and Valencia, San Francisco, CA" as AnyObject,
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29" as AnyObject,
                "objectId" : "hiz0vOTmrL" as AnyObject,
                "uniqueKey" : "2362758535" as AnyObject ,
                "updatedAt" : "2015-03-10T17:20:31.828Z" as AnyObject
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z" as AnyObject,
                "firstName" : "Jarrod" as AnyObject,
                "lastName" : "Parkes" as AnyObject,
                "latitude" : 34.73037 as AnyObject,
                "longitude" : -86.58611000000001 as AnyObject,
                "mapString" : "Huntsville, Alabama" as AnyObject,
                "mediaURL" : "https://linkedin.com/in/jarrodparkes" as AnyObject,
                "objectId" : "CDHfAy8sdp" as AnyObject,
                "uniqueKey" : 996618664 as AnyObject,
                "updatedAt" : "2015-03-13T03:37:58.389Z" as AnyObject
            ]
        ]
    }
    
}
