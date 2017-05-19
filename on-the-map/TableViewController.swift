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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.studentLocation.count == 0 {
            getLocations()
        } else {
            locations = appDelegate.studentLocation
        }
    }
    
    /// Refresh data by getting from Parse api.
    ///
    /// - Parameter sender: Refresh button item
    @IBAction func refreshData(_ sender: Any) {
        getLocations()
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
                print(string!)
                return
            }
            
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.studentLocation = results!
                self.locations = appDelegate.studentLocation
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
    }
    
    /// Display error message to the user by using UIAlertAction
    ///
    /// - Parameter message: Error message
    private func displayError(_ message: String){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}
