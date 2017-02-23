//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Mac on 2/21/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import Alamofire
import Dispatch
import CoreLocation


class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var weatherManager: WeatherManager!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Table Data Source
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //Location Manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        
        
        
        segment.selectedSegmentIndex = 1
        //Weather Manager
        self.weatherManager = WeatherManager()
        self.weatherManager.currentWeather = CurrentWeather()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationAuthStatus()
    }
    
    //CLLocation Authorization
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            currentLocation = locationManager.location
            Location.sharedLocation.latitude = currentLocation.coordinate.latitude
            Location.sharedLocation.longitude = currentLocation.coordinate.longitude
            
            self.weatherManager.currentWeather.downloadWeatherDetails(location: Location.sharedLocation) { [unowned self] (location) in
                self.weatherManager.downloadForecastData(table: self.tableView, days: WeatherAPI.days, location: location, completed: { [unowned self] in
                    //Setup UI to load downloaded data
                    DispatchQueue.main.async { [unowned self] in
                        self.updateMainUI()                }
                    print("Downloaded Forecast for \(self.weatherManager.forecastsCount) days successfully.")                    
                })
                print("Downloaded Current Weather data  successfully.")
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    //Do not scroll Table View down when in top upmost position.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 0)
    }
    
    //A Segment has been chosen
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        weatherManager.forecasts = []
        var numberOfDays: Int
        switch sender.selectedSegmentIndex {
        case 0: numberOfDays = WeatherManager.ForecastDuration.short.rawValue
        case 1: numberOfDays = WeatherManager.ForecastDuration.medium.rawValue
        case 2: numberOfDays = WeatherManager.ForecastDuration.long.rawValue            
          default: numberOfDays = 0
        }
        
        self.weatherManager.downloadForecastData(table: tableView, days: numberOfDays, location: Location.sharedLocation) {
             print("Downloaded successfully forecast for \(self.weatherManager.forecastsCount) days.")
        }       
    }
    
    //TableView data source and delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherManager.forecastsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let dayForecast = weatherManager.forecasts[indexPath.row]
            cell.configureCell(forecast: dayForecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    //Updates Current Weather View
    func updateMainUI()  {
        dateLabel.text = weatherManager.currentWeather.date
        currentTempLabel.text = "\(weatherManager.currentWeather.currentTemp) °C"
        currentWeatherLabel.text = weatherManager.currentWeather.weatherType
        locationLabel.text = weatherManager.currentWeather.cityName
        currentWeatherImage.image = UIImage(named: weatherManager.currentWeather.weatherType)
    }

}

