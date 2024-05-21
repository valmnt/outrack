//
//  RESTErrors.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

internal enum RESTErrors: LocalizedError {
    case unableToPerformActions
    case unableToDecode

    var errorDescription: String {
        switch self {
        case .unableToPerformActions: return "Unable to perform actions"
        case .unableToDecode: return "Unable to decode"
        }
    }
}
