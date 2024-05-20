//
//  UIViewController.swift
//  FileManager
//
//  Created by 奥江英隆 on 2024/05/19.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        actions.forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
}
