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


class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        currentWeather = CurrentWeather()
        forecast = Forecast()
        currentWeather.downloadWeatherDetails {
            //Setup UI to load downloaded data
                self.updateMainUI()
            print("Downloaded Current Data successfully.")
        }
        self.downloadForecastData { 
            print("Downloaded Forecast Data successfully.")
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete)  {
        //Downloading forecast weather data for TableView
        //Alamofire download
        if let currentWeatherURL = URL(string: WeatherAPI.FORECAST_WEATHER_URL) {
            Alamofire.request(currentWeatherURL, method: HTTPMethod.get).responseJSON(completionHandler: {  (response) in
                let result = response.result
                //Whole JSON Dictionary
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    //List of days
                    if let list = dictionary[JSONForecast.list] as? [Dictionary<String, AnyObject>] {
                        for objects in list {
                            let forecast = Forecast(weatherDict: objects)
                            self.forecasts.append(forecast)
                        }
                    }
                }
                completed()
            })
        }
    }
   
    
    //TableView data source and delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func updateMainUI()  {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp) °C"
        currentWeatherLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }

}

