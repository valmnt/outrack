//
//  HTTPProtocol.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

protocol DefaultHTTPTask {
    func didSuccess<T: Decodable>(response: T)
    func didFail(error: Error)
}

protocol DefaultHTTPGetTask {
    func get<T: Decodable>(url: String,
                           decodeType: T.Type,
                           accessToken: String?,
                           headers: [String: String],
                           queryParameters: [String: String]) async
}

protocol DefaultHTTPPostTask {
    // swiftlint:disable:next function_parameter_count
    func post<E: Encodable, D: Decodable>(url: String,
                                          dto: E,
                                          decodeType: D.Type,
                                          accessToken: String?,
                                          headers: [String: String],
                                          queryParameters: [String: String]) async
}
