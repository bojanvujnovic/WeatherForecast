//
//  Constants.swift
//  WeatherForecast
//
//  Created by Mac on 2/22/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import Foundation

typealias DownloadComplete = () -> ()

struct WeatherAPI {
    private static let baseURL = "http://api.openweathermap.org/data/2.5"
    private static let weather = "/weather?"
    private static let forecast = "/forecast/daily?"
    private static let CNT = "&cnt="
    static let days = 11
    static let LAT = "lat="
    static let LON = "&lon="
    private static let APP_ID = "&appid="
    private static let API_Key = "b49d4b3427348cb2d8185b52bccd81b3"
    let CURRENT_WEATHER_URL: (Double, Double) -> (String)  =  { (latitude, longitude) in
        return "\(baseURL)\(weather)\(LAT)\(latitude)\(LON)\(longitude)\(APP_ID)\(API_Key)" }
    
    let FORECAST_WEATHER_URL: (Int,Double, Double) -> (String) = { (days, latitude, longitude ) in
        return "\(baseURL)\(forecast)\(LAT)\(latitude)\(LON)\(longitude)\(CNT)\(days)\(APP_ID)\(API_Key)" }
    
}


struct JSONCurrent {
    static let coordinate = "coord"
    static let weather = "weather"
    static let base = "base"
    
    static let main = "main"
       static let currentTemp = "temp"
       static let highTemp = "temp_max"
       static let lowTemp = "temp_min"
    
    static let wind = "wind"
    static let rain = "rain"
    static let clouds = "clouds"
    static let cityName = "name"
    
}

struct JSONForecast {
    static let list = "list"
       static let temp = "temp"
          static let min = "min"
          static let max = "max"
       static let city = "city"
       static let cnt = 11
       static let weather = "weather"
       static let main = "main"
       static let date = "dt"
    
    
    
}




