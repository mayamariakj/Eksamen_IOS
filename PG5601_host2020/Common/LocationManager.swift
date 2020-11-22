//
//  LocationManager.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 22/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate{
    func didGetLocationData(lat: Double, lon: Double)
}

class LocationManager{
    /*
    var delegate: LocationManagerDelegate?
    var locationManager: CLLocationManager!

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
    }
 */
}
