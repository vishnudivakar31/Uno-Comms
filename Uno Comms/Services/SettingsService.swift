//
//  SettingsService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/2/21.
//

import Foundation

protocol SettingsDelegate {
    func getUserAccountCallback(user: AccountUser?, error: Error?)
}

class SettingsService {
    
    private let authenticationService = AuthenticationService()
    private let databaseService = DatabaseService()
    
    var settingsDelegate: SettingsDelegate?
    
    public func getUserAccount() {
        if let currentUser = authenticationService.getCurrentUser() {
            databaseService.getUser(uid: currentUser.uid) { accountUser, error in
                self.settingsDelegate?.getUserAccountCallback(user: accountUser, error: error)
            }
        } else {
            settingsDelegate?.getUserAccountCallback(user: nil, error: NSError(domain: "No signed in user", code: 401, userInfo: nil))
        }
    }
}
