//
//  ViewController.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 5/12/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit
import ReachabilitySwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var reachability: Reachability?
    var isNetwordReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.hidesWhenStopped = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Start reachability 
        setupReachability()
        startNotifier()
        
        
    }
    
    // MARK: Reachability methods.
    
    func setupReachability() {
        
        let reachability = Reachability()
        self.reachability = reachability
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.isNetwordReached = true
            }
        }
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.isNetwordReached = false
            }
        }
        
    }
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start\nnotifier")
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    deinit {
        stopNotifier()
    }
    
    // MARK: Actions
    
    /// Login method which will start Udcaity client to get user session from Udacity api.
    ///
    /// - Parameter sender: Login button
    @IBAction func login(_ sender: Any) {
        
        // Start animating progress
        indicatorView.startAnimating()
        
        // Check for empty state
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayError("Empty Email or Password.")
        } else {
            
            if isNetwordReached {
                UdacityClient.sharedInstance().login(email: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                    performUIUpdatesOnMain {
                        self.indicatorView.stopAnimating()
                        if success {
                            self.completeLogin()
                        } else {
                            self.displayError("Invalid Email or Password.")
                        }
                    }
                }
            } else {
                displayError("No Internet Connection.")
            }
        }
    }
    
    /// Load a browser to user for sign up from Udacity.
    ///
    /// - Parameter sender: Sign up button
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:],completionHandler: nil)
    }
    
    // MARK: Helper methods
    
    /// Complete login and start main navigation controller.
    private func completeLogin(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    /// Display error message to the user by using UIAlertAction
    ///
    /// - Parameter message: Error message
    private func displayError(_ message: String){
        
        indicatorView.stopAnimating()
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
