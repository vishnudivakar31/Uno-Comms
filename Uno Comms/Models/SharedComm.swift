//
//  SharedComms.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/3/21.
//

import Foundation
import FirebaseFirestoreSwift

struct SharedComm: Identifiable, Codable {
    @DocumentID public var id: String?
    let uid: String
    let commType: COMMS_TYPE
    let identifier: String
    let shared: Bool
}
