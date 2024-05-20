//
//  UIView.swift
//  FileManager
//
//  Created by 奥江英隆 on 2024/05/20.
//

import Foundation
import UIKit
import Combine

extension UIView {
    func showToast(title: String) {
        let toastView = UIView()
        toastView.alpha = 1
        toastView.backgroundColor = .white
        toastView.layer.cornerRadius = 25
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.layer.shadowOffset = CGSize(width: 0, height: 0)
        toastView.layer.shadowColor = UIColor.black.cgColor
        toastView.layer.shadowRadius = 6
        toastView.layer.shadowOpacity = 0.2
        
        
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        toastView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: toastView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: toastView.centerYAnchor).isActive = true
        
        addSubview(toastView)
        toastView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        toastView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        toastView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 2) {
                toastView.alpha = 0
            }
        }
    }
}
