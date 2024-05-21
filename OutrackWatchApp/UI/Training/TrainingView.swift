//
//  TrainingView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import SwiftUI

struct TrainingView: View {

    @ObservedObject var viewModel: TrainingViewModel = TrainingViewModel()
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var path: NavigationPath
    @State var displayProgressView: Bool = false
    @State var displayError: Bool = false
    @State var trainings: [Training] = []

    let timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "HH:mm"
       return formatter
   }()

    var body: some View {
        VStack {
            if displayError {
                HStack {
                    Spacer()
                    Text(R.string.localizable.trainingErrorText)
                    Spacer()
                }
            } else {
                if displayProgressView {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(R.color.orange)))
                } else {
                    if trainings.isEmpty {
                        Text(R.string.localizable.emptyTraining)
                    } else {
                        List(trainings) { training in
                            Button(action: {
                                workoutManager.selectedWorkoutActivity = training.workoutActivityType
                                path.append(training)
                            }, label: {
                                HStack {
                                    Text("\(training.workoutActivityType?.name ?? "")")
                                        .foregroundColor(buttonColor(intensity: training.intensity))
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))

                                    if let todayTime = training.todayTime {
                                        Text(todayTime, formatter: timeFormatter)
                                            .fontWeight(.semibold)
                                    }
                                }
                            })
                            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                        }
                    }
                }
            }
        }
        .navigationTitle(R.string.localizable.training.callAsFunction())
        .onAppear {
            Task {
                displayProgressView = true
                trainings = await viewModel.getTrainings()
                displayProgressView = false
                if viewModel.getTrainingsService.task.state == .succeeded {
                    displayError = false
                } else if viewModel.getTrainingsService.task.state == .failed {
                    displayError = true
                }
            }
        }
    }

    func buttonColor(intensity: Int) -> Color {
        if intensity < 40 {
            return Color(R.color.green)
        } else if intensity < 80 {
            return Color(R.color.orange)
        } else {
            return Color(R.color.red)
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(path: .constant(.init()))
    }
}
