//
//  MainViewController.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-16.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    // MARK: - Property
    
    
    
    // MARK: - Logout
    @IBAction func logoutPressed(_ sender: Any) {
        // Might add an confirmation pop-up in case of mis-click
        
        UdacityClient.sharedInstance().logoutFromUdacity() { (error) in
            
        }
        
        // Return to Login Window
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Refresh Map and/or Table List
    
    @IBAction func refreshPressed(_ sender: Any) {
        
    }
    
    // MARK: - Add New Location Pin
    @IBAction func addPinPressed(_ sender: Any) {
        
    }
}
