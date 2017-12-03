//
//  WeatherTablevViewCell.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 11/29/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import UIKit

class WeatherTablevViewCell: UITableViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    func showCellContectWithData(forecastDict: NSDictionary) -> NSDictionary {
        let minimumMaximumTempText = maximumMinimumTemp(forecastDict: forecastDict)
        let weatherArray = forecastDict["weather"]! as! NSArray
        let weatherDescDict = weatherArray[0] as! [String: AnyObject]
        let futureDate = NSDate(timeIntervalSince1970: forecastDict["dt"] as! TimeInterval)
        
        self.weatherText?.text = futureDate.dateToString(date: futureDate)
        self.weatherDescription?.text = minimumMaximumTempText
        return weatherDescDict as NSDictionary
    }
    
    // MARK: - Utility methods
    // -----------------------
    func maximumMinimumTemp(forecastDict: AnyObject) -> String {
        let mainDict = forecastDict["main"] as! [String: AnyObject]
        let temp_min = (mainDict["temp_min"] as! Double).absoluteToCelsius()
        let temp_max = (mainDict["temp_max"] as! Double).absoluteToCelsius()
        let minimumMaximumTemp =  String(format:"%.0f/%.0f",temp_min, temp_max)
        return minimumMaximumTemp
    }
    
}
