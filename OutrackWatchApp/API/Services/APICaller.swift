//
//  APICaller.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation
import Combine

protocol DefaultAPICaller {
    func call<T: Decodable>(urlRequest: URLRequest, decodeType: T.Type) async throws -> T
    func call(urlRequest: URLRequest) async throws
}

class APICaller: DefaultAPICaller {

    private let jsonDecoder = JSONDecoder()
    private var successCodes = Set<Int>(200...299)
    private var urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }

    func call<T: Decodable>(urlRequest: URLRequest, decodeType: T.Type) async throws -> T {
        let result: (Data, URLResponse)? = try? await urlSession.data(for: urlRequest, delegate: nil)

        guard let (data, response) = result else {
             throw APICallerErrors.internalServer
        }

        do {
           let decodedResult = try jsonDecoder.decode(T.self, from: data)
           return decodedResult
       } catch {
           guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
               throw APICallerErrors.internalServer
           }
           let error = APICallerErrors.from(code: statusCode)
           NSLog("🚨 " + "[" + String(statusCode) + "] : %@", error.errorDescription)
           throw error
       }
    }

    func call(urlRequest: URLRequest) async throws {
        let result: (Data, URLResponse)? = try? await urlSession.data(for: urlRequest, delegate: nil)

        guard let (_, response) = result,
              let response = response as? HTTPURLResponse else {
            throw APICallerErrors.internalServer
        }

        if !successCodes.contains(response.statusCode) {
            let error = APICallerErrors.from(code: response.statusCode)
            NSLog("🚨 " + "[" + String(response.statusCode) + "] : %@", error.errorDescription)
            throw error
        }
    }
}
