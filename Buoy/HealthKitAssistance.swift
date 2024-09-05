//
//  HealthKitAssistance.swift
//  Buoy
//
//  Created by Animesh Mohanty on 23/08/24.
//


import HealthKit

class HealthKitSetupAssistant {

    private let healthStore = HKHealthStore()
    var isAuthorized = false
    
    func requestHealthKitAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available on this device.")
            completion(false)
            return
        }
        
        guard var stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { //keeping it var for now as sometimes the authorizationStatus return undenied beause of that
            
            print("Step Count type is not available.")
            completion(false)
            return
        }
        
        healthStore.requestAuthorization(toShare: [stepType], read: [stepType]) { (success, error) in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if success {
                let status = self.healthStore.authorizationStatus(for: stepType)
                print("Authorization status for step count: \(status.rawValue)")
                if status == .sharingAuthorized {
                    self.isAuthorized = true
                    completion(true)
                } else {
                    self.isAuthorized = false
                    print("Access to step count data has been denied.")
                    completion(false)
                }
            } else {
                print("HealthKit authorization was not successful.")
                completion(false)
            }
        }
    }
    
    func addMockStepData() {
        let stepData = [
            ("2024-07-31T06:20:19Z", "2024-07-31T06:21:22Z", 8),
            ("2024-07-31T06:35:19Z", "2024-07-31T06:37:22Z", 22),
            ("2024-07-31T11:02:11Z", "2024-07-31T11:10:22Z", 19),
            ("2024-07-31T13:15:10Z", "2024-07-31T13:19:10Z", 23),
            ("2024-07-31T16:20:10Z", "2024-07-31T16:22:10Z", 56),
            ("2024-07-30T06:20:19Z", "2024-07-30T06:21:22Z", 7),
            ("2024-07-30T06:35:19Z", "2024-07-30T06:37:22Z", 10),
            ("2024-07-30T11:02:11Z", "2024-07-30T11:10:22Z", 15),
            ("2024-07-30T13:15:10Z", "2024-07-30T13:19:10Z", 29),
            ("2024-07-30T16:20:10Z", "2024-07-30T16:22:10Z", 31),
            ("2024-07-29T06:20:19Z", "2024-07-29T06:21:22Z", 3),
            ("2024-07-29T06:35:19Z", "2024-07-29T06:37:22Z", 45),
            ("2024-07-29T11:02:11Z", "2024-07-29T11:10:22Z", 6),
            ("2024-07-29T13:15:10Z", "2024-07-29T13:19:10Z", 39),
            ("2024-07-29T16:20:10Z", "2024-07-29T16:22:10Z", 12)
        ]
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        for (startDateString, endDateString, count) in stepData {
            guard let startDate = formatter.date(from: startDateString),
                  let endDate = formatter.date(from: endDateString) else {
                print("Invalid date format")
                continue
            }
            
            let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(count))
            let sample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .stepCount)!, quantity: quantity, start: startDate, end: endDate)
            
            healthStore.save(sample) { (success, error) in
                if let error = error {
                    print("Error saving step data: \(error.localizedDescription)")
                } else {
                    print("Successfully added step data to HealthKit.")
                }
            }
        }
    }
}
