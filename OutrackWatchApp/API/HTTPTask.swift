//
//  HTTPTask.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

class HTTPTask: DefaultHTTPTask {

    var apiCaller: DefaultAPICaller = APICaller()
    var requestGenerator: RequestGenerator = RequestGenerator()

    var state: States = .free
    var response: Decodable?
    var error: Error?

    init(apiCaller: DefaultAPICaller = APICaller(), requestGenerator: RequestGenerator = RequestGenerator()) {
        self.apiCaller = apiCaller
        self.requestGenerator = requestGenerator
    }

    func didSuccess<T: Decodable>(response: T) {
        state = .succeeded
        self.response = response
    }

    func didSuccess() {
        state = .succeeded
    }

    func didFail(error: Error) {
        state = .failed
        self.error = error
    }
}
