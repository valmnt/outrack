//
//  ControlsView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 29/08/2023.
//

import SwiftUI
import Combine

struct ControlsView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    @Binding var cancellable: AnyCancellable?
    @Binding var runtimeSession: WKExtendedRuntimeSession?
    @Binding var displayProgressView: Bool
    @Binding var trainingEnded: Bool
    var trainingId: Int?

    var body: some View {
        if workoutManager.started {
            HStack {
                VStack {
                    Button {
                        if trainingId != nil {
                            stopTraining()
                        } else {
                            stopWhileIsRunning()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.red)
                    .font(.title2)
                    .frame(maxWidth: trainingEnded ? 120 : .none)
                    Text(R.string.localizable.end)
                }
                if !trainingEnded {
                    PauseButton()
                }
            }
        } else {
           StartButton(trainingId: trainingId)
        }
    }

    struct PauseButton: View {

        @EnvironmentObject var workoutManager: WorkoutManager

        var body: some View {
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    Image(systemName: workoutManager.running ? "pause" : "play")
                }
                .tint(.yellow)
                .font(.title2)
                Text(workoutManager.running ? R.string.localizable.pause : R.string.localizable.resume)
            }
        }
    }

    struct StartButton: View {

        @EnvironmentObject var workoutManager: WorkoutManager
        var trainingId: Int?

        var body: some View {
            VStack {
                Button {
                    if let trainingId = trainingId {
                        startTraining(id: trainingId)
                    } else {
                        workoutManager.startWorkout()
                    }
                } label: {
                    Image(systemName: "play")
                }
                .font(.title2)
                .frame(maxWidth: 120)
                .tint(Color(R.color.orange))
                Text(R.string.localizable.start)
            }
        }

        private func startTraining(id: Int) {
            workoutManager.trainingId = id
            workoutManager.started = true
            workoutManager.running = true
        }
    }

    private func stopTraining() {
        cancellable?.cancel()
        if workoutManager.session?.state == .running {
            stopWhileIsRunning()
        } else if workoutManager.session?.state == .ended {
            stopWhileIsEnded()
        } else {
            stopWhileIsNotStarted()
        }
    }

    private func stopWhileIsRunning() {
        workoutManager.end(waitingCallback: {
            displayProgressView = true
        }, endCallback: {
            dismiss()
            end()
        })
    }

    private func stopWhileIsEnded() {
        dismiss()
        end()
    }

    private func stopWhileIsNotStarted() {
        dismiss()
        end()
    }

    private func end() {
        runtimeSession?.invalidate()
        if workoutManager.workout != nil {
            workoutManager.ended = true
        } else {
            workoutManager.reset()
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(cancellable: .constant(nil),
                     runtimeSession: .constant(nil),
                     displayProgressView: .constant(true),
                     trainingEnded: .constant(false),
                     trainingId: 0)
    }
}
