//
//  DatabaseService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 5/31/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class DatabaseService {
    private let db = Firestore.firestore()
    
    public func saveUser(user: User, completionHandler: (_ error: Error?) -> ()) {
        do {
            try db.collection("users").document().setData(from: user)
            completionHandler(nil)
        } catch let error {
            completionHandler(error)
        }
    }
}
