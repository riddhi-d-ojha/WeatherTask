//
//  WeatherTaskTests.swift
//  WeatherTaskTests
//
//  Created by Riddhi Ojha on 11/28/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherTask

class WeatherTaskTests: XCTestCase,
                        WeatherDetailsDelegate,
                        WeatherLocationDelegate{
    var locationTest:FetchWeatherLocation?=nil
    var weatherTest:WeatherDetails?=nil
    
    override func setUp() {
        super.setUp()
        locationTest = FetchWeatherLocation(delegate: self)
        weatherTest = WeatherDetails(delegate: self)
        locationTest?.getLocation()
        weatherTest?.fetchWeatherInfo(city: "Dubai")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func didGetWeather(weather: WeatherData) {
        print("SUCCESS")
        
    }
    
    func didNotGetWeather(error: NSError) {
        
    }
    
    func didFetchLocation(location: CLLocation) {
        print("SUCCESS")
    }
    
    func unableToFetchLocation() {
        
    }
    
    func showAlertForOpenSettings(alert: UIAlertController) {
        
    }
        
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        locationTest = nil
        weatherTest =  nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
