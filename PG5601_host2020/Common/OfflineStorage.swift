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
                
                try jsonString!.write(to: pathWithFilename, atomically: true, encoding: .utf8)
            }
        }catch{
            print("error in file write")
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
                print("error in file read")
            }
        }
        return nil
    }
}
