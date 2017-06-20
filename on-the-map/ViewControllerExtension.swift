//
//  ViewControllerExtension.swift
//  on-the-map
//
//  Created by Kosrat D. Ahmad on 6/20/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Display error message to the user by using UIAlertAction
    ///
    /// - Parameter message: Error message
    func displayError(_ message: String){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
