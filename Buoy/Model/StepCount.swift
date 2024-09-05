//
//  StepCount.swift
//  Buoy
//
//  Created by Animesh Mohanty on 26/08/24.
//

import Foundation

struct StepCount: Identifiable ,Codable,Equatable{
    var id: UUID = UUID()
    var startDateString: String
    var endDateString: String
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case startDateString = "startDate", endDateString = "endDate", count
    }
    var startDate: Date? {
        return ISO8601DateFormatterHelper.shared.date(from: startDateString)
    }
    
    var endDate: Date? {
        return ISO8601DateFormatterHelper.shared.date(from: endDateString)
    }
}
