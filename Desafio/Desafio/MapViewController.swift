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

    
    //MARK: - VARIABLES
    var mRect: MKMapRect!
    var currentLocation: CLLocation?
    var arrayDistances = [Double]()
    var region = MKCoordinateRegion()
    var mapLoaded = false
    var index: Int?
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - VIEW
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.setLocationManagerProperties()
        self.setNotificationObservers()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - CONTROLLER
    
    private func setNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addAnnotation:"), name: "addAnnotation", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("removeAnnotations"), name: "removeAnnotations", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getCities"), name: "getCities", object: nil)
    }
    
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
        
        self.currentLocation = locations[0]
        let userLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        self.updateRegion(latitude, longitude: longitude)
    }
    
    func updateRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.region = MKCoordinateRegionMakeWithDistance(location, 50000, 50000)
       
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    
    //MARK: Map View
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        print(annotation.title!!)
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if annotation is MKUserLocation {
            return nil
        }
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.pinTintColor = UIColor.redColor()
        pinView!.canShowCallout = true
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        pinView?.leftCalloutAccessoryView = imageView
        
        for item in weatherManager.weatherListSort  {
            let lat1 = String(pinView!.annotation!.coordinate.latitude)
            let lat2 = String(item.latitude)
            let lon1 = String(pinView!.annotation!.coordinate.longitude)
            let lon2 = String(item.longitude)
            
            if lat1 == lat2 && lon1 == lon2 {
                imageView.image = UIImage(named: item.icon)
            }
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mRect = self.mapView.visibleMapRect
        if mapLoaded == true {
            self.currentLocation = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
            self.getCities()
        }
    }
    
    func addAnnotation(notification: NSNotification) {
        let weather = notification.userInfo!["weather"] as! Weather
        
        // Add pin
        let point = MKPointAnnotation()
        point.title = "\(Int(weather.temp))º"
        print(point.title)
        point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(weather.latitude), CLLocationDegrees( weather.longitude))
        self.mapView.addAnnotation(point)

        
        // Distance between points
        let loc = CLLocation(latitude: weather.latitude, longitude: weather.longitude)
        let dist: CLLocationDistance = (self.currentLocation?.distanceFromLocation(loc))!
            
        self.arrayDistances.append(Double(dist))
        
        let sortedArray = self.arrayDistances.sort()
        
        weatherManager.weatherListSort.removeAll()
        
        for var i = 0; i < sortedArray.count; i++ {
            for var x = 0; x < self.arrayDistances.count; x++ {
                if sortedArray[i] == self.arrayDistances[x] {
                    weatherManager.weatherListSort.append(self.weatherManager.weatherList[x])
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: self)

    }
    
    func removeAnnotations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.arrayDistances.removeAll()
    }
    
    func sortFunc(num1: Double, num2: Double) -> Bool {
        return num1 < num2
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
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        let lat1 = String(self.mapView.region.center.latitude)
        let lat2 = String(self.region.center.latitude)
        let lon1 = String(self.mapView.region.center.longitude)
        let lon2 = String(self.region.center.longitude)

        if lat1 == lat2 && lon1 == lon2 {
            self.getCities()
            self.mapLoaded = true
        }
    }
    

}
