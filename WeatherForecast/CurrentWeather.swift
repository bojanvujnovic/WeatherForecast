//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Mac on 2/22/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
           _cityName = ""
        }
        return _cityName
    }
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate )"
        return _date
    }
 
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
   
    //Downloads Current Weather data for coordinates
    func downloadWeatherDetails(location: Location, completed: @escaping DownloadComplete)  {
         //Alamofire download
        let weatherAPI = WeatherAPI()
        if let currentWeatherURL = URL(string: weatherAPI.CURRENT_WEATHER_URL(location)) {
            Alamofire.request(currentWeatherURL, method: HTTPMethod.get).responseJSON(completionHandler: { [unowned self] (response) in
               let result = response.result
                //Whole JSON Dictionary
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    //City Name
                    if let name = dictionary[JSONCurrent.cityName] as? String {
                        self._cityName = name.capitalized
                    }
                    //Weather Type
                    if let weather = dictionary[JSONCurrent.weather] as? [Dictionary<String, AnyObject>] {
                        if let mainWeather = weather[0][JSONCurrent.main] as? String {
                            self._weatherType = mainWeather.capitalized
                        }
                    }
                    //Temperature
                    if let temperature = dictionary[JSONCurrent.main] as? Dictionary<String, AnyObject> {
                        if let currentTemp = temperature[JSONCurrent.currentTemp] as? Double {
                            let tempInCelsius = currentTemp.convertKelvinToCelsius(kelvin: currentTemp)
                            self._currentTemp = tempInCelsius.roundTo(places: 1)
                        }
                    }
                }
                
                completed(location)
            })           
        }
    }
}

extension Double {
    
    func convertKelvinToCelsius(kelvin: Double) -> Double {
        return kelvin - 275
    }
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

