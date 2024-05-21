//
//  FakeURLSession.swift
//  OutrackWatchAppTests
//
//  Created by Valentin Mont on 06/09/2023.
//

import Foundation
@testable import OutrackWatchApp

class FakeURLSession: URLSessionProtocol {

    private let data: Data
    private let response: URLResponse

    init(expected response: URLResponse, with data: Data = Data()) {
        self.data = data
        self.response = response
    }

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return (data, response)
    }
}
