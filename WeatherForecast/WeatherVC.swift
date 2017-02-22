//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Mac on 2/21/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import Alamofire


class WeatherVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

   

}

