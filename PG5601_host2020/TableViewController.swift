//
//  ViewController.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 01/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var weatherTable: UITableView!
    
    var weatherDataList : [WeatherInformation] = []
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.weatherTable.delegate = self
        self.weatherTable.dataSource = self
        
        self.weatherTable.rowHeight = 100
        self.weatherTable.sectionHeaderHeight = 75
        self.weatherTable.sectionFooterHeight = 75
        
        self.weatherTable.register(MainMenuHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")

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
    
    func tableView(_ tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView? {
        let view = self.weatherTable.dequeueReusableHeaderFooterView(withIdentifier:
                   "sectionHeader") as! MainMenuHeader
       view.title.text = "Weather forecast for HK"

       return view
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection
                                section: Int) -> String? {
       return "Footer \(section)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherInformationCell", for: indexPath) as! WeatherInfromationCell
        
        let weatherInformation = weatherDataList[indexPath.row]
        cell.titleLabel.text = weatherInformation.title
        cell.InformationLabel.text = weatherInformation.informationLable
        cell.dataLabel_0.text = weatherInformation.datafield_0
        cell.dataLabel_1.text = weatherInformation.datafield_1
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}




