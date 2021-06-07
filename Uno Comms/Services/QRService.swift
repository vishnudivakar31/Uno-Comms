//
//  QRService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/6/21.
//

import Foundation

protocol QRDelegates {
    func addContactCallback(contact: Contact?, error: Error?)
}

class QRService {
    private let authenticationService = AuthenticationService()
    private let databaseService = DatabaseService()
    
    public var qrDelegates: QRDelegates?
    
    public func getUID() -> String? {
        if let currentUser = authenticationService.getCurrentUser() {
            return currentUser.uid
        }
        return nil
    }
    
    public func addContact(uid: String) {
        if let currentUID = getUID() {
            databaseService.getContact(uid: currentUID) { contact, error in
                if let _ = error {
                    let contact = Contact(uid: currentUID, friends: [uid])
                    self.databaseService.saveContact(contact: contact) { contact, error in
                        self.qrDelegates?.addContactCallback(contact: contact, error: error)
                    }
                } else if let contact = contact {
                    var updatedContact = Contact(id: contact.id, uid: contact.uid, friends: contact.friends)
                    if updatedContact.friends.contains(uid) {
                        self.qrDelegates?.addContactCallback(contact: nil, error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Contact already present."]))
                    } else {
                        updatedContact.friends.append(uid)
                        self.databaseService.updateContact(contact: updatedContact) { contact, error in
                            self.qrDelegates?.addContactCallback(contact: contact, error: error)
                        }
                    }
                }
            }
        }
    }
}
