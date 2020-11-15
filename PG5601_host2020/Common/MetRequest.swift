//
//  RequestHandler.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 01/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import Foundation
import Alamofire

protocol MetRequestDelegate {
    func didGetWeatherData(_ weatherData: MetWeatherObject)
}

class MetRequest {
    
    var delegate: MetRequestDelegate?
    
    func getWeatherDataFromMet(lat: Double, lon: Double){
        
        let weatherUrl : String =  "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=\(String(lat))&lon=\(String(lon))"
        
        AF.request(weatherUrl)
          .validate(statusCode: 200..<300)
          .validate(contentType: ["application/json"])
          .responseJSON(queue: DispatchQueue.init(label: "Background"))
          { response in
            guard let data = response.data else {return};
            guard let _ = response.value else {return};
            
            if let statusCode = response.error?.responseCode {
              print("Error with status code: \(statusCode)");
            }
            
            do {
                let weatherData = try JSONDecoder().decode(MetWeatherObject.self, from: data)
                self.delegate?.didGetWeatherData(weatherData)
                
            } catch let error {
              print(error)
            }
        }
    }
}
