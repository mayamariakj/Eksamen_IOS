//
//  MapViewController.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 02/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
// https://medium.com/@kiransjadhav111/corelocation-map-kit-get-the-users-current-location-set-a-pin-in-swift-edb12f9166b2

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager!
    var currentLocationStr = "Current location"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapInformationView: MapInformationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mRegion, animated: true)
        
        //set The Coordinats For weather screen.
        setWeatherCoordinates(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        
        self.mapInformationView.latitudeData.text = String(mUserLocation.coordinate.latitude)
        self.mapInformationView.longitudeData.text = String(mUserLocation.coordinate.longitude)
        self.mapInformationView.weatherImage.image = UIImage(named: "clearsky_day")

        // Get user's Current Location and Drop a pin
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
            mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
            mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
            mapView.addAnnotation(mkAnnotation)
    }
    //MARK:- Intance Methods

    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in

            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    if let Name = dict["Name"] as? String{
                        if let City = dict["City"] as? String{
                            self.currentLocationStr = Name + ", " + City
                        }
                    }
                }
            }
        }
        return currentLocationStr
    }
}
