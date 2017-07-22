//
//  NewLocationViewController.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-16.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NewLocationViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var newLocation: UITextField!
    @IBOutlet weak var newURL: UITextField!
    
    var location: String = ""
    var coordinate: CLLocationCoordinate2D?
    var url: String = ""
    
    // MARK: Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        newLocation.delegate = self
        newURL.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Preview New Location
    @IBAction func previewPressed(_ sender: Any) {
        
        // MARK: Check if either textfield is empty
        guard newLocation.text!.isEmpty == false && newURL.text!.isEmpty == false else {
            displayAlert(message: "Location or URL cannot be empty", title: "Hold On")
            return
        }
        // MARK: Check if URL is valid
        guard verifyUrl(urlString: newURL.text) == true else {
            displayAlert(message: "URL is Invalid (Start with https://)", title: "Hold On")
            return
        }
        self.url = newURL.text!
        // MARK: Might add spinning icon during processing...
        
        // MARK: Find Location User Provided
        let newlocation = newLocation.text!
        CLGeocoder().geocodeAddressString(newlocation) { (placemark, error) in
            
            // Was there any error?
            guard error == nil else {
                self.displayAlert(message: "Could Not Find This Location", title: "I'm Lost T T")
                return
            }
            
            self.location = newlocation
            self.coordinate = placemark!.first!.location!.coordinate
            
            // Parse Location and Coordinate Value to Preview Controller
            self.performSegue(withIdentifier: "PreviewLocation", sender: self)
        }
        
    }
    
    // MARK: Cancel Editing
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Check URL Validity
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    // MARK: Segue Connection to Preview Location Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewLocation" {
            let controller = segue.destination as! PreviewViewController
            controller.location = self.location
            controller.coordinate = self.coordinate
            controller.url = self.url
        }
    }
}
