//
//  JsonService.swift
//  Buoy
//
//  Created by Animesh Mohanty on 26/08/24.
//

import Foundation
class JSONStepCountService: StepCountDataService {
    func fetchStepCounts(startDate: Date, endDate: Date, completion: @escaping (Result<[StepCount], StepCountServiceError>) -> Void) {
        guard let url = Bundle.main.url(forResource: "step_data", withExtension: "json") else {
            completion(.failure(.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let stepCounts = try decoder.decode([StepCount].self, from: data)
            
            let filteredStepCounts = stepCounts.filter { stepCount in
                if let start = stepCount.startDate, let end = stepCount.endDate {
                    return start >= startDate && end <= endDate
                }
                return false
            }
            
            completion(.success(filteredStepCounts))
        } catch {
            completion(.failure(.dataParsingError))
        }
    }
}
