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


class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    var weatherManager: WeatherManager!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        segment.selectedSegmentIndex = 1
        self.weatherManager = WeatherManager()
        self.weatherManager.currentWeather = CurrentWeather()
        self.weatherManager.currentWeather.downloadWeatherDetails { [unowned self] in
             self.downloadForecastData(numberOfDays: WeatherAPI.days , completed: {
                //Setup UI to load downloaded data
                DispatchQueue.main.async { [unowned self] in
                    self.updateMainUI()                }
                print("Downloaded Forecast for \(self.weatherManager.forecastsCount) days successfully.")
             })
             print("Downloaded Current Data successfully.")
        }
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
        self.downloadForecastData(numberOfDays: numberOfDays) {
            
            print("Downloaded successfully forecast for \(self.weatherManager.forecastsCount) days.")
        }
        
    }
    
    
    func downloadForecastData( numberOfDays: Int, completed: @escaping DownloadComplete)  {
        //Downloading forecast weather data for TableView
        //Alamofire download
        let weatherAPI = WeatherAPI()
        if let forecastWeatherURL = URL(string: weatherAPI.FORECAST_WEATHER_URL(numberOfDays))  {
            Alamofire.request(forecastWeatherURL, method: HTTPMethod.get).responseJSON(completionHandler: {  [unowned self] (response) in
                let result = response.result
                //Whole JSON Dictionary
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    //List of days
                    if let list = dictionary[JSONForecast.list] as? [Dictionary<String, AnyObject>] {
                        
                        for object in list {
                            //From Object in the List we parse parameters of the class Forecast
                            self.weatherManager.forecast = Forecast(weatherDict: object)
                            self.weatherManager.addForecast(forecast: self.weatherManager.forecast)
                        }
                        //We do not need a forecast for the current date
                        self.weatherManager.removeTheFirstForecast()
                        DispatchQueue.main.async { [unowned self] in
                            self.tableView.reloadData()
                        }
                    }
                }
                completed()
            })
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

