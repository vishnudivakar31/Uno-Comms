//
//  ContactService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/8/21.
//

import Foundation

protocol ContactDelegates {
    func getContactCallback(contact: Contact?, error: Error?)
    func getProfileCallback(userAccounts: [AccountUser]?, error: Error?)
}

class ContactService {
    private let authenticationService = AuthenticationService()
    private let databaseService = DatabaseService()
    
    public var contactDelegates: ContactDelegates?
    
    public func getContact() {
        if let currentUser = authenticationService.getCurrentUser() {
            databaseService.getContact(uid: currentUser.uid) { contact, error in
                self.contactDelegates?.getContactCallback(contact: contact, error: error)
            }
        }
    }
    
    public func getProfiles(uids: [String]) {
        databaseService.getUsers(uids: uids) { accountUsers, error in
            self.contactDelegates?.getProfileCallback(userAccounts: accountUsers, error: error)
        }
    }
}
