//
//  AddLocationViewController.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/20/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var theScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Detect tap gesture to dismiss keyboard if it is opened.
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismiss)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        activityIndicator.hidesWhenStopped = true
        
        locationTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    /// Dismiss keyboard if it is opened.
    func dismissKeyboard(){
        view.endEditing(true)
    }

    @IBAction func findLocation(_ sender: Any) {
        
        // dismiss keyboard if opened.
        dismissKeyboard()
        
        let location = locationTextField.text
        let website = websiteTextField.text?.lowercased()
        
        guard location != "" else {
            displayError("Must Enter a Location.")
            return
        }
        
        guard website != "" else {
            displayError("Must Enter a Website.")
            return
        }
        
        guard (website?.hasPrefix("https://"))! || (website?.hasPrefix("http://"))! else {
            displayError("Invalide Link. Include HTTP(S)://.")
            return
        }
        
        activityIndicator.startAnimating()
        
        CLGeocoder.init().geocodeAddressString(location!) { (placeMark, error) in
            
            self.activityIndicator.stopAnimating()
            
            guard error == nil else {
                self.displayError("Could Not Geocode the String.")
                return
            }
            
            // Get a LocationVerifyViewController from the Storyboard
            let storyNodeController = self.storyboard!.instantiateViewController(withIdentifier: "LocationVerifyViewController")as! LocationVerifyViewController
            
            // Set the location verify view controller properties.
            storyNodeController.locationTitle = location
            storyNodeController.locationLatitude = placeMark?[0].location?.coordinate.latitude
            storyNodeController.locationLongitude = placeMark?[0].location?.coordinate.longitude
            storyNodeController.website = website
            
            // Push the new controller onto the stack
            self.navigationController!.pushViewController(storyNodeController, animated: true)
        }
    }
    
    /// Dismiss the view controller and go back.
    ///
    /// - Parameter sender: Close button.
    @IBAction func dismissAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Delegates 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == locationTextField {
            websiteTextField.becomeFirstResponder()
        }
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.theScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.theScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.theScrollView.contentInset = contentInset
    }
}
