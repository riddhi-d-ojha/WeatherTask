//
//  MainContentView.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 11/29/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import UIKit
class MainContentView: UIView {
    @IBOutlet weak var currentWeather: UILabel!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentWeatherDescription: UILabel!
    
    func updateUIForLocation(weather: WeatherData) {
        self.currentWeather.text = String(format:"%.1f°", weather.tempCelsius)
        self.currentWeatherDescription.text = weather.mainWeather
        self.currentCity.text = weather.city
        self.currentDate.text = weather.dateString
        let weatherRequestURL = NSURL(string: "\(APPURL.Domains.imageURL)/\(weather.weatherIconID).png")!
        if let data = NSData(contentsOf: weatherRequestURL as URL) {
            self.currentWeatherIcon.image = UIImage(data: data as Data)!
        }
    }
}

