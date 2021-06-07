//
//  QRService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/6/21.
//

import Foundation

class QRService {
    private let authenticationService = AuthenticationService()
    
    public func getUID() -> String? {
        if let currentUser = authenticationService.getCurrentUser() {
            return currentUser.uid
        }
        return nil
    }
}
