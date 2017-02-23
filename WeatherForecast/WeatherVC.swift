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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.locationManager.delegate = self
        
        segment.selectedSegmentIndex = 1
        self.weatherManager = WeatherManager()
        self.weatherManager.currentWeather = CurrentWeather()
        self.weatherManager.currentWeather.downloadWeatherDetails(latitude: 44.83, longitude: 20.41) {
            print("Downloaded Current Weather data  successfully.")
        }
        self.weatherManager.downloadForecastData(table: tableView, days: WeatherAPI.days, lat: 44.83, long: 20.41, completed: {
            //Setup UI to load downloaded data
            DispatchQueue.main.async { [unowned self] in
                self.updateMainUI()                }
            print("Downloaded Forecast for \(self.weatherManager.forecastsCount) days successfully.")
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //Do not scroll Table View down when in top upmost position.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 0)
    }
    
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        weatherManager.forecasts = []
        var numberOfDays: Int
        switch sender.selectedSegmentIndex {
        case 0: numberOfDays = WeatherManager.ForecastDuration.short.rawValue
        case 1: numberOfDays = WeatherManager.ForecastDuration.medium.rawValue
        case 2: numberOfDays = WeatherManager.ForecastDuration.long.rawValue            
          default: numberOfDays = 0
        }
        self.weatherManager.downloadForecastData(table: tableView, days: numberOfDays, lat: 44.83, long: 20.41) {
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
    
    func updateMainUI()  {
        dateLabel.text = weatherManager.currentWeather.date
        currentTempLabel.text = "\(weatherManager.currentWeather.currentTemp) °C"
        currentWeatherLabel.text = weatherManager.currentWeather.weatherType
        locationLabel.text = weatherManager.currentWeather.cityName
        currentWeatherImage.image = UIImage(named: weatherManager.currentWeather.weatherType)
    }

}

