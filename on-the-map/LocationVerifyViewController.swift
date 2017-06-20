//
//  LocationVerifyViewController.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/20/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit
import MapKit

class LocationVerifyViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationLatitude: CLLocationDegrees?
    var locationLongitude: CLLocationDegrees?
    var locationTitle: String?
    var website: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        activityIndicator.hidesWhenStopped = true
        
        // Add location to the navigation controller.
        navigationItem.title = "Add Location"
        
        selectLocation()
    }
    
    /// Add location annotations to the map
    private func selectLocation() {
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: locationLatitude!, longitude: locationLongitude!)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(locationTitle!)"
        
        // We add the annotations to the map.
        self.mapView.addAnnotation(annotation)
        
        // Zoom map to the location
        let latDelta = 0.05
        let lonDelta = 0.05
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    /// Post or Update student location
    ///
    /// - Parameter sender: Finish button
    @IBAction func postStudentLocation(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        var dictionary = [String: AnyObject]()
        dictionary["objectId"] = "" as AnyObject
        dictionary["uniqueKey"] = UdacityClient.sharedInstance().userID as AnyObject
        dictionary["firstName"] = UdacityClient.sharedInstance().firstName as AnyObject
        dictionary["lastName"] = UdacityClient.sharedInstance().lastName as AnyObject
        dictionary["mapString"] = locationTitle as AnyObject
        dictionary["mediaURL"] = website as AnyObject
        dictionary["latitude"] = Double(locationLatitude!) as AnyObject
        dictionary["longitude"] = Double(locationLongitude!) as AnyObject
        
        let studentLocation = StudentInformation(dictionary: dictionary)
        
        if let _ = UdacityClient.sharedInstance().objectID {
            ParseClient.sharedInstance().updateStudentLocation(studentLocation) { (success, error) in
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    if success {
                        self.finishAddLocation()
                    } else {
                        print(error!)
                        self.displayError("Failed to Update Location.")
                    }
                }
            }
            
        } else {
            ParseClient.sharedInstance().postStudentLocation(studentLocation) { (success, error) in
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    if success {
                        self.finishAddLocation()
                    } else {
                        print(error!)
                        self.displayError("Failed to Post Location.")
                    }
                }
            }
        }
    }
    
    private func finishAddLocation(){
        
        StudentInformations.data = [StudentInformation]()
        
        dismiss(animated: true, completion: nil)
    }
}
