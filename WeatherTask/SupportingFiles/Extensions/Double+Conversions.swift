//
//  Double+Conversions.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 12/3/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import Foundation
extension Double {
    
    func celsiusToFahrenheit() -> Double {
        return self * 9 / 5 + 32
    }
    
    func fahrenheitToCelsius() -> Double {
        return (self - 32) * 5 / 9
    }
    
    func absoluteToCelsius() -> Double {
        return self - 273.15
    }
    
    func absoluteToFahrenheit() -> Double {
        return (self - 273.15) * 1.8 + 32
    }
}
