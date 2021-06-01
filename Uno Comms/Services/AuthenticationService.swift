//
//  AuthenticationService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 5/31/21.
//

import Foundation
import Firebase

class AuthenticationService {
    
    public func createUser(withEmail: String, password: String, completionHandler: @escaping (_ status: Bool, _ msg: String) -> ()) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { authResult, error in
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else if let authResult = authResult {
                self.sendWelcomeEmail { (status, msg) in
                    if status {
                        completionHandler(status, authResult.description)
                    } else {
                        completionHandler(status, msg)
                    }
                }
            }
        }
    }
    
    public func signIn(withEmail: String, password: String, completionHandler: @escaping (_ status: Bool, _ msg: String) -> ()) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { authResult, error in
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else if let authResult = authResult {
                completionHandler(true, authResult.description)
            }
        }
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    private func sendWelcomeEmail(completionHandler: @escaping (_ status: Bool, _ msg: String) -> ()) {
        if let user = getCurrentUser() {
            user.sendEmailVerification { error in
                if let error = error {
                    completionHandler(false, error.localizedDescription)
                } else {
                    completionHandler(true, "email sent")
                }
            }
        }
    }
    
    public func sendPasswordResetEmail(email: String, completionHandler: @escaping (_ status: Bool, _ msg: String) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else {
                completionHandler(true, "password reset email send.")
            }
        }
    }
}
