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
    @IBOutlet weak var theScrollView: UIScrollView!
    
    var reachability: Reachability?
    var isNetwordReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Detect tap gesture to dismiss keyboard if it is opened.
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(dismiss)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        indicatorView.hidesWhenStopped = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Start reachability 
        setupReachability()
        startNotifier()
    }
    
    /// Dismiss keyboard if it is opened.
    func dismissKeyboard(){
        view.endEditing(true)
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
        
        // dismiss keyboard if opened.
        dismissKeyboard()
        
        // Check for empty state
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayError("Empty Email or Password.")
        } else {
            
            if isNetwordReached {
                UdacityClient.sharedInstance().login(email: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                    self.performUIUpdatesOnMain {
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
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
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
