//
//  CreateAccountService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 5/31/21.
//

import Foundation

protocol AccountDelegates {
    func onAccountCreation(user:AccountUser?, message: String)
}

class AccountService {
    private let authenticationService = AuthenticationService()
    private let storageService = StorageService()
    private let databaseService = DatabaseService()
    
    var accountDelegates: AccountDelegates?
    
    public func createAccount(name: String, email: String, password: String, profilePictureData: Data?) {
        authenticationService.createUser(withEmail: email, password: password) { status, message in
            if let currentUser = self.authenticationService.getCurrentUser() {
                let uid = currentUser.uid
                self.storageService.uploadImage(imageName: uid, data: profilePictureData!) { status, url, message in
                    if let url = url {
                        let user = AccountUser(name: name, uid: uid, profilePictureURL: url, joinedDate: Date())
                        self.databaseService.saveUser(user: user) { error in
                            if let error = error {
                                self.accountDelegates?.onAccountCreation(user: nil, message: error.localizedDescription)
                            } else {
                                self.accountDelegates?.onAccountCreation(user: user, message: "account created successfully")
                            }
                        }
                    } else {
                        self.accountDelegates?.onAccountCreation(user: nil, message: message)
                    }
                }
            } else {
                self.accountDelegates?.onAccountCreation(user: nil, message: message)
            }
        }
    }
}
