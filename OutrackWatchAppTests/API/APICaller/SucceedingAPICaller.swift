//
//  SucceedingAPICaller.swift
//  OutrackWatchAppTests
//
//  Created by Valentin Mont on 06/09/2023.
//

import Foundation
@testable import OutrackWatchApp

class SucceedingAPICaller: DefaultAPICaller {
    func call<T>(urlRequest: URLRequest, decodeType: T.Type) async throws -> T where T: Decodable {
        return MockDecodable() as! T
    }

    func call(urlRequest: URLRequest) async throws {
        return
    }
}

struct MockEncodable: Encodable {}
struct MockDecodable: Decodable {}
