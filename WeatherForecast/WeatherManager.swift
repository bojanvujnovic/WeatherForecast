//
//  WeatherManager.swift
//  WeatherForecast
//
//  Created by Mac on 2/23/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import Foundation

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
    
}








