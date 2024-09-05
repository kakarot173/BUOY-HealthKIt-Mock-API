//
//  HealthKitService.swift
//  Buoy
//
//  Created by Animesh Mohanty on 26/08/24.
//

import HealthKit

class HealthKitStepCountService: StepCountDataService {
    private let healthStore = HKHealthStore()
    
    private var healthKitManager = HealthKitSetupAssistant()
    
    func fetchStepCounts(startDate: Date, endDate: Date, completion: @escaping (Result<[StepCount], StepCountServiceError>) -> Void) {
        guard healthKitManager.isAuthorized else {
            DispatchQueue.main.async { // run in main thread to avoid healthKitStore requestAuthorization timeout errors
                self.healthKitManager.requestHealthKitAuthorization { authorized in
                    if authorized {
                        //Use it for checking in simulator
    //                    self.healthKitManager.addMockStepData()
                        self.fetchStepCounts(startDate: startDate, endDate: endDate, completion: completion)
                    } else {
                        completion(.failure(.healthKitError))
                    }
                }
            }
            return
        }
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(.failure(.unknownError))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: stepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if error != nil {
                completion(.failure(.healthKitError))
                return
            }
            
            guard let results = results as? [HKQuantitySample] else {
                completion(.failure(.unknownError))
                return
            }
            
            var stepCounts: [StepCount] = []
            var seenDates = Set<String>()
            
            for sample in results {
                let startDateString = ISO8601DateFormatterHelper.shared.string(from: sample.startDate)
                let endDateString = ISO8601DateFormatterHelper.shared.string(from: sample.endDate)
                
                // Combine duplicates or filter them out based on a unique key
                let uniqueKey = "\(startDateString)-\(endDateString)"
                if !seenDates.contains(uniqueKey) {
                    seenDates.insert(uniqueKey)
                    
                    let stepCount = StepCount(
                        startDateString: startDateString,
                        endDateString: endDateString,
                        count: Int(sample.quantity.doubleValue(for: .count()))
                    )
                    
                    stepCounts.append(stepCount)
                }
            }
            
            completion(.success(stepCounts))
        }
        
        healthStore.execute(query)
    }


}
