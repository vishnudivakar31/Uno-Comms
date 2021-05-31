//
//  User.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 5/31/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID public var id: String?
    let name: String
    let uid: String
    let profilePictureURL: String
    let joinedDate: Date
}
