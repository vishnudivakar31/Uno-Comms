//
//  COMMS_TYPE.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/3/21.
//

import Foundation
import FirebaseFirestoreSwift

enum COMMS_TYPE: String, Codable {
    case TELEPHONE = "telephone"
    case EMAIL = "email"
    case FACEBOOK = "facebook"
    case INSTAGRAM = "instagram"
    case LINKEDIN = "linkedin"
    case WHATSAPP = "whatsapp"
}
