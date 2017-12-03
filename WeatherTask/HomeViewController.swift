//
//  ViewController.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 11/28/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import UIKit
import CoreLocation
class HomeViewController:   UIViewController,
                        WeatherDetailsDelegate,
                        WeatherLocationDelegate,
                        CLLocationManagerDelegate,
                        UITableViewDelegate,
                        UITableViewDataSource
{
    fileprivate let downloadQueue = DispatchQueue(label: "ru.codeispoetry.downloadQueue", qos: DispatchQoS.background)
    fileprivate var cache = NSCache<NSURL, UIImage>()
    
    fileprivate let cellIdentifier = "Cell"
    var locationManager:FetchWeatherLocation?=nil
    var weather: WeatherDetails!
    var forecastListArray : NSMutableArray = []
    @IBOutlet weak var weatherBackgroundImageGif: UIImageView!
    @IBOutlet weak var weatherForecastTableView: UITableView!
    @IBOutlet weak var centreWeatherDisplay: MainContentView!
    
    override func viewDidLoad() {
        locationManager = FetchWeatherLocation(delegate: self)
        super.viewDidLoad()
        weather = WeatherDetails(delegate: self)
        self.weatherForecastTableView.dataSource = self
        self.weatherForecastTableView.delegate = self
        setBackGroundImage()
        locationManager?.getLocation()
    }	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - WeatherDetailsDelegate methods
    func didGetWeather(weather: WeatherData) {
        self.centreWeatherDisplay.updateUIForLocation(weather: weather)
        self.forecastListArray = weather.forecastArray
        self.weatherForecastTableView .reloadData()
    }
    
    func didNotGetWeather(error: NSError) {
        
    }
    
    // MARK: - WeatherLocationDelegate methods
    func didFetchLocation(location: CLLocation) {
        weather.getWeatherByCoordinates(latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude)
    }
    
    func unableToFetchLocation() {
        let alert = UIAlertController()
        alert.showSimpleAlert(title: "Can't determine your location",
                              message: "The GPS and other location services aren't responding.")
    }
    
    func showAlertForOpenSettings(alert: UIAlertController)
    {
        present(alert, animated: true, completion: nil)
    }
    // MARK: - TableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.forecastListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherTablevViewCell
        let forecastDict = self.forecastListArray[indexPath.row] as! NSDictionary
        let weatherDescDict = cell.showCellContectWithData(forecastDict: forecastDict) 
        let weatherRequestURL = NSURL(string: "\(APPURL.Domains.imageURL)/\(weatherDescDict["icon"] as! String).png")!
        let image = cache.object(forKey: weatherRequestURL  as NSURL)
        cell.weatherIcon.image = image
        if image == nil {
            lazyLoadPhoto(weatherRequestURL as URL, completion: { (url, image) -> Void in
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            })
        }
        
        return cell
    }
    // MARK: - Utility methods
    // -----------------------
    
    fileprivate func lazyLoadPhoto(_ url: URL, completion: @escaping (_ url: URL, _ image: UIImage) -> Void) {
        downloadQueue.async(execute: { () -> Void in
            if let image = self.cache.object(forKey: url as NSURL) {
                DispatchQueue.main.async {
                    completion(url, image)
                }
                
                return
            }
            do {
                let data = try Data(contentsOf: url)
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: url as NSURL)
                        completion(url, image)
                    }
                } else {
                    print("Could not decode image")
                }
            } catch {
                print("Could not load URL: \(url): \(error)")
            }
        })
    }
    
    func setBackGroundImage() {
        let backgroundGif = UIImage.gifImageWithName("weather_BG@1x")
        weatherBackgroundImageGif .image = backgroundGif
    }    
}


