//
//  homeViewController.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 04/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation



class HomeViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet var homeView: HomeView!
    
    
    var locationManager: CLLocationManager!
    var currentLocationStrLat = myLocationLat
    var currentLocationStrLon = myLocationLong
    var umbrella = false
    var updateTimeText = ""
    var easterEggtoggle = true
    
     let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determineCurrentLocation()
        makeRequest()
        updateUiElements()
        
        self.homeView.image.isUserInteractionEnabled = true
        self.homeView.image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
        makeRequest()
        updateUiElements()
    }
    
    func updateUiElements(){
        self.homeView.dayLabel.text = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        self.homeView.image.image = setCorrectImage()
        self.homeView.messageLabel.text = setCorrectUmbrellaText()
        self.homeView.updateTimeLabel.text = "Last Updated: \(updateTimeText)"
    }
    
    func setCorrectImage() -> UIImage {
        
        guard let homeImage = umbrella ? UIImage(named: "umbrella") : UIImage(named: "clearsky_day") else{
            return UIImage()
        }
        return homeImage
    }
    
    func setCorrectUmbrellaText() -> String {
        return umbrella ? "It's going to rain today, bring an umbrella." : "You dont need a umbrella today, its sunnshine and butterflies!"
    }
    
    func makeRequest() {
    
        let weatherUrl : String =  "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=\(currentLocationStrLat)&lon=\(currentLocationStrLon)"
        
        RequestHandler().requestWeaterData(
            url: weatherUrl,
            completed: {(response: Welcome?) in guard let weatherData = response?.properties.timeseries[0].data else {
                return;
            }
            
            if((weatherData.next12_Hours!.summary.symbolCode.contains("rain")) || (weatherData.next12_Hours!.summary.symbolCode.contains("sleet"))){
                self.umbrella = true
            }
            else {
                self.umbrella = false
            }
                
            //https://stackoverflow.com/questions/46376823/ios-swift-get-the-current-local-time-and-date-timestamp
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.updateTimeText = formatter.string(from: Date())
            
            self.updateUiElements()

            print("finished")
        })
        
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
        currentLocationStrLat = String(mUserLocation.coordinate.latitude)
        currentLocationStrLon = String(mUserLocation.coordinate.longitude)

      
     }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // buggettybuggbugg
        if (easterEggtoggle) {
            tappedImage.rotate()
        }
        else {
            tappedImage.bobb()
        }
        easterEggtoggle = !easterEggtoggle
    }
}
//https://stackoverflow.com/questions/31478630/animate-rotation-uiimageview-in-swift
extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.autoreverses = true
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func bobb() {
        let bobb : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        bobb.toValue = [3,3]
        bobb.duration = 1.5
        bobb.autoreverses = true
        self.layer.add(bobb, forKey: "bobbAnimation")
    }
}
