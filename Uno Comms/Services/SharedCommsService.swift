//
//  SharedCommsService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/5/21.
//

import Foundation

protocol CommsDelegate {
    func saveSharedCommCallback(sharedComm: SharedComm?, error: Error?)
    func getAllSharedCommsCallback(shareComms: [SharedComm]?, error: Error?)
}

class SharedCommsService {
    
    private let authenticationService = AuthenticationService()
    private let databaseService = DatabaseService()
    
    public var commsDelegate: CommsDelegate?
    
    public func getUserID() -> String? {
        if let currentUser = authenticationService.getCurrentUser() {
            return currentUser.uid
        }
        return nil
    }
    
    public func saveSharedComm(sharedComm: SharedComm) {
        databaseService.saveSharedComms(sharedComm: sharedComm) { sharedComm, error in
            self.commsDelegate?.saveSharedCommCallback(sharedComm: sharedComm, error: error)
        }
    }
    
    public func getAllSharedComms() {
        if let currentUser = authenticationService.getCurrentUser() {
            self.databaseService.getSharedComms(uid: currentUser.uid) { sharedComms, error in
                self.commsDelegate?.getAllSharedCommsCallback(shareComms: sharedComms, error: error)
            }
        }
    }
}
