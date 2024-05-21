//
//  FallingAPICaller.swift
//  OutrackWatchAppTests
//
//  Created by Valentin Mont on 06/09/2023.
//

import Foundation
@testable import OutrackWatchApp

class FallingAPICaller: DefaultAPICaller {
    func call<T>(urlRequest: URLRequest, decodeType: T.Type) async throws -> T where T: Decodable {
        throw APICallerErrors.internalServer
    }

    func call(urlRequest: URLRequest) async throws {
        throw APICallerErrors.internalServer
    }
}
