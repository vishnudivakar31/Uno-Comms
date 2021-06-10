//
//  ContactsExplorerService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/10/21.
//

import Foundation

protocol ContactsExplorerDelegate {
    func getAllSharedCommsCallback(sharedComms: [SharedComm]?, error: Error?)
}

class ContactsExplorerService {
    private let databaseService = DatabaseService()
    
    public var delegate: ContactsExplorerDelegate?
    
    public func getAllSharedComms(uid: String) {
        databaseService.getSharedComms(uid: uid) { sharedComms, error in
            self.delegate?.getAllSharedCommsCallback(sharedComms: sharedComms, error: error)
        }
    }
}
