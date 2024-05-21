//
//  SportListView.swift
//  Outrack Watch App
//
//  Created by Valentin Mont on 07/06/2023.
//

import SwiftUI
import HealthKit

struct SportListView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var path: NavigationPath

    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .crossTraining]

    var body: some View {
        List(workoutTypes) { workoutType in
            Button(workoutType.name) {
                workoutManager.selectedWorkoutActivity = workoutType
                path.append(Routes.activityView)
            }
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .listStyle(.carousel)
        .navigationBarTitle(R.string.localizable.activities.callAsFunction())
    }
}

struct SportList_Previews: PreviewProvider {
    static var previews: some View {
        SportListView(path: .constant(.init()))
    }
}
