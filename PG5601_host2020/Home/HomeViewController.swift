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
    
    public var itemIndex: Int = 0
    
    var locationManager: CLLocationManager!
    var currentLocationStrLat = myLocationLat
    var currentLocationStrLon = myLocationLong
    var umbrella = false
    var updateTimeText = ""
    var easterEggtoggle = true
    var date: Date = Date()
    
     let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUiElements()
        
        self.homeView.image.isUserInteractionEnabled = true
        self.homeView.image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !umbrella {
            UIView.animate(withDuration: 1.0, animations: {
                self.view.backgroundColor = UIColor.yellow
            })
            self.homeView.image.allwaysRotate()
        }
        else{
            self.homeView.drop()
        }
        updateUiElements()
    }
    
    func updateUiElements(){
        self.homeView.dayLabel.text = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if (easterEggtoggle) {
            tappedImage.rotate()
        }
        else {
            tappedImage.bobb()
        }
        easterEggtoggle = !easterEggtoggle
    }
}

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.autoreverses = true
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func allwaysRotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 20
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func bobb() {
        let bobb : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        bobb.toValue = [3,3]
        bobb.duration = 1.5
        bobb.autoreverses = true
        self.layer.add(bobb, forKey: "bobbAnimation")
    }
    
    func drop(){
        let dropEmitterCell = CAEmitterCell()
        dropEmitterCell.contents = UIImage(named: "drop")?.cgImage
        dropEmitterCell.scale = 0.06
        dropEmitterCell.scaleRange = 0.3
        dropEmitterCell.emissionRange = .pi
        dropEmitterCell.lifetime = 20.0
        dropEmitterCell.birthRate = 3
        dropEmitterCell.velocity = -30
        dropEmitterCell.velocityRange = -20
        dropEmitterCell.yAcceleration = 30
        dropEmitterCell.xAcceleration = 5
        
        let dropEmitterLayer = CAEmitterLayer()
        dropEmitterLayer.emitterPosition = CGPoint(x: self.bounds.width / 2.0, y: -50)
        dropEmitterLayer.emitterSize = CGSize(width: self.bounds.width, height: 0)
        dropEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        dropEmitterLayer.beginTime = CACurrentMediaTime()
        dropEmitterLayer.timeOffset = 10
        dropEmitterLayer.emitterCells = [dropEmitterCell]
        self.layer.addSublayer(dropEmitterLayer)
    }
}
