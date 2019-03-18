//
//  User.swift
//  Storify
//
//  Created by Work on 2/18/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import Foundation
import Firebase

class Daily3User: NSObject{
    var userID: String
    var name: String
    var profileImageDownloadUrl: String?
    
    private init(user: User) {
        self.userID = user.uid
        self.name = user.displayName!
        self.profileImageDownloadUrl = user.photoURL?.absoluteString
    }
    
    init(snapshot: DataSnapshot) {
        self.userID = snapshot.key
        let value = snapshot.value as! [String: Any]
        self.name = value["name"] as! String
        guard let profilePicUrl = value["photoUrl"] as? String else {return}
        self.profileImageDownloadUrl = profilePicUrl
    }
    
    init(dictionary : [String:String]){
        self.userID = dictionary["uid"]!
        self.name = dictionary["name"]!
        guard let profilePicUrl = dictionary["photoUrl"] else {return}
        self.profileImageDownloadUrl = profilePicUrl
    }
    
    
    static func currentUser() -> Daily3User {
        return Daily3User(user: Auth.auth().currentUser!)
    }
    
    func author() -> [String:String] {
        return ["uid": userID , "name": name, "photoUrl": profileImageDownloadUrl ?? ""]
    }
}
