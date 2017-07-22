//
//  PreviewViewController.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-20.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PreviewViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    var location: String = ""
    var coordinate: CLLocationCoordinate2D?
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Display the preview map based on User's entered location
        previewPin(coordinate: coordinate!)
    }
    
    @IBOutlet weak var previewMapView: MKMapView!
    
    @IBOutlet weak var processingIndicator: UIActivityIndicatorView!
    
    // MARK: Back Button Goes Back to New Location/URL Page
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        self.processingIndicator.isHidden = false
        self.processingIndicator.startAnimating()
        // MARK: Upload new location and URL
        // Step 1: - Get Current User Info based on User ID when logged in
        UdacityClient.sharedInstance.getUserInfo(userID: UdacityClient.sharedInstance.userID!) { (UdacityUser, error) in
            
            // Check Error
            guard error == nil else {
                DispatchQueue.main.async(execute: {
                    self.processingIndicator.stopAnimating()
                    self.displayAlert(message: error!, title: "Error")
                })
                return
            }
            
            // Load User Info into Parse Format
            var currentInfo = StudentInfo(dictionary:
                [
                    "objectId": UdacityUser!.id as AnyObject,
                    "uniqueKey": UdacityUser!.id as AnyObject,
                    "firstName": UdacityUser!.firstName as AnyObject,
                    "lastName": UdacityUser!.lastName as AnyObject,
                    "mapString": self.location as AnyObject,
                    "mediaURL": self.url as AnyObject,
                    "latitude": Double(self.coordinate!.latitude) as AnyObject,
                    "longitude": Double(self.coordinate!.longitude) as AnyObject,
                    ])
            
            // Step 2: - Provide the User Info to Parse
            // Check local database if user exist or not
            if OTMData.sharedInstance.student != nil {
                // Use Previous Object ID
                currentInfo.objectId = OTMData.sharedInstance.student!.objectId
                // Overwrite user Info
                ParseClient.sharedInstance.putLocation(student: currentInfo){ (error) in
                    DispatchQueue.main.async(execute: {
                        guard error == nil else {
                            self.processingIndicator.stopAnimating()
                            self.displayAlert(message: error!, title: "Error")
                            return
                        }
                        // MARK: Once Success, Unwind Segue and Return to Main Controller Page
                        self.processingIndicator.stopAnimating()
                        self.processingIndicator.isHidden = true
                        self.performSegue(withIdentifier: "MainController", sender: self)
                    })
                }
            } else {
                // Create this new user Info and post
                ParseClient.sharedInstance.postLocation(student: currentInfo) { (error) in
                    DispatchQueue.main.async(execute: {
                        guard error == nil else {
                            self.processingIndicator.stopAnimating()
                            self.displayAlert(message: error!, title: "Error")
                            return
                        }
                        // MARK: Once Success, Unwind Segue and Return to Main Controller Page
                        self.processingIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "MainController", sender: self)
                    })
                }
            }
        }
    }
    
    // MARK: Cancel Button dismiss editing and goes back to Main Tab View
    @IBAction func cancelPressed(_ sender: Any) {
        // MARK: Once Success, Unwind Segue and Return to Main Controller Page
        self.performSegue(withIdentifier: "MainController", sender: self)
    }
    
    // MARK: Create a Pin on the map based on New Location User Provided
    private func previewPin(coordinate: CLLocationCoordinate2D) {
        processingIndicator.isHidden = false
        processingIndicator.startAnimating()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location
        
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1))
        
        DispatchQueue.main.async(execute: {
            self.previewMapView.addAnnotation(annotation)
            self.previewMapView.setRegion(region, animated: true)
            self.previewMapView.regionThatFits(region)
            self.processingIndicator.stopAnimating()
            self.processingIndicator.isHidden = true
        })
    }
    
}
