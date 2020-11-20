//
//  MapViewController.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 02/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//https://stackoverflow.com/questions/47987473/addressdictionary-is-deprecated-first-deprecated-in-ios-11-0-use-properties
//https://stackoverflow.com/questions/34431459/ios-swift-how-to-add-pinpoint-to-map-on-touch-and-get-detailed-address-of-th
// https://medium.com/@kiransjadhav111/corelocation-map-kit-get-the-users-current-location-set-a-pin-in-swift-edb12f9166b2

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager!
    var currentLocationStr = "Current location"
    var currentLocation: CLLocationCoordinate2D!
    var pinLocation: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapInformationView: MapInformationView!
    @IBOutlet weak var userPinSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTap))
        mapView.addGestureRecognizer(mapTapGesture)
        userPinSwitch.addTarget(self, action: #selector(pinSwitchChanged), for:UIControl.Event.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }
    
    @objc func pinSwitchChanged(pinSwitch: UISwitch){
        if pinSwitch.isOn {
            centerUserOnLocationAndAddPin(location: currentLocation)
        }else{
            centerUserOnLocationAndAddPin(location: pinLocation)
        }
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
        
        centerUserOnLocationAndAddPin(location: center)
        currentLocation = center
        //set The Coordinats For weather screen.
        setWeatherCoordinates(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        
        self.mapInformationView.latitudeData.text = String(mUserLocation.coordinate.latitude)
        self.mapInformationView.longitudeData.text = String(mUserLocation.coordinate.longitude)
        self.mapInformationView.weatherImage.image = UIImage(named: "clearsky_day")
        
        // Get user's Current Location and Drop a pin
       
    }
    
    func centerUserOnLocationAndAddPin(location: CLLocationCoordinate2D){
        let mRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        self.mapView.setRegion(mRegion, animated: true)
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        mkAnnotation.title = self.setUsersClosestLocation(mLattitude: location.latitude, mLongitude: location.longitude)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(mkAnnotation)
    }

    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
        
       let geocoder = CLGeocoder()
           geocoder.reverseGeocodeLocation(location) { (placemarksArray, error) in
               print(placemarksArray!)
               if (error) == nil {
                   if placemarksArray!.count > 0 {
                       let placemark = placemarksArray?[0]
                       let address = "\(placemark?.subThoroughfare ?? ""), \(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"
                       print("\(address)")
                   }
               }

           }
        return currentLocationStr
    }
    
    @objc func mapTap(sender: UIGestureRecognizer){
        print("maptap")
        if sender.state == .ended {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
            print("setting location")
            pinLocation = locationOnMap
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.setUsersClosestLocation(mLattitude: location.latitude, mLongitude: location.longitude)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate{

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }

    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

    if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
        pinView!.pinTintColor = UIColor.black
    }
    else {
        pinView!.annotation = annotation
    }
    return pinView
}

func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("tapped on pin ")
}

func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
        if let doSomething = view.annotation?.title! {
           print("do something")
        }
    }
  }
}
