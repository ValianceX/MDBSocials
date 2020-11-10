//
//  User.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/6/20.
//

import Foundation
import FirebaseFirestore

protocol UserDocumentSerializable {
    init?(dictionary:[String: Any])
}

struct User {
    var email: String
    var fullname: String
    var username: String
    
    var dictionary:[String: Any] {
        return [
            "email": email,
            "fullname": fullname,
            "username": username
        ]
    }
}

extension User: UserDocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let email = dictionary["email"] as? String,
              let fullname = dictionary["fullname"] as? String,
              let username = dictionary["username"] as? String else {return nil}
        
        self.init(email: email, fullname: fullname, username: username)
    }
}
