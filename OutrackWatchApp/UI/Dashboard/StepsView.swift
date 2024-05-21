//
//  StepsView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 29/08/2023.
//

import SwiftUI

struct StepsView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var timeRemaining: Int
    @Binding var stepIndex: Int
    @Binding var displayProgressView: Bool
    var training: Training

    var body: some View {
        VStack {
            SecondaryText(text: training.trainingSteps[stepIndex].localizable ?? "")

            if timeRemaining != 0 {
                PrimaryText(text: "\(TimeManager.secondsToTime(seconds: timeRemaining))")
            } else if !workoutManager.running &&
                        timeRemaining == 0 &&
                        stepIndex < training.trainingSteps.count - 1 {
                PrimaryText(text: R.string.localizable.pause.callAsFunction())
            } else if timeRemaining == 0 && stepIndex == training.trainingSteps.count - 1 {
                PrimaryText(text: R.string.localizable.end.callAsFunction())
            }

            if workoutManager.started &&
                workoutManager.running &&
                stepIndex < training.trainingSteps.count - 1 {
                Button(action: {
                    if training.trainingSteps[stepIndex].stepIdentifier == .exercise {
                        workoutManager.end(waitingCallback: {
                            workoutManager.running = false
                            displayProgressView = true
                        }, endCallback: {
                            if workoutManager.workout == nil {
                                workoutManager.builder = nil
                            }
                            workoutManager.running = true
                            displayProgressView = false
                        })
                    }
                    stepIndex += 1
                    timeRemaining = training.trainingSteps[stepIndex].duration
                    if training.trainingSteps[stepIndex].stepIdentifier == .exercise {
                        workoutManager.startWorkout()
                    }
                }, label: {
                    SecondaryText(text: R.string.localizable.next.callAsFunction())
                })
                .frame(maxWidth: 160)
                .tint(Color(R.color.orange))
                .font(.subheadline)
            }
        }
    }

    struct PrimaryText: View {
        let text: String

        var body: some View {
            Text(text)
                .font(.system(size: 24))
                .foregroundColor(Color(R.color.orange))
                .fontWeight(.semibold)
        }
    }

    struct SecondaryText: View {
        let text: String

        var body: some View {
            Text(text)
                .font(.system(size: 21))
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(timeRemaining: .constant(0),
                  stepIndex: .constant(0),
                  displayProgressView: .constant(false),
                  training: Training(id: 0, sport: "",
                                     trainingSteps: [],
                                     trainingDate: [],
                                     isFinished: false,
                                     intensity: 0))
    }
}
