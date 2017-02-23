//
//  WeatherCell.swift
//  WeatherForecast
//
//  Created by Mac on 2/23/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

        
    func configureCell(forecast: Forecast) {
        self.weatherImage.image = UIImage(named: forecast.weatherType)
        self.dayLabel.text = forecast.date
        self.weatherTypeLabel.text = forecast.weatherType.capitalized
        self.highTempLabel.text = forecast.highTemp + " °C"
        self.lowTempLabel.text = forecast.lowTemp + " °C"
        
    }
    
    

}
