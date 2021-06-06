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
    private let SHARED_COMMS_COLLECTION = "shared_comms"
    
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
    
    public func saveSharedComms(sharedComm: SharedComm, completionHandler: @escaping (_ sharedComm: SharedComm?, _ error: Error?) -> ()) {
        do {
            try db.collection(SHARED_COMMS_COLLECTION).document().setData(from: sharedComm)
            completionHandler(sharedComm, nil)
        } catch let error {
            completionHandler(nil, error)
        }
    }
    
    public func getSharedComms(uid: String, completionHandler: @escaping (_ sharedComms: [SharedComm]?, _ error: Error?) -> ()) {
        let sharedCommsDocRef = db.collection(SHARED_COMMS_COLLECTION).whereField("uid", isEqualTo: uid)
        sharedCommsDocRef.getDocuments { documentSnapshot, error in
            if let error = error {
                completionHandler(nil, error)
            } else if let documentSnapshot = documentSnapshot {
                let sharedComms: [SharedComm] = documentSnapshot.documents.compactMap { return try? $0.data(as: SharedComm.self)}
                completionHandler(sharedComms, nil)
            }
        }
    }
    
    public func updateSharedComm(sharedComm: SharedComm, completionHandler: @escaping (_ sharedComm: SharedComm?, _ error: Error?) -> ()) {
        do {
            try db.collection(SHARED_COMMS_COLLECTION).document(sharedComm.id ?? "").setData(from: sharedComm)
            completionHandler(sharedComm, nil)
        } catch let error {
            completionHandler(nil, error)
        }
    }
    
    public func deleteSharedComm(sharedComm: SharedComm, completionHandler: @escaping (_ sharedComm: SharedComm?, _ error: Error?) -> ()) {
        db.collection(SHARED_COMMS_COLLECTION).document(sharedComm.id ?? "").delete { error in
            if let error = error {
                completionHandler(nil, error)
            } else {
                completionHandler(sharedComm, nil)
            }
        }
    }
}
