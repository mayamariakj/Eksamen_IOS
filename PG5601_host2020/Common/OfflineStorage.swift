//
//  OfflineStorage.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 29/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//https://stackoverflow.com/questions/50790702/how-do-i-make-json-data-persistent-for-offline-use-swift-4/50792836
//https://programmingwithswift.com/how-to-save-json-to-file-with-swift/

import Foundation

class OfflineStorage {
    
    let fileName = "offlineWeatheData"
    
    func writeWeatherDataToFile(weatherData: MetWeatherObject){
        
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(weatherData)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)

            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent(fileName)
                do {
                    try jsonString!.write(to: pathWithFilename, atomically: true, encoding: .utf8)
                } catch {
                    print("error in file write")
                }
            }
        }catch{
            
        }
    }
    
    func readWeatherDataFromFile() -> MetWeatherObject? {
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            do {
                let pathWithFilename = documentDirectory.appendingPathComponent(fileName)
                let jsonData = try Data(contentsOf: pathWithFilename, options: .mappedIfSafe)
                let weatherData = try JSONDecoder().decode(MetWeatherObject.self, from: jsonData)
                
                return weatherData
            } catch {
                print(error)
            }
        }
        return nil
    }
    
}
