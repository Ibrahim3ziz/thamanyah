//
//  DateFormatters.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import Foundation

enum Formatters {
    static let briefHM: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated      // e.g. "1h 5m"
        f.maximumUnitCount = 2          // limit to hours + minutes
        return f
    }()
}
