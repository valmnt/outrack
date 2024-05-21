//
//  ServiceProtocol.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

protocol ServiceProtocol {
    var queryParameters: [String: String] { get set }
    var headers: [String: String] { get set }
}

protocol HTTPGetService: ServiceProtocol {
    var task: HTTPGetTask { get set }
    func proccess(accessToken: String?) async
}

protocol HTTPPostService: ServiceProtocol {
    var task: HTTPPostTask { get set }
    func proccess<E>(dto: E, accessToken: String?) async where E: Encodable
}
