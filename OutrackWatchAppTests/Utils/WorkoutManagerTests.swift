//
//  WorkoutManagerTests.swift
//  OutrackWatchAppTests
//
//  Created by Valentin Mont on 04/09/2023.
//

import XCTest
import HealthKit
@testable import OutrackWatchApp

final class WorkoutManagerTests: XCTestCase {

    func test_start_workout() {
        setupWorkoutManager(.running)
        startWorkout {
            XCTAssertTrue(self.workoutManager.started)
            XCTAssertTrue(self.workoutManager.running)
        }
    }

    func test_end_workout() {
        setupWorkoutManager(.running)
        let expectation = XCTestExpectation(description: "Workout Ended")
        startWorkout {
            self.workoutManager.end(waitingCallback: {}, endCallback: {
                expectation.fulfill()
                XCTAssertNotNil(self.workoutManager.workout)
                XCTAssertFalse(self.workoutManager.started)
                XCTAssertFalse(self.workoutManager.running)
            })
        }
        wait(for: [expectation], timeout: 5)
    }

    func test_toggle_pause() {
        setupWorkoutManager(.running)
        startWorkout {
            self.workoutManager.togglePause()
            XCTAssertFalse(self.workoutManager.running)
            self.workoutManager.togglePause()
            XCTAssertTrue(self.workoutManager.running)
        }
    }

    func test_reset() {
        setupWorkoutManager(.running)
        startWorkout {
            self.workoutManager.reset()
            XCTAssertNil(self.workoutManager.workout)
            XCTAssertNil(self.workoutManager.builder)
            XCTAssertNil(self.workoutManager.session)
            XCTAssertNil(self.workoutManager.endCallback)
            XCTAssertNil(self.workoutManager.selectedWorkoutActivity)
            XCTAssertFalse(self.workoutManager.ended)
            XCTAssertTrue(self.workoutManager.activityData == [:])
        }
    }

    func test_update_statistics() {
        setupWorkoutManager(.running)
        updateStatistics(allStatisticsExpected: [
            .heartRate: 110,
            .activeEnergyBurned: 5,
            .distanceCycling: 10,
            .distanceWalkingRunning: 10,
            .runningSpeed: 7
        ])
    }

    private var workoutManager: WorkoutManager!

    private func setupWorkoutManager(_ workoutActivityType: HKWorkoutActivityType) {
        workoutManager = WorkoutManager()
        workoutManager.selectedWorkoutActivity = workoutActivityType
    }

    private func startWorkout(callback: @escaping (() -> Void)) {
        let expectation = XCTestExpectation(description: "Workout started")
        workoutManager.startWorkout {
            expectation.fulfill()
            callback()
        }
        wait(for: [expectation], timeout: 5)
    }

    private func updateStatistics(allStatisticsExpected: [HKQuantityTypeIdentifier: Double]) {
        for statistics in allStatisticsExpected {
            let expectation = XCTestExpectation(description: "Statistics updated")
            workoutManager.updateStatistics(MockHKStatistics(type: .init(statistics.key))) {
                expectation.fulfill()
                XCTAssertEqual(self.workoutManager.activityData[statistics.key], statistics.value)
            }
            wait(for: [expectation], timeout: 5)
        }
    }
}

class MockHKStatistics: HKStatisticsProtocol {
    var type: HKQuantityType

    init(type: HKQuantityType) {
        self.type = type
    }

    func mostRecentHearthRate() -> Double {
        return 110
    }

    func sumActiveEnergyBurned() -> Double {
        return 5
    }

    func sumDistance() -> Double {
        return 10
    }

    func averageRunningSpeed() -> Double {
        return 7
    }
}
