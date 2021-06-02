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
    private let USER_COLLECTION = "users"
    
    public func saveUser(user: AccountUser, completionHandler: (_ error: Error?) -> ()) {
        do {
            try db.collection(USER_COLLECTION).document().setData(from: user)
            completionHandler(nil)
        } catch let error {
            completionHandler(error)
        }
    }
    
    public func getUser(uid: String, completionHandler: @escaping (_ user: AccountUser?, _ error: Error?) -> ()) {
        let userAccountDocumentRef = db.collection(USER_COLLECTION).whereField("uid", isEqualTo: uid)
        userAccountDocumentRef.getDocuments { documentSnapshot, error in
            if let error = error {
                completionHandler(nil, error)
            } else {
                if let documentSnapshot = documentSnapshot {
                    let userAccounts: [AccountUser] = documentSnapshot.documents.compactMap { return try? $0.data(as: AccountUser.self) }
                    completionHandler(userAccounts.first, nil)
                }
            }
        }
    }
    
    public func updateUser(user: AccountUser, completionHandler: @escaping (_ user: AccountUser?, _ error: Error?) -> ()) {
        do {
            try db.collection(USER_COLLECTION).document(user.id ?? "").setData(from: user)
            completionHandler(user, nil)
        } catch let error {
            completionHandler(nil, error)
        }
        
    }
}
