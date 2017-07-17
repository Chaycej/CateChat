//
//  File.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/15/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromID: String?
    var text: String?
    var timeStamp: NSNumber?
    var toID: String?
    
//    init(dictionary: [String: Any]) {
//        self.fromID = dictionary["fromID"] as? String
//        self.text = dictionary["text"] as? String
//        self.timeStamp = dictionary["time"] as? NSNumber
//        self.toID = dictionary["toID"] as? String
//    }
    
    func chatPartnerId() -> String? {
        if fromID == Auth.auth().currentUser?.uid {
            return toID!
        }
        return fromID!
    }
}
