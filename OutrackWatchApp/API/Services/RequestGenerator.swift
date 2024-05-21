//
//  RequestGenerator.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

class RequestGenerator {

    private var jsonEncoder = JSONEncoder()
    private var fixHeaders: [String: String] = ["Content-Type": "application/json"]

    init() {}

    func generateRequest<T: Encodable>(url: String,
                                       method: HTTPMethods,
                                       body: T,
                                       accessToken: String?,
                                       headers: [String: String] = ["": ""],
                                       queryParameters: [String: String] = ["": ""]) throws -> URLRequest {

        guard let encodedBody = try? jsonEncoder.encode(body) else {
            throw RESTErrors.unableToDecode
        }

        var request = try generateRequest(url: url, method: method, headers: headers, queryParameters: queryParameters)
        request.httpBody = encodedBody

        if let accessToken = accessToken {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        }

        return request
    }

    func generateRequest(url: String,
                         method: HTTPMethods,
                         accessToken: String?,
                         headers: [String: String] = ["": ""],
                         queryParameters: [String: String] = ["": ""]) throws -> URLRequest {

        var request = try generateRequest(url: url, method: method, headers: headers, queryParameters: queryParameters)

        if let accessToken = accessToken {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        }

        return request
    }

    private func generateRequest(url: String,
                                 method: HTTPMethods,
                                 headers: [String: String] = ["": ""],
                                 queryParameters: [String: String] = ["": ""]) throws -> URLRequest {

        // TODO: Add queryParameters to the URL
        guard let url = URL(string: url) else {
            throw RESTErrors.unableToPerformActions
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        fixHeaders
            .merging(headers) { _, dynamic in
                return dynamic
            }.forEach {
                guard !$1.isEmpty && !$0.isEmpty else { return }
                request.addValue($1, forHTTPHeaderField: $0)
            }

        return request
    }
}
