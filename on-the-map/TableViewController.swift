//
//  TableViewController.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/18/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locations = [StudentInformation]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        activityIndicator.hidesWhenStopped = true
                
        if StudentInformations.data.count == 0 {
            getLocations()
        } else {
            locations = StudentInformations.data
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
                    
                    // set object id used to update student location
                    UdacityClient.sharedInstance().objectID = objectId
                    
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
                StudentInformations.data = results!
                self.locations = StudentInformations.data
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let location = locations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell?.textLabel!.text = "\(location.firstName) \(location.lastName)"
        cell?.detailTextLabel?.text = location.mediaURL
        cell?.imageView!.image = UIImage(named: "icon_pin")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = locations[(indexPath as NSIndexPath).row]
        
        if location.mediaURL == "" {
            displayError("Invalide Link.")
        } else {
            UIApplication.shared.open(URL(string: location.mediaURL)!, options: [:], completionHandler: { success in
                
                if !success {
                    self.displayError("Invalide Link.")
                }
            })
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
