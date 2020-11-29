import Foundation
import UIKit
import CoreLocation

class HomePageViewController: UIPageViewController, CLLocationManagerDelegate {
    
    private var currentIndex: Int = 0
    private var locationManager: CLLocationManager!
    private var currentLocationLat: Double?
    private var currentLocationLon: Double?
    
    private var weatherData: MetWeatherObject?
    private var weekDayInformationList: [HomeViewController] = []
    
    let metRequest = MetRequest()
    let offlineStorage = OfflineStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metRequest.delegate = self
        self.dataSource = self
        self.delegate = self
        
        determineCurrentLocation()
    }
    
    private func setUpPages(){
        let metDf = DateFormatter()
        let updateDf = DateFormatter()
        updateDf.dateFormat = "yyyy-MM-dd HH:mm"
        metDf.dateFormat = "yyyy-MM-dd"
        
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let calendar = Calendar.current
        var nextDate = Date()

        guard let updateDate = weatherData?.updateTime else {
            print("failed to get weatherdata")
            return
        }

        guard let guaderdWeatherData = weatherData?.properties.timeseries else {
            print("failed to get weatherdata")
            return
        }
        
        weekDayInformationList.removeAll()
        
        var singelDayWeatherData: Timesery? = guaderdWeatherData.first(where: {
            $0.time.contains(metDf.string(from: nextDate))
        })
        
        while singelDayWeatherData != nil && weekDayInformationList.count < 8 {
            
            let newDay = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            newDay.date = nextDate
            newDay.updateTimeText = updateDf.string(from: updateDate)
            
            if((singelDayWeatherData!.data.next12_Hours!.summary.symbolCode.contains("rain")) || (singelDayWeatherData!.data.next12_Hours!.summary.symbolCode.contains("sleet")) ){
                newDay.umbrella = true
            }
            else {
                newDay.umbrella = false
            }
            weekDayInformationList.append(newDay)
            
            nextDate = calendar.date(byAdding: dayComponent, to: nextDate)!
                        
            singelDayWeatherData = guaderdWeatherData.first(where: {
                $0.time == (metDf.string(from: nextDate) + "T00:00:00Z")
            })
            
        }
        
        if weekDayInformationList.count < 1 {
            let newDay = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            newDay.date = Date()
            newDay.updateTimeText = "NO DATA IN STORAGE"
            newDay.umbrella = true
            weekDayInformationList.append(newDay)
            
            let alert = UIAlertController(title: "Unable to get weather data.", message: "No offline data found. Check your internet conection.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert,animated: true)
        }
        
        setupPageController()
    }
    
    private func setupPageController() {
        
        let controller = getContentViewController(withIndex: 0)!
        self.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return weekDayInformationList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
    func getContentViewController(withIndex index: Int) -> UIViewController? {
        if index < weekDayInformationList.count{
            let contentVC = weekDayInformationList[index]
            
            contentVC.itemIndex = index
            return contentVC
        }

        return nil
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
        
        metRequest.getWeatherDataFromMet(lat: mUserLocation.coordinate.latitude ,lon: mUserLocation.coordinate.longitude)
    }
}

extension HomePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate, MetRequestDelegate {
    
    func couldNotGetWeatherData() {
        weatherData = offlineStorage.readWeatherDataFromFile()
        DispatchQueue.main.async {
            self.setUpPages()
        }
    }
    
    func didGetWeatherData(_ response: MetWeatherObject) {
        weatherData = response
        offlineStorage.writeWeatherDataToFile(weatherData: response)
        DispatchQueue.main.async {
            self.setUpPages()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.currentIndex = (pendingViewControllers.first as! HomeViewController).itemIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let contentVC = viewController as! HomeViewController

        if contentVC.itemIndex > 0 {
            return getContentViewController(withIndex: contentVC.itemIndex - 1)
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! HomeViewController
        if contentVC.itemIndex + 1 < weekDayInformationList.count {
            return getContentViewController(withIndex: contentVC.itemIndex + 1)
        }

        return nil
    }
}
