//
//  WeatherData.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 11/28/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import Foundation

struct WeatherData {
    
    let dateAndTime: NSDate
    let dateString : String
    
    let city: String
    let country: String
    
    let weatherID: Int
    let mainWeather: String
    let weatherDescription: String
    let weatherIconID: String
    var forecastArray: NSMutableArray = []
    var hourlyForecastArray: NSMutableArray = []

    private let temp: Double
    var tempCelsius: Double {
        get {
            return temp.absoluteToCelsius()
        }
    }
    var tempFahrenheit: Double {
        get {
            return temp.absoluteToFahrenheit()
        }
    }
    let humidity: Int
    let pressure: NSNumber
    let cloudCover: Int
    let windSpeed: Double

    let windDirection: Double?
    let rainfallInLast3Hours: Double?

    
    init(weatherData: [String: AnyObject]) {
        //City dict to fetch - city name
        let cityDict = weatherData["city"] as! [String: AnyObject]
        city = cityDict["name"] as! String
        country = cityDict["country"] as! String

        //showing initial today data
        let todayWeatherData = weatherData["list"]![0] as! [String: AnyObject]
        let weatherDict = todayWeatherData["weather"]![0] as! [String: AnyObject]
        dateAndTime = NSDate(timeIntervalSince1970: todayWeatherData["dt"] as! TimeInterval)
        dateString = dateAndTime.dateToString(date: dateAndTime)
        
        weatherID = weatherDict["id"] as! Int
        mainWeather = weatherDict["main"] as! String
        weatherDescription = weatherDict["description"] as! String
        weatherIconID = weatherDict["icon"] as! String
        
        let weatherArray = weatherData["list"]! as! NSArray
        
        //looping through all the json objects in the response forecast array
        for i in 1 ..< weatherArray.count{
            let weeklyForecastData = weatherData["list"]![i] as! [String: AnyObject]
            let dateText = weeklyForecastData["dt_txt"] as! String
            let currentDateText = todayWeatherData["dt_txt"] as! String
            if(String(dateText.prefix(10)) == String(currentDateText.prefix(10)))//it is forecast for today
            {
                hourlyForecastArray.add(weeklyForecastData)
            }
            else
            {
                var addValue = false
                for j in 0 ..< forecastArray.count{
                    let compareForcastData = forecastArray[j] as! [String: AnyObject]
                    let dateTextCompareForRedundancy = compareForcastData["dt_txt"] as! String
                    if(String(dateTextCompareForRedundancy.prefix(10)) == String(dateText.prefix(10)))//it is a redundant forecast for same day
                    {
                        addValue = true
                    }
                }
                
                if (forecastArray == [] || addValue == false) {
                    forecastArray.add(weeklyForecastData)
                }
            }
        }
        
        let mainDict = todayWeatherData["main"] as! [String: AnyObject]
        temp = mainDict["temp"] as! Double
        humidity = mainDict["humidity"] as! Int
        pressure = mainDict["pressure"] as! NSNumber
        
        cloudCover = todayWeatherData["clouds"]!["all"] as! Int
        
        let windDict = todayWeatherData["wind"] as! [String: AnyObject]
        windSpeed = windDict["speed"] as! Double
        windDirection = windDict["deg"] as? Double
        
        if todayWeatherData["rain"] != nil {
            let rainDict = todayWeatherData["rain"] as! [String: AnyObject]
            rainfallInLast3Hours = rainDict["3h"] as? Double
        }
        else {
            rainfallInLast3Hours = nil
        }
    }
}
