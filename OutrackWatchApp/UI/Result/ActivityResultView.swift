//
//  ActivityResultView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 29/08/2023.
//

import SwiftUI
import HealthKit

struct ActivityResultView: View {

    @ObservedObject var viewModel: ResultViewModel = ResultViewModel()
    @Environment(\.dismiss) var dismiss
    @State var displayProgressView: Bool = false
    @State var displayError: Bool = false
    var resetCallback: (() -> Void)

    init(workout: HKWorkout?, trainingId: Int? = nil, resetCallback: @escaping (() -> Void)) {
        self.resetCallback = resetCallback
        viewModel.workout = workout
        viewModel.trainingId = trainingId
    }

    var body: some View {
        ScrollView {
            VStack {
                Text(R.string.localizable.result)
                    .foregroundColor(Color(R.color.orange))
                    .fontWeight(.semibold)
                    .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())

                Divider()

                VStack {
                    Text(viewModel.duration?.formatElapsedTime() ?? "00:00:00")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if viewModel.workout?.workoutActivityType.locationType == .outdoor {
                        Text(String(format: "%.2f km", viewModel.statistics[
                            viewModel.workout?.workoutActivityType == .running
                            ? .distanceWalkingRunning
                            : .distanceCycling
                        ] ?? 0))
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if viewModel.workout?.workoutActivityType == .running {
                            Text(String(format: "%.1f km/h", viewModel.statistics[.runningSpeed] ?? 0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    Text(String(format: "%0.0f bpm", viewModel.statistics[.heartRate] ?? 0))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(String(format: "%.0f kcal", viewModel.statistics[.activeEnergyBurned] ?? 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 25).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .leading)
                .scenePadding()

                if !displayProgressView {
                    Button(R.string.localizable.done.callAsFunction()) {
                        Task {
                            self.displayProgressView = true
                            await viewModel.postActivity()
                            if viewModel.postActivityService.task.state == .succeeded ||
                                viewModel.postActivityService.task.state == .free {
                                resetCallback()
                                dismiss()
                            } else if viewModel.postActivityService.task.state == .failed {
                                displayError = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.displayProgressView = false
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(R.color.orange)))
                }
            }
            .alert(isPresented: $displayError) {
                Alert(title: Text(R.string.localizable.error),
                      message: Text(R.string.localizable.postActivityError),
                      primaryButton: .default(Text(R.string.localizable.no)) {
                    resetCallback()
                    displayError = false
                    dismiss()
                },
                      secondaryButton: .default(Text(R.string.localizable.yes)) {
                    displayError = false
                })
            }
        }
    }
}

struct WorkoutResultView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityResultView(workout: nil, resetCallback: {})
    }
}
