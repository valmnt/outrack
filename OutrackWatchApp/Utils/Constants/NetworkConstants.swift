//
//  NetworkConstants.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

struct NetworkConstants {
    static var baseUrl: String {
        url + version
    }

    private static let url = "https://outtrack.kubehost.fr/api"
    private static let version = "/v1"

    struct Auth {
        private static let path = "/auth"
        static let login = path + "/signin"
    }

    struct Activity {
        static let path = "/activity"
    }

    struct Training {
        static let path = "/training/today"
    }
}
