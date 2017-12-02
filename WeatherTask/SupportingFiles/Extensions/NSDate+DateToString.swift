//
//  NSDate+DateToString.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 12/3/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import Foundation

extension NSDate
{
    func dateToString(date: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd LLLL"
        let result = formatter.string(from: date as Date)
        return result
    }
}
