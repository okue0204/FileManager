//
//  Date+extention.swift
//  FileManager
//
//  Created by 奥江英隆 on 2024/05/19.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .japan
        dateFormatter.timeZone = .japan
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
