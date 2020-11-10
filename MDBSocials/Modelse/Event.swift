//
//  Event.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/6/20.
//

import Foundation
import FirebaseFirestore

protocol EventDocumentSerializable {
    init?(dictionary:[String: Any])
}

struct Event {
    var eventName: String
    var description: String
    var imageURL: String
    var userPosted: String
    var eventDate: Date
    var interested: Int
    
    var dictionary:[String: Any] {
        return [
            "eventName": eventName,
            "description": description,
            "imageURL": imageURL,
            "userPosted": userPosted,
            "eventDate": eventDate,
            "interested": interested
        ]
    }
}

extension Event: EventDocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let eventName = dictionary["eventName"] as? String,
              let description = dictionary["description"] as? String,
              let imageURL = dictionary["imageURL"] as? String,
              let userPosted = dictionary["userPosted"] as? String,
              let eventDate = dictionary["eventDate"] as? Date,
              let interested = dictionary["interested"] as? Int else {return nil}
        
        self.init(eventName: eventName, description: description, imageURL: imageURL, userPosted: userPosted, eventDate: eventDate, interested: interested)
    }
}

