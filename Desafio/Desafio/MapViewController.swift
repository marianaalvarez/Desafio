//
//  MapViewController.swift
//  Desafio
//
//  Created by Mariana Alvarez on 24/02/16.
//  Copyright © 2016 Mariana Alvarez. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: - CONSTANTS
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    //MARK: - VARIABLES
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - VIEW
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLocationManagerProperties()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CONTROLLER
    
    //MARK: Location Manager
    
    private func setLocationManagerProperties() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization")) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let userLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        self.updateRegion(latitude, longitude: longitude)
    }
    
    func updateRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
    
    
    //MARK: Map View
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if annotation is MKUserLocation {
            return nil
        }
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        pinView!.pinTintColor = UIColor.redColor()
        
        return pinView
    }

}
