//
//  Location.swift
//  WeatherForecast
//
//  Created by Mac on 2/23/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import CoreLocation

class Location {
    
    static var sharedLocation = Location()
    private init() {         }
    
    var latitude: Double!
    var longitude: Double!
}
