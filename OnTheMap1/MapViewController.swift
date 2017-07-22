//
//  MapViewController.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-16.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    // MARK: Display Pin on the Map
    func showPin() {
        
        // Step 1: Clear All Existing Pin
        mapView.removeAnnotations(mapView.annotations)
        
        // Step 2: Add Pin Based on OTMData Storage
        var annotations = [MKPointAnnotation]()
        
        for eachStudent in OTMData.sharedInstance.studentList {
            
            // Retrieve latitude and longitude of eachStudent
            let latitude = CLLocationDegrees(eachStudent.latitude ?? 0.0)
            let longitude = CLLocationDegrees(eachStudent.longitude ?? 0.0)
            
            // Set Annotation for Display
            let annotation = MKPointAnnotation()
            // Set latitude and longitude
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            // Set title and subtitle
            annotation.title = "\(eachStudent.firstName ?? "") \(eachStudent.lastName ?? "")"
            annotation.subtitle = eachStudent.mediaURL
            // Insert the annotation of eachStudent into annotation array.
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    // MARK: Returns the view associated with the specified annotation object.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: pinId)
        
        // Is this Pin Valid?
        if pin != nil {
            // If yes, assign annotation
            pin!.annotation = annotation
        } else {
            // If not, create new structure, set up property (icon, etc)
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return pin
    }
    
    // MARK: Open URL of the Pin when Tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: (view.annotation!.subtitle!)!) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
}
