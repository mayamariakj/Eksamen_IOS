import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager!
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
        }else if pinLocation != nil{
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
        setWeatherCoordinates(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
    }
    
    func centerUserOnLocationAndAddPin(location: CLLocationCoordinate2D){
        let mRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        self.mapView.setRegion(mRegion, animated: true)
        addAnnotation(location: location)
    }
    
    @objc func mapTap(sender: UIGestureRecognizer){
        if sender.state == .ended {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            addAnnotation(location: locationOnMap)
            pinLocation = locationOnMap
            userPinSwitch.setOn(false, animated: true)
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        self.mapInformationView.latitudeData.text = String(format: "%0.5f" ,location.latitude)
        self.mapInformationView.longitudeData.text = String(format: "%0.5f" ,location.longitude)
        
        mapInformationView.getNewWeatherData(lat: location.latitude, lon: location.longitude)
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
}
