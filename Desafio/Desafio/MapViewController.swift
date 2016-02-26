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
    let weatherManager = WeatherManager.sharedInstance
    var mRect: MKMapRect!
    
    //MARK: - VARIABLES
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - VIEW
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.setLocationManagerProperties()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getCities"), name: "getCities", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addAnnotations"), name: "reloadData", object: nil)

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
        let region = MKCoordinateRegionMakeWithDistance(location, 50000, 50000)
       
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
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mRect = self.mapView.visibleMapRect
    }
    
    func addAnnotations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        for item in weatherManager.weatherList {
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(item.latitude), CLLocationDegrees(item.longitude))
            self.mapView.addAnnotation(point)
        }
        
        
    }
    
    //MARK: Bounding Box
    
    func getNECoordinate(mRect: MKMapRect) -> CLLocationCoordinate2D {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(mRect), y: MKMapRectGetMinY(mRect))
    }
    
    func getNWCoordinate(mRect: MKMapRect) -> CLLocationCoordinate2D {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMinX(mRect), y: MKMapRectGetMinY(mRect))
    }
    
    func getSECoordinate(mRect: MKMapRect) -> CLLocationCoordinate2D {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(mRect), y: MKMapRectGetMaxY(mRect))
    }
    
    func getSWCoordinate(mRect: MKMapRect) -> CLLocationCoordinate2D {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMinX(mRect), y: MKMapRectGetMaxY(mRect))
    }
    
    func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D{
        let swMapPoint: MKMapPoint = MKMapPointMake(x, y)
        return MKCoordinateForMapPoint(swMapPoint)
    }
    
    func getCities() {
        let bottomLeft: CLLocationCoordinate2D = self.getSWCoordinate(self.mRect)
        let topRight: CLLocationCoordinate2D = self.getNECoordinate(self.mRect)
        let array = [Double(bottomLeft.longitude), Double(bottomLeft.latitude), Double(topRight.longitude), Double(topRight.latitude)]
        print(array)
        weatherManager.getCities(String(Double(bottomLeft.longitude)), bottom: String(Double(bottomLeft.latitude)), right: String(Double(topRight.longitude)), top: String(Double(topRight.latitude)))
    }

}
