//
//  UIAlertController+SimpleAlert.swift
//  WeatherTask
//
//  Created by Riddhi Ojha on 12/3/17.
//  Copyright © 2017 Riddhi Ojha. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertController {
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
}
