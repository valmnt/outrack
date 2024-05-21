//
//  GETTrainingsService.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import Foundation

class GETTrainingsService: HTTPGetService {

    let url = NetworkConstants.baseUrl + NetworkConstants.Training.path

    var queryParameters: [String: String] = [:]
    var headers: [String: String] = [:]
    var task: HTTPGetTask = HTTPGetTask()

    func proccess(accessToken: String?) async {
        await task.get(url: url, decodeType: GetTrainingsResponse.self, accessToken: accessToken)
    }
}

struct GetTrainingsResponse: Decodable {
    let message: [Training]
}
