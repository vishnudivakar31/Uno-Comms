//
//  SettingsService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/2/21.
//

import Foundation

protocol SettingsDelegate {
    func getUserAccountCallback(user: AccountUser?, error: Error?)
    func updateProfilePicture(user: AccountUser?, status: Bool, msg: String)
    func sendPasswordReset(status: Bool, msg: String)
    func deleteAccountCallback(status: Bool, msg: String)
    func logoutCallback(status: Bool, msg: String)
}

class SettingsService {
    
    private let authenticationService = AuthenticationService()
    private let storageService = StorageService()
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
    
    public func updateProfilePicture(userAccount: AccountUser, data: Data) {
        if let currentUser = authenticationService.getCurrentUser() {
            storageService.uploadImage(imageName: currentUser.uid, data: data) { status, url, message in
                if status {
                    let updatedUserAccount = AccountUser(id: userAccount.id, name: userAccount.name, uid: userAccount.uid, profilePictureURL: url ?? "", joinedDate: userAccount.joinedDate)
                    self.databaseService.updateUser(user: updatedUserAccount) { user, error in
                        if let error = error{
                            self.settingsDelegate?.updateProfilePicture(user: nil, status: false, msg: error.localizedDescription)
                        } else if let user = user {
                            self.settingsDelegate?.updateProfilePicture(user: user, status: true, msg: "")
                        }
                    }
                } else {
                    self.settingsDelegate?.updateProfilePicture(user: nil, status: false, msg: message)
                }
            }
        }
    }
    
    public func sendPasswordReset() {
        authenticationService.sendPasswordResetEmail { status, msg in
            self.settingsDelegate?.sendPasswordReset(status: status, msg: msg)
        }
    }
    
    public func disableAccount() {
        authenticationService.disableAccount { status, msg in
            self.authenticationService.logout { status1, msg1 in
                self.settingsDelegate?.deleteAccountCallback(status: status && status1, msg: "\(msg) \(msg1)")
            }
        }
    }
    
    public func logout() {
        authenticationService.logout { status, msg in
            self.settingsDelegate?.logoutCallback(status: status, msg: msg)
        }
    }
}
