//
//  HKStatistics+Extension.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 01/09/2023.
//

import Foundation
import HealthKit

protocol HKStatisticsProtocol: AnyObject {
    var type: HKQuantityType { get }
    func mostRecentHearthRate() -> Double
    func sumActiveEnergyBurned() -> Double
    func sumDistance() -> Double
    func averageRunningSpeed() -> Double
}

extension HKStatistics: HKStatisticsProtocol {
    var type: HKQuantityType {
        return quantityType
    }

    func mostRecentHearthRate() -> Double {
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let hearthRate = self.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
        let formattedHearthRate = hearthRate.formatted(.number.precision(.fractionLength(0)))
        return Double(formattedHearthRate.replaceCommaByPoint()) ?? 0
    }

    func averageHearthRate() -> Double {
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let hearthRate = self.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
        let formattedHearthRate = hearthRate.formatted(.number.precision(.fractionLength(0)))
        return Double(formattedHearthRate.replaceCommaByPoint()) ?? 0
    }

    func sumActiveEnergyBurned() -> Double {
        let energyUnit = HKUnit.kilocalorie()
        let energyBurned = self.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
        let formattedEnergyBurned = energyBurned.formatted(.number.precision(.fractionLength(0)))
        return Double(formattedEnergyBurned.replaceCommaByPoint()) ?? 0
    }

    func sumDistance() -> Double {
        let distanceUnit = HKUnit.meter()
        let kilometers = (self.sumQuantity()?.doubleValue(for: distanceUnit) ?? 0) / 1000
        let formattedDistance = kilometers.formatted(.number.precision(.fractionLength(2)))
        return Double(formattedDistance.replaceCommaByPoint()) ?? 0
    }

    func averageRunningSpeed() -> Double {
        let speedUnit = HKUnit.meter().unitDivided(by: .second())
        let speedInMetersPerSecond = self.averageQuantity()?.doubleValue(for: speedUnit) ?? 0
        let speedInKilometersPerHour = speedInMetersPerSecond * 3.6
        let formattedSpeed = speedInKilometersPerHour.formatted(.number.precision(.fractionLength(1)))
        return Double(formattedSpeed.replaceCommaByPoint()) ?? 0
    }
}
