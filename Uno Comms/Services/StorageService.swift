//
//  StorageService.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 5/31/21.
//

import Foundation
import Firebase

class StorageService {
    private let storage = Storage.storage()
    private let imageReference: StorageReference!
    
    init() {
        imageReference = storage.reference().child("images")
    }
    
    public func uploadImage(imageName: String, data: Data, completionHandler: @escaping (_ status: Bool, _ url: String?, _ msg: String) -> ()) {
        let profileImageRef = imageReference.child("\(imageName).png")
        profileImageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completionHandler(false, nil, error.localizedDescription)
            }
            profileImageRef.downloadURL { url, error in
                if let error = error {
                    completionHandler(false, nil, error.localizedDescription)
                } else if let url = url {
                    completionHandler(true, url.absoluteString, "upload success")
                }
            }
        }
    }
    
}
