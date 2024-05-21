//
//  HTTPGetTask.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

class HTTPGetTask: HTTPTask, DefaultHTTPGetTask {
    func get<T: Decodable>(url: String, decodeType: T.Type,
                           accessToken: String? = nil,
                           headers: [String: String] = ["": ""],
                           queryParameters: [String: String] = ["": ""]) async {
        do {
            state = .busy
            let urlRequest = try requestGenerator.generateRequest(url: url,
                                                                  method: .GET,
                                                                  accessToken: accessToken,
                                                                  headers: headers,
                                                                  queryParameters: queryParameters)
            let reponse = try await apiCaller.call(urlRequest: urlRequest, decodeType: decodeType)
            didSuccess(response: reponse)
        } catch {
            didFail(error: error)
        }
    }
}
