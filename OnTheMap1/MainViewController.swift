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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshPressed()
    }
    
    // MARK: - Unwind Segue From Preview Page
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        refreshPressed()
    }
    
    // MARK: - Logout
    @IBAction func logoutPressed(_ sender: Any) {
        // Might add an confirmation pop-up in case of mis-click
        
        UdacityClient.sharedInstance.logoutFromUdacity() { (error) in
            DispatchQueue.main.async (execute: {
                guard error == nil else {
                    self.displayAlert(message: error!, title: "Logout Failure")
                    return
                }
            
                // Return to Login Window
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    // MARK: - Refresh Map and/or Table List
    @IBAction func refreshPressed() {
        
        ParseClient.sharedInstance.getMultipleLocation{ (students, error) in
            DispatchQueue.main.async (execute: {
                guard error == nil else {
                    self.displayAlert(message: error!, title: "Update Failure")
                    return
                }
                
                // Store/Update Student List inside OTMData
                OTMData.sharedInstance.studentList = students!
                
                // Update Pin Display on Map View Tab
                (self.viewControllers![0] as! MapViewController).showPin()
                
                // Update User List on Table View Tab
                (self.viewControllers![1] as! ListViewController).showList()
            })
        }
    }
    
    // MARK: - Add New Location Pin
    @IBAction func addPinPressed(_ sender: Any) {
        // Check Pin Records for Current User
        ParseClient.sharedInstance.getSingleLocation(uniqueKey: UdacityClient.sharedInstance.userID!) { (student, error) in
            // Main Thread
            DispatchQueue.main.async(execute: {
                guard error == nil else {
                    self.displayAlert(message: error!, title: "Failed to Add Pin")
                    return
                }
                
                OTMData.sharedInstance.student = student
                let nextController = self.storyboard!.instantiateViewController(withIdentifier: "NewLocation")
                // Double Check
                if student != nil {
                    // Overwrite Pin
                    self.confirmAction(message: "You have a pin already, would you like to update it?") { (action) in
                        // Open "Add New Location" Page
                        self.present(nextController, animated: true, completion: nil)
                    }
                } else {
                    // Create Pin
                    self.present(nextController, animated: true, completion: nil)
                }
            })
        }
    }
    
    // MARK: - Confirm
    func confirmAction(message: String, completionHandlerForConfirm: @escaping ((UIAlertAction)!)-> Void) {
        let confirm = UIAlertController(title: "OPPs", message: message, preferredStyle: .alert)
        
        // Set: OK Button
        confirm.addAction(UIAlertAction(title: "OK", style: .default, handler: completionHandlerForConfirm))
        self.present(confirm, animated: true, completion: nil)
        
        // Set: Cancel Button
        confirm.addAction(UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            confirm.dismiss(animated: true, completion: nil)
        })
        
        
    }
}
