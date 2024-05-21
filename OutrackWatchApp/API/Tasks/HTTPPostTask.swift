//
//  HTTPostTask.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

class HTTPPostTask: HTTPTask, DefaultHTTPPostTask {
    func post<E: Encodable, D: Decodable>(url: String,
                                          dto: E,
                                          decodeType: D.Type,
                                          accessToken: String? = nil,
                                          headers: [String: String] = ["": ""],
                                          queryParameters: [String: String] = ["": ""]) async {
        do {
            state = .busy
            let urlRequest = try requestGenerator.generateRequest(url: url,
                                                                  method: .POST,
                                                                  body: dto,
                                                                  accessToken: accessToken,
                                                                  headers: headers,
                                                                  queryParameters: queryParameters)
            let response = try await apiCaller.call(urlRequest: urlRequest, decodeType: decodeType)
            didSuccess(response: response)
        } catch {
            didFail(error: error)
        }
    }

    func post<E: Encodable>(url: String,
                            dto: E,
                            accessToken: String? = nil,
                            headers: [String: String] = ["": ""],
                            queryParameters: [String: String] = ["": ""]) async {
        do {
            state = .busy
            let urlRequest = try requestGenerator.generateRequest(url: url,
                                                                  method: .POST,
                                                                  body: dto,
                                                                  accessToken: accessToken,
                                                                  headers: headers,
                                                                  queryParameters: queryParameters)
            try await apiCaller.call(urlRequest: urlRequest)
            didSuccess()
        } catch {
            didFail(error: error)
        }
    }
}
