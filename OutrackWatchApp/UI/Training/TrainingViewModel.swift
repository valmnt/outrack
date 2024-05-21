//
//  TrainingViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import Foundation

class TrainingViewModel: ObservableObject {

    let getTrainingsService: GETTrainingsService = GETTrainingsService()

    func getTrainings() async -> [Training] {
        await getTrainingsService.proccess(accessToken: UserDefaults.standard.token)
        let response = (getTrainingsService.task.response as? GetTrainingsResponse)?.message ?? []
        return sortTrainingsByHour(trainings: response)
    }

    func sortTrainingsByHour(trainings: [Training]) -> [Training] {
        return trainings.sorted {
            guard let first = $0.todayTime, let second = $1.todayTime else { return false }
            return first < second
        }.filter {
            !$0.isFinished
        }
    }
}
