//
//  Utilities.swift
//  Buoy
//
//  Created by Animesh Mohanty on 26/08/24.
//

import Foundation

class ISO8601DateFormatterHelper {
    static let shared = ISO8601DateFormatterHelper()
    
    private let formatter: ISO8601DateFormatter
    
    private init() {
        formatter = ISO8601DateFormatter()
        // Any custom options for the formatter can be set here
    }
    
    func date(from string: String) -> Date? {
        return formatter.date(from: string)
    }
    
    func string(from date: Date) -> String {
        return formatter.string(from: date)
    }
    
    // Expose a method to get a formatter with the correct time zone
    func configuredDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = formatter.timeZone
        return dateFormatter
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = ISO8601DateFormatterHelper.shared.configuredDateFormatter()
        formatter.dateFormat = "d MMM, h:mm a"
        print("formatted Time:\(formatter.string(from: date))")
        return formatter.string(from: date)
    }
    
}

enum DateRange: CaseIterable {
    case query1
    case query2
    case query3
    case query4
    
    var displayText: String {
        switch self {
        case .query1: return "Query 1"
        case .query2: return "Query 2"
        case .query3: return "Query 3"
        case .query4: return "Query 4"
        }
    }
    
    var dates: (Date, Date) {
        let formatter = ISO8601DateFormatterHelper.shared
        switch self {
        case .query1:
            let startDate = formatter.date(from: "2024-07-31T06:00:00Z")!
            let endDate = formatter.date(from: "2024-07-31T11:30:00Z")!
            return (startDate, endDate)
        case .query2:
            let startDate = formatter.date(from: "2024-07-30T00:00:00Z")!
            let endDate = formatter.date(from: "2024-07-31T23:59:59Z")!
            return (startDate, endDate)
        case .query3:
            let startDate = formatter.date(from: "2024-07-29T12:00:00Z")!
            let endDate = formatter.date(from: "2024-07-29T23:59:59Z")!
            return (startDate, endDate)
        case .query4:
            let startDate = formatter.date(from: "2024-07-29T16:00:00Z")!
            let endDate = formatter.date(from: "2024-07-31T11:00:00Z")!
            return (startDate, endDate)
        }
    }
}
