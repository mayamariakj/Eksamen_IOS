import UIKit
import Foundation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var weatherTable: UITableView!
    
    var weatherDataList : [WeatherInformation] = []
    let cellReuseIdentifier = "cell"
    let metRequest = MetRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metRequest.delegate = self
        
        self.weatherTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.weatherTable.delegate = self
        self.weatherTable.dataSource = self
        
        self.weatherTable.rowHeight = 100
        self.weatherTable.sectionHeaderHeight = 75
        
        self.weatherTable.register(MainMenuHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        weatherDataList.removeAll()
        metRequest.getWeatherDataFromMet(lat: myLocationLat,lon: myLocationLong)
    }
    
    func formatWeatherData(weatherData :DataClass){
        weatherDataList.append(WeatherInformation(title: "Now", informationLable: "Temperature", datafield_0: "\(weatherData.instant.details.airTemperature)°C", datafield_1: ""))
        weatherDataList.append(WeatherInformation(title: "Next Hour", informationLable: "Weather", datafield_0: "\(weatherData.next1_Hours?.details.precipitationAmount ?? 0) mm" , datafield_1: weatherData.next1_Hours?.summary.symbolCode ?? "not found"))
        weatherDataList.append(WeatherInformation(title: "Next Six hours", informationLable: "Weather", datafield_0: "\(weatherData.next6_Hours?.details.precipitationAmount ?? 0) mm" , datafield_1: weatherData.next6_Hours?.summary.symbolCode ?? "not found"))
        weatherDataList.append(WeatherInformation(title: "Next Twelve hours", informationLable: "Weather", datafield_0: "" , datafield_1: weatherData.next12_Hours?.summary.symbolCode ?? "not found"))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = self.weatherTable.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! MainMenuHeader
        view.title.text = "Weather forecast for"
        view.subtitle.text = myLocationName
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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

extension TableViewController: MetRequestDelegate {
    
    func couldNotGetWeatherData() {}
    
    func didGetWeatherData(_ response: MetWeatherObject) {
        
        let weatherData = response.properties.timeseries[0].data
        self.formatWeatherData(weatherData: weatherData)
        DispatchQueue.main.async {
            self.weatherTable.reloadData()
        }
    }
}
