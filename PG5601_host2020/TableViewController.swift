//
//  ViewController.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 01/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController {

    
    @IBOutlet var weatherTable: UITableView!
    
    var temperatureNow : Double = 666
    var weatherDataList : [WeatherInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherTable.rowHeight = 125
        makeRequest()
    }

    func makeRequest() {
        RequestHandler().requestWeaterData(
        url: "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=59.911166&lon=10.744810",
        completed: {(response: Welcome?) in guard let weatherData = response?.properties.timeseries[0].data else {
                return;
            }
            
            self.formatWeatherData(weatherData: weatherData)
            self.weatherTable.reloadData()
            print("finished")
        })
    }
    
    func formatWeatherData(weatherData :DataClass){
        weatherDataList.append(WeatherInformation(title: "Now", informationLable: "Temperature", datafield_0: "\(weatherData.instant.details.airTemperature)°C", datafield_1: ""))
        weatherDataList.append(WeatherInformation(title: "Next Hour", informationLable: "Weather", datafield_0: "\(weatherData.next1_Hours?.details.precipitationAmount ?? 0) mm" , datafield_1: weatherData.next1_Hours?.summary.symbolCode ?? "SORRY MAC"))
        weatherDataList.append(WeatherInformation(title: "Next Six hours", informationLable: "Weather", datafield_0: "\(weatherData.next6_Hours?.details.precipitationAmount ?? 0) mm" , datafield_1: weatherData.next6_Hours?.summary.symbolCode ?? "SORRY MAC"))
        weatherDataList.append(WeatherInformation(title: "Next Twelve hours", informationLable: "Weather", datafield_0: "" , datafield_1: weatherData.next12_Hours?.summary.symbolCode ?? "SORRY MAC"))
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherInformationCell", for: indexPath) as! WeatherInfromationCell
        
        let weatherInformation = weatherDataList[indexPath.row]
        cell.titleLabel.text = weatherInformation.title
        cell.InformationLabel.text = weatherInformation.informationLable
        cell.dataLabel_0.text = weatherInformation.datafield_0
        cell.dataLabel_1.text = weatherInformation.datafield_1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}




