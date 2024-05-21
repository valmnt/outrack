//
//  ActivityResultViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 30/08/2023.
//

import Foundation
import HealthKit

class ResultViewModel: ObservableObject {

    @Published var duration: TimeInterval?
    @Published var statistics: [HKQuantityTypeIdentifier: Double] = [:]

    let postActivityService: POSTActivityService = POSTActivityService()

    var sortedKeys: [HKQuantityTypeIdentifier] {
        statistics.keys.sorted(by: { $0.rawValue < $1.rawValue })
    }

    var trainingId: Int?
    var workout: HKWorkout? {
        didSet {
            getActivityResult()
        }
    }

    func getActivityResult() {
        duration = workout?.duration
        statistics[.heartRate] = workout?.allStatistics[.init(.heartRate)]?.averageHearthRate()
        statistics[.activeEnergyBurned] = workout?.allStatistics[.init(.activeEnergyBurned)]?.sumActiveEnergyBurned()

        switch workout?.workoutActivityType {
        case .running:
            statistics[.runningSpeed] = workout?.allStatistics[.init(.runningSpeed)]?.averageRunningSpeed()
            statistics[.distanceWalkingRunning] = workout?.allStatistics[.init(.distanceWalkingRunning)]?.sumDistance()
        case .cycling:
            statistics[.distanceCycling] = workout?.allStatistics[.init(.distanceCycling)]?.sumDistance()
        default: return
        }
    }

    func postActivity() async {
        guard let duration = workout?.duration,
              let sport = workout?.workoutActivityType.APIidentifierForActivity else { return }

        let heartRate = workout?.statistics(for: .init(.heartRate))?.averageHearthRate() ?? 0
        let activeEnergyBurned = workout?.statistics(for: .init(.activeEnergyBurned))?.sumActiveEnergyBurned() ?? 0
        let distanceWalkingRunning = workout?.statistics(for: .init(.distanceWalkingRunning))?.sumDistance() ?? 0
        let distanceCycling = workout?.statistics(for: .init(.distanceCycling))?.sumDistance() ?? 0
        let runningSpeed = workout?.statistics(for: .init(.runningSpeed))?.averageRunningSpeed() ?? 0

        await postActivityService.proccess(dto: [ActivityDTO(
            sport: sport,
            healthData: HealthData(duration: duration,
                                   heartRate: heartRate,
                                   activeEnergyBurned: activeEnergyBurned,
                                   distanceWalkingRunning: workout?.workoutActivityType == .running
                                   ? distanceWalkingRunning
                                   : 0,
                                   distanceCycling: workout?.workoutActivityType == .cycling
                                   ? distanceCycling
                                   : 0,
                                   runningSpeed: workout?.workoutActivityType == .running
                                   ? runningSpeed
                                   : 0),
            trainingId: trainingId)],
           accessToken: UserDefaults.standard.token)
    }
}

private struct ActivityDTO: Encodable {
    let sport: String
    let healthData: HealthData
    let trainingId: Int?
}

private struct HealthData: Encodable {
    let duration: Double
    let heartRate: Double
    let activeEnergyBurned: Double
    let distanceWalkingRunning: Double
    let distanceCycling: Double
    let runningSpeed: Double
}
