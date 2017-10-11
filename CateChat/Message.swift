import UIKit
import Firebase

class Message: NSObject {
    
    var fromID: String?
    var text: String?
    var timeStamp: NSNumber?
    var toID: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.fromID = dictionary["fromID"] as? String
        self.text = dictionary["text"] as? String
        self.timeStamp = dictionary["timeStamp"] as? NSNumber
        self.toID = dictionary["toID"] as? String
    }
    
    func chatPartnerId() -> String? {
        if fromID == Auth.auth().currentUser?.uid {
            return toID!
        }
        return fromID!
    }
}
