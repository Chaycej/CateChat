import Foundation

class Account: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageURL: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageURL = dictionary["profileImageURL"] as? String
    }
}
