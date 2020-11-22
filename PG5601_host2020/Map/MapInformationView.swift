//
//  MapInformationCell.swift
//  PG5601_host2020
//  https://blog.usejournal.com/custom-uiview-in-swift-done-right-ddfe2c3080a
//  Created by Maya maria Kjær on 13/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//
import Foundation
import UIKit

class MapInformationView: UIView {
    
    let metRequest = MetRequest()

    lazy var latitudeText: UILabel = {
        let latitudeText = UILabel()
        latitudeText.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        latitudeText.text = "Latitude: "
        latitudeText.textAlignment = .left
        latitudeText.translatesAutoresizingMaskIntoConstraints = false
        return latitudeText
    }()
    
    lazy var latitudeData: UILabel = {
        let latitudeData = UILabel()
        latitudeData.font = UIFont.systemFont(ofSize: 18, weight: .light)
        latitudeData.textAlignment = .left
        latitudeData.translatesAutoresizingMaskIntoConstraints = false
        return latitudeData
    }()
    
    lazy var longitudeText: UILabel = {
        let longitudeText = UILabel()
        longitudeText.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        longitudeText.text = "Longitude: "
        longitudeText.textAlignment = .left
        longitudeText.translatesAutoresizingMaskIntoConstraints = false
        return longitudeText
    }()
    
    lazy var longitudeData: UILabel = {
        let longitudeData = UILabel()
        longitudeData.font = UIFont.systemFont(ofSize: 18, weight: .light)
        longitudeData.textAlignment = .left
        longitudeData.translatesAutoresizingMaskIntoConstraints = false
        return longitudeData
    }()
    
    lazy var weatherImage: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        return weatherImage
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    private func setupView(){
        
        metRequest.delegate = self

        addSubview(latitudeText)
        addSubview(latitudeData)
        addSubview(longitudeText)
        addSubview(longitudeData)
        addSubview(weatherImage)

        setupLayout()
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: 150),
            
            latitudeText.topAnchor.constraint(equalTo: topAnchor),
            latitudeText.bottomAnchor.constraint(equalTo: longitudeText.topAnchor),
            latitudeText.leadingAnchor.constraint(equalTo: leadingAnchor),
            latitudeText.trailingAnchor.constraint(equalTo: latitudeData.leadingAnchor),
            
            latitudeData.topAnchor.constraint(equalTo: topAnchor),
            latitudeData.bottomAnchor.constraint(equalTo: longitudeData.topAnchor),
            latitudeData.leadingAnchor.constraint(equalTo: latitudeText.trailingAnchor),
            
            longitudeText.topAnchor.constraint(equalTo: latitudeText.bottomAnchor),
            longitudeText.bottomAnchor.constraint(equalTo: bottomAnchor),
            longitudeText.leadingAnchor.constraint(equalTo: leadingAnchor),
            longitudeText.trailingAnchor.constraint(equalTo: longitudeData.leadingAnchor),
            
            longitudeData.topAnchor.constraint(equalTo: latitudeData.bottomAnchor),
            longitudeData.bottomAnchor.constraint(equalTo: bottomAnchor),
            longitudeData.leadingAnchor.constraint(equalTo: longitudeText.trailingAnchor),
            
            weatherImage.topAnchor.constraint(equalTo: topAnchor),
            weatherImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: self.bounds.height)
        ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
}

extension MapInformationView: MetRequestDelegate {
    func didGetWeatherData(_ response: MetWeatherObject) {
        let symbol = response.properties.timeseries[0].data.next1_Hours?.summary.symbolCode
        DispatchQueue.main.async {
            self.weatherImage.image = UIImage(named: symbol!)
        }
    }
    
    func getNewWeatherData(lat: Double, lon: Double){
        metRequest.getWeatherDataFromMet(lat: lat, lon: lon)
    }
}
