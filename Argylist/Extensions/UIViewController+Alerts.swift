//
//  UIViewController+Alerts.swift
//  Argylist
//
//  Created by Gytis Tumas on 2021-01-16.
//

import UIKit

// UIViewController extension to show generic alert messages
extension UIViewController {
    func showAlert(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error occurred", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
