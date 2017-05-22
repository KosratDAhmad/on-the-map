//
//  MapViewController.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/17/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        mapView.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.studentLocation.count == 0 {
            getLocations()
        } else {
            addPoints(appDelegate.studentLocation)
        }
    }
    
    /// Refresh data by getting from Parse api.
    ///
    /// - Parameter sender: Refresh button item
    @IBAction func refreshData(_ sender: Any) {
        getLocations()
    }
    
    /// Present a form to add location and it will display an alert message if the user added a point before to override or not.
    ///
    /// - Parameter sender: Add Location button item
    @IBAction func addLocation(_ sender: Any) {
        ParseClient.sharedInstance().getStudentLocation() { (location, error) in
            
            DispatchQueue.main.async {
                
                if let objectId = location?.objectId {
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.objectId = objectId
                    
                    let message = "User \"\(UdacityClient.sharedInstance().firstName!) \(UdacityClient.sharedInstance().lastName!)\" has already posted a student location. Would you like to overwrite their location?"
                    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    
                    let dismissAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "AddLocation", sender: self)
                    })
                    
                    alert.addAction(overwriteAction)
                    alert.addAction(dismissAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.performSegue(withIdentifier: "AddLocation", sender: self)
                }
            }
        }
    }
    
    /// Logout from Udacity account.
    ///
    /// - Parameter sender: Logout button item
    @IBAction func logout(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance().logout() {(success, error) in
            
            DispatchQueue.main.async(){
                self.activityIndicator.stopAnimating()
                
                if success {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginView")
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.displayError("There was an error while trying to logout.")
                }
            }
        }
    }
    
    /// Get student location data from Parse api client then save the data in the
    /// AppDelegate to share betwenn view controllers
    private func getLocations() {
        
        activityIndicator.startAnimating()
        
        ParseClient.sharedInstance().getStudentLocations(){ (results, string) in
            
            DispatchQueue.main.async(){
                self.activityIndicator.stopAnimating()
            }
            
            guard (string == nil) else {
                self.displayError("There was an error retrieving student data.")
                return
            }
            
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.studentLocation = results!
                
                self.addPoints(results!)
            }
        }
    }
    
    /// Add student location annotations to the map
    ///
    /// - Parameter locations: StudentInformation data object.
    private func addPoints(_ locations: [StudentInformation]) {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if toOpen == "" {
                    displayError("Invalide Link.")
                } else {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: { success in
                        if !success {
                            self.displayError("Invalide Link.")
                        }
                    })
                }
            }
        }
    }
    
    /// Display error message to the user by using UIAlertAction
    ///
    /// - Parameter message: Error message
    private func displayError(_ message: String){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}
