//
//  HomePageViewController.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 22/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
// https://medium.com/@GhostLarsen/using-a-uipageviewcontroller-in-swift-4-part-1-41ae631394d6
// https://stackoverflow.com/questions/5067785/how-do-i-add-1-day-to-an-nsdate

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metRequest.delegate = self
        self.dataSource = self
        self.delegate = self
        
        determineCurrentLocation()
        //setUpPages()

        //setupPageController()
    }
    
    private func setUpPages(){
//        check internett conection TODO:
        let metDf = DateFormatter()
        let updateDf = DateFormatter()
        updateDf.dateFormat = "yyyy-MM-dd hh:mm"
        metDf.dateFormat = "yyyy-MM-dd"
        
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let calendar = Calendar.current
        var nextDate = Date()

        guard let guaderdWeatherData = weatherData?.properties.timeseries else {
            print("failed to get weatherdata")
            return
        }
        
        weekDayInformationList.removeAll()
        
        var singelDayWeatherData: Timesery? = guaderdWeatherData[0]
        
        while singelDayWeatherData != nil {
            
            let newDay = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            newDay.date = nextDate
            newDay.updateTimeText = updateDf.string(from: nextDate)
            
            if((singelDayWeatherData!.data.next12_Hours!.summary.symbolCode.contains("rain")) || (singelDayWeatherData!.data.next12_Hours!.summary.symbolCode.contains("sleet")) ){
                newDay.umbrella = true
            }
            else {
                newDay.umbrella = false
            }
            weekDayInformationList.append(newDay)
            
            nextDate = calendar.date(byAdding: dayComponent, to: nextDate)!
            
            print("looking for: " + metDf.string(from: nextDate) + "T00:00:00Z")
            
            singelDayWeatherData = guaderdWeatherData.first(where: {
                $0.time == (metDf.string(from: nextDate) + "T00:00:00Z")
            })
            
            
            print("found: " + (singelDayWeatherData?.time ?? "nothing"))
        }
        print("finish with date")
        
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
    
    func didGetWeatherData(_ response: MetWeatherObject) {
        weatherData = response
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
