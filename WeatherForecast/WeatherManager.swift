//
//  WeatherManager.swift
//  WeatherForecast
//
//  Created by Mac on 2/23/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import Alamofire

class WeatherManager {
    
    private var _currentWeather: CurrentWeather!
    private var _forecast: Forecast!    
    
    var currentWeather: CurrentWeather {
        get {
            return _currentWeather
        } set {
            _currentWeather = newValue
        }
    }
    var forecast: Forecast {
        get {
            return _forecast
        } set {
            _forecast = newValue
        }
    }

    var forecasts = [Forecast]()
    
    var forecastsCount: Int {        
        return !forecasts.isEmpty ? forecasts.count : 0       
    }
    
    enum ForecastDuration: Int {
        case short = 6
        case medium = 11
        case long = 16
    }
    
    func addForecast(forecast: Forecast)  {
        self.forecasts.append(forecast)
    }
    
    func removeTheFirstForecast()  {
        if !forecasts.isEmpty {
            forecasts.remove(at: 0)
        }
    }
    
    func downloadForecastData(table: UITableView, days: Int, lat: Double, long: Double, completed: @escaping ForecastDownloadComplete)  {
        //Downloading forecast weather data for TableView
        //Alamofire download
        let weatherAPI = WeatherAPI()
        if let forecastWeatherURL = URL(string: weatherAPI.FORECAST_WEATHER_URL(days, lat, long))  {
            Alamofire.request(forecastWeatherURL, method: HTTPMethod.get).responseJSON(completionHandler: {  [unowned self] (response) in
                let result = response.result
                //Whole JSON Dictionary
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    //List of days
                    if let list = dictionary[JSONForecast.list] as? [Dictionary<String, AnyObject>] {
                        
                        for object in list {
                            //From Object in the List we parse parameters of the class Forecast
                            self.forecast = Forecast(weatherDict: object)
                            self.addForecast(forecast: self.forecast)
                        }
                        //We do not need a forecast for the current date
                        self.removeTheFirstForecast()
                        DispatchQueue.main.async {
                            table.reloadData()
                        }
                    }
                }
                completed()
            })
        }
    }
    
}








