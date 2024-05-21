//
//  APICallerErrors.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

enum APICallerErrors: Int, LocalizedError, CaseIterable {
    case badRequest = 400
    case forbidden = 403
    case unauthorized = 401
    case notFound = 404
    case alreadyRegistered = 409
    case internalServer = 500

    var errorDescription: String {
        switch self {
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .internalServer: return "Sorry an internal server error appeared"
        case .alreadyRegistered: return "The resource is already created"
        case .forbidden: return "Forbidden resource"
        case .notFound: return "Not found"
        }
    }

    static func from(code: Int) -> APICallerErrors {
        return self.init(rawValue: code) ?? .internalServer
    }
}
