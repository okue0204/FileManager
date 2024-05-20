//
//  UIStoryboard.swift
//  FileManager
//
//  Created by 奥江英隆 on 2024/05/19.
//

import Foundation
import UIKit

extension UIStoryboard {
    static let viewControllerStoryboard = UIStoryboard(name: String(describing: ViewController.self), bundle: nil)
    
    static let saveImageStoryboard = UIStoryboard(name: String(describing: SaveImageViewController.self), bundle: nil)
}
