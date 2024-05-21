//
//  UserDefaults+Extension.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 07/09/2023.
//

import Foundation

extension UserDefaults {
    var token: String? {
        guard let token = self.object(forKey: "token") else { return  nil }
        return token as? String
    }

    var firstLaunch: Bool? {
        guard let firstLaunch = self.value(forKey: "firstLaunch") else { return nil }
        return firstLaunch as? Bool
    }

    func setToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }

    func removeToken() {
        UserDefaults.standard.removeObject(forKey: "token")
    }

    func setFirstLaunch() {
        UserDefaults.standard.set(true, forKey: "firstLaunch")
    }
}
