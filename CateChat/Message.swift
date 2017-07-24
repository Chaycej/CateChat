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
    
    func chatPartnerId() -> String? {
        if fromID == Auth.auth().currentUser?.uid {
            return toID!
        }
        return fromID!
    }
}
