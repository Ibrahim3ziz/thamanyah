//
//  ISO8601DateParser.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import Foundation

// MARK: - ISO8601 Date Parser
enum ISO8601DateParser {
    private static let iso8601WithFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    static func parse(_ dateString: String?) -> Date? {
        guard let dateString, !dateString.isEmpty else { return nil }
        return iso8601WithFractional.date(from: dateString)
        ?? iso8601.date(from: dateString)
    }
}
