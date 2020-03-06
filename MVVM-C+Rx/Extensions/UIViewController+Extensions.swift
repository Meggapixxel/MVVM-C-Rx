//
//  UIViewController+Extensions.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentError(_ error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func presentMessage(_ message: String) {
        let alertController = UIAlertController(
            title: "Message",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}
