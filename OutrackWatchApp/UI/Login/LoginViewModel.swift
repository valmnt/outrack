//
//  LoginViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

class LoginViewModel: ObservableObject {

    var service: LoginService?

    func signIn(email: String, password: String) async {
        await service?.proccess(dto: LoginDTO(email: email, password: password))
        if let token = (service?.task.response as? LoginResponse)?.message.token {
            UserDefaults.standard.setToken(token)
        }
    }
}

private struct LoginDTO: Encodable {
    let email: String
    let password: String
}
