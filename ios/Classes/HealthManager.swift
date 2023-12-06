//
//  FallManager.swift
//  Runner
//
//  Created by Ossa Soeun on 6/11/23.
//

import HealthKit

class HealthManager {
    private static var healthStore = HKHealthStore()

    static func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard let numOfFallen = HKObjectType.quantityType(forIdentifier: .numberOfTimesFallen) else { return }
        guard let step = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        guard let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        guard let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        guard let bodyTemperature = HKObjectType.quantityType(forIdentifier: .bodyTemperature) else { return }
        guard let calBurn = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        guard let bloodOxygen = HKObjectType.quantityType(forIdentifier: .oxygenSaturation) else { return }
        healthStore.requestAuthorization(toShare: nil, read: [numOfFallen, step, heartRate, sleep, bodyTemperature, calBurn, bloodOxygen], completion: completion)
    }

    static func readNumberOfFallen(startDate: Date, endDate: Date, completion: @escaping (String?, Error?) -> Void) {
        guard let numOfFallen = HKObjectType.quantityType(forIdentifier: .numberOfTimesFallen) else { return }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)

        let query = HKSampleQuery(sampleType: numOfFallen, predicate: predicate, limit: 10000, sortDescriptors: nil) { query, samples, error in
            do {
                if samples != nil {
                    var jsonData = ""
                    for sample in samples! {
                        let numOfFall = NumOfFall(
                            value: sample.metadata?.count ?? 0,
                            fromDate: "\(sample.startDate)",
                            toDate: "\(sample.endDate)"
                        )
                        let json = try JSONEncoder().encode(numOfFall)
                        let jsonStr = String(data: json, encoding: .utf8) ?? ""
                        if (jsonData == "") {
                            jsonData = jsonStr
                        } else {
                            jsonData = "\(jsonData),\(jsonStr)"
                        }
                    }
                    completion("[\(jsonData)]", nil)
                } else {
                    completion(nil, error)
                }
            } catch (_) {

            }
        }
        healthStore.execute(query)
    }
}

struct NumOfFall : Codable{
    let value: Int
    let fromDate: String
    let toDate: String
}

