//
//  Coordinator.swift
//  Buoy
//
//  Created by Animesh Mohanty on 26/08/24.
//

import Foundation


enum StepCountServiceError: Error {
    case fileNotFound
    case dataParsingError
    case healthKitError
    case unknownError
}


class StepCountServiceFactory {
    static func createService() -> StepCountDataService {
#if DEV
        return JSONStepCountService()
#else
        return HealthKitStepCountService()
#endif
    }
}

