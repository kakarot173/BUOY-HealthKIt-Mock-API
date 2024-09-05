//
//  StepCountVM.swift
//  Buoy
//
//  Created by Animesh Mohanty on 26/08/24.
//

import Foundation

protocol StepCountDataService {
    func fetchStepCounts(startDate: Date, endDate: Date, completion: @escaping (Result<[StepCount], StepCountServiceError>) -> Void)
}


class StepCountViewModel: ObservableObject {
    @Published var stepCounts: [StepCount] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var service: StepCountDataService
    private var cache = StepCountCache()
    
    init(service: StepCountDataService = StepCountServiceFactory.createService()) {
        self.service = service
    }
    
    private func handleError(_ error: StepCountServiceError) {
        switch error {
        case .fileNotFound:
            self.errorMessage = "The data file was not found."
        case .dataParsingError:
            self.errorMessage = "There was an error parsing the data."
        case .healthKitError:
            self.errorMessage = "There was an error accessing HealthKit data."
        case .unknownError:
            self.errorMessage = "An unknown error occurred."
        }
    }

    func fetchStepCounts(for dateRange: DateRange, completion: @escaping ([StepCount]) -> Void) {
        let (startDate, endDate) = dateRange.dates
        self.isLoading = true
        self.errorMessage = nil
        //Check cache first
        if let cachedData = cache.getCachedData(for: startDate, endDate: endDate) {
            self.stepCounts = cachedData.sorted {
                ($0.startDate ?? Date()) < ($1.startDate ?? Date())
            }
            self.isLoading = false
            completion(self.stepCounts)
            return
        }
        service.fetchStepCounts(startDate: startDate, endDate: endDate) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let stepCounts):
                    self?.stepCounts = stepCounts.sorted {
                        ($0.startDate ?? Date()) < ($1.startDate ?? Date())
                    }
                    // Cache the fetched data
                    self?.cache.cacheData(stepCounts, for: startDate, endDate: endDate)
                    self?.objectWillChange.send()
                    print("Fetched step counts: \(stepCounts)")
                case .failure(let error):
                    self?.stepCounts = []
                    self?.handleError(error)
                }
                completion(self!.stepCounts)  // Call completion after fetching data
            }
        }
    }
}

extension StepCountViewModel {
    var totalSteps: Int {
        return stepCounts.reduce(0) { $0 + $1.count }
    }
}

class StepCountCache {
    private var cache: [String: [StepCount]] = [:]
    
    func getCachedData(for startDate: Date, endDate: Date) -> [StepCount]? {
        let key = cacheKey(for: startDate, endDate: endDate)
        return cache[key]
    }
    
    func cacheData(_ data: [StepCount], for startDate: Date, endDate: Date) {
        let key = cacheKey(for: startDate, endDate: endDate)
        cache[key] = data
    }
    
    private func cacheKey(for startDate: Date, endDate: Date) -> String {
        return "\(startDate.timeIntervalSince1970)-\(endDate.timeIntervalSince1970)"
    }
}
