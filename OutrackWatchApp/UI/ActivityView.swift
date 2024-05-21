//
//  ActivityView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import SwiftUI
import HealthKit
import Combine
import WatchKit

struct ActivityView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selection: Tab = .controls
    @State private var displayProgressionView: Bool = false
    @State private var stepIndex = 0
    @State private var timeRemaining: Int
    @State private var cancellable: AnyCancellable?
    @State private var trainingEnded: Bool = false
    @State private var session: WKExtendedRuntimeSession?
    private var training: Training?

    init(training: Training? = nil) {
        self.training = training
        timeRemaining = training?.trainingSteps[0].duration ?? 0
    }

    enum Tab {
        case controls, metrics, goals
    }

    var body: some View {
        if !displayProgressionView {
            TabView(selection: $selection) {
                ControlsView(
                         cancellable: $cancellable,
                         runtimeSession: $session,
                         displayProgressView: $displayProgressionView,
                         trainingEnded: $trainingEnded,
                         trainingId: training?.id).tag(Tab.controls)
                if let training = training {
                    StepsView(
                        timeRemaining: $timeRemaining,
                        stepIndex: $stepIndex,
                        displayProgressView: $displayProgressionView,
                        training: training)
                    .tag(Tab.goals)
                    .onChange(of: workoutManager.started) { started in
                        if started {
                            startTimer()
                        }
                    }
                }
                MetricsView().tag(Tab.metrics)
            }
            .navigationTitle(workoutManager.selectedWorkoutActivity?.name ?? "")
            .navigationBarBackButtonHidden(workoutManager.started)
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(R.color.orange)))
                .navigationBarBackButtonHidden()
        }
    }

    func startTimer() {
        session = WKExtendedRuntimeSession()
        session?.start()
        cancellable = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            guard let training = training, workoutManager.running else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    WKInterfaceDevice.current().play(.stop)
                }
            } else if stepIndex == training.trainingSteps.count - 1 {
                trainingEnded = true
                stopTimer()
            }
        }
    }

    func stopTimer() {
        session?.invalidate()
        session = nil
        cancellable?.cancel()
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
