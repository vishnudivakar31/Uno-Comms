//
//  Contact.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/7/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Contact: Identifiable, Codable {
    @DocumentID public var id: String?
    let uid: String
    var friends: [String]
}
