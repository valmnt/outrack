//
//  POSTActivityService.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 07/09/2023.
//

import Foundation

class POSTActivityService: HTTPPostService {
    private let url: String = NetworkConstants.baseUrl + NetworkConstants.Activity.path

    var queryParameters: [String: String] = [:]
    var headers: [String: String] = [:]
    var task: HTTPPostTask = HTTPPostTask()

    func proccess<E>(dto: E, accessToken: String?) async where E: Encodable {
        await task.post(url: url, dto: dto, accessToken: accessToken)
    }
}
