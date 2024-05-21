//
//  OutrackApp.swift
//  Outrack Watch App
//
//  Created by Valentin Mont on 01/06/2023.
//

import SwiftUI

@main
struct OutrackApp: App {

    @StateObject private var workoutManager = WorkoutManager()
    @State private var path = NavigationPath()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                LoginView(path: $path)
                    .environmentObject(workoutManager)
                    .navigationDestination(for: Routes.self) { route in
                        switch route {
                        case .mainView:
                            MainView(path: $path)
                                .environmentObject(workoutManager)
                        case .activityView:
                            ActivityView()
                                .environmentObject(workoutManager)
                        }
                    }
                    .navigationDestination(for: Training.self) { training in
                        ActivityView(training: training)
                            .environmentObject(workoutManager)
                    }
            }
        }
    }
}

enum Routes {
    case mainView
    case activityView
}
