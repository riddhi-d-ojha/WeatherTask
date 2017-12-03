//
//  FetchWeatherLocation.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 12/2/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherLocationDelegate {
    func didFetchLocation(location:CLLocation)
    func unableToFetchLocation()
    func showAlertForOpenSettings(alert: UIAlertController)
}

class FetchWeatherLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    private var delegate: WeatherLocationDelegate
    // MARK: -
    init(delegate: WeatherLocationDelegate) {
        self.delegate = delegate
    }
    // MARK: - CLLocationManagerDelegate and related methods
    func getLocation() {        
        guard CLLocationManager.locationServicesEnabled() else {
            let alert = UIAlertController()
            alert.showSimpleAlert(
                title: "Please turn on location services",
                message: "This app needs location services in order to report the weather " +
                    "for your current location.\n" +
                "Go to Settings → Privacy → Location Services and turn location services on."
            )
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                let alert = UIAlertController(
                    title: "Location services for this app are disabled",
                    message: "In order to get your current weather, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                    preferredStyle: .alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) {
                    action in
                    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(openSettingsAction)
                self.delegate.showAlertForOpenSettings(alert: alert)
                return
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        self.delegate.didFetchLocation(location: newLocation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async() {
            self.delegate.unableToFetchLocation()
        }
    }
    
    
    
}
