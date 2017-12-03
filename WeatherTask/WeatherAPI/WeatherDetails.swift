//
//  WeatherDetails.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 11/28/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import Foundation
// MARK: WeatherDetailsDelegate
// ===========================

protocol WeatherDetailsDelegate {
    func didGetWeather(weather:WeatherData)
    func didNotGetWeather(error: NSError)
}

// MARK: WeatherDetails
// ===================
class WeatherDetails {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    private var delegate: WeatherDetailsDelegate
    // MARK: -
    init(delegate: WeatherDetailsDelegate) {
        self.delegate = delegate
    }
    func getWeatherByCoordinates(latitude: Double, longitude: Double) {
        let weatherRequestURL = NSURL(string: "\(APPURL.Domains.weatherURL)?APPID=\(APPURL.APIKEY.APIKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    func fetchWeatherInfo(city: String) {
        let weatherRequestURL = NSURL(string: "\(APPURL.Domains.weatherURL)?APPID=\(APPURL.APIKEY.APIKey)&name=\(city)")!
        getWeather(weatherRequestURL: weatherRequestURL)
    }
    
    private func getWeather(weatherRequestURL: NSURL) {
        dataTask = defaultSession.dataTask(with: weatherRequestURL as URL)  { data, response, error in
            defer { self.dataTask = nil }
            guard data != nil else{
                return
            }
            if let error = error {
                // Handle any kind of error while trying to get data from the server.
                self.delegate.didNotGetWeather(error: error as NSError)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(
                        with: data,
                        options:.allowFragments) as! [String: AnyObject]
                    let weather = WeatherData(weatherData: weatherData)
                    // Dont call delegate method on MAin UI. Call it on that call where you reciev respone. Not here. OK
                    // Notify the view controller,to display the weather to the user.
                    DispatchQueue.main.async() {
                        self.delegate.didGetWeather(weather: weather)
                    }
                }
                catch let jsonError as NSError {
                    //Handling of error while converting JSON to swift dictionary
                    self.delegate.didNotGetWeather(error: jsonError)
                }
            }
        }
        dataTask?.resume()
    }
}
