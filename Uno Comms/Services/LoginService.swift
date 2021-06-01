//
//  LoginService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/1/21.
//

import Foundation

protocol LoginDelegate {
    func loginAttemptCallback(status: Bool, msg: String)
    func resetPasswordCallback(status: Bool, msg: String)
}

class LoginService {
    private let authenticationService = AuthenticationService()
    
    var loginDelegate: LoginDelegate?
    
    public func loginWith(email: String, password: String) {
        authenticationService.signIn(withEmail: email, password: password) { status, msg in
            self.loginDelegate?.loginAttemptCallback(status: status, msg: msg)
        }
    }
    
    public func resetPassword(email: String) {
        authenticationService.sendPasswordResetEmail(email: email) { status, msg in
            self.loginDelegate?.resetPasswordCallback(status: status, msg: msg)
        }
    }
}
