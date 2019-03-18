//
//  Post.swift
//  Storify
//
//  Created by Work on 3/23/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import Foundation
import Firebase

struct PostStorageInfo {
    var full_Url: String
    var thumb_Url: String
    
    init(fullUrl : String,thumbUrl url: String) {
        self.full_Url = fullUrl
        self.thumb_Url = url
    }
}


enum Accesibilty: CustomStringConvertible{
    case publicPost
    case privatePost
    
    var description: String{
        switch self {
          case  .publicPost: return "public"
          case  .privatePost: return "private"
        }
    }
    
    init(accesibleTo: String){
        if accesibleTo == "private"{self = .privatePost}
        else{self = .publicPost}
    }
}

struct Post {
    var postId: String!
    var author: Daily3User!
    var morningImagePostInfo: PostStorageInfo?
    var eveningImagePostInfo: PostStorageInfo?
    var nightImagePostInfo: PostStorageInfo?
    var mine = false
    var timeStamp: Double!
    
    init(snapshot: DataSnapshot){
        self.postId = snapshot.key
        if let value = snapshot.value as? [String:Any]{
            if let morning = value["Morning"] as? [String:Any]{
                guard let fullUrl = morning["full_url"] as? String, let thumbUrl = morning["thumb_url"] as? String else {
                    return
                }
                self.morningImagePostInfo = PostStorageInfo(fullUrl: fullUrl, thumbUrl: thumbUrl)
        }
            if let evening = value["Evening"] as? [String:Any]{
                guard let fullUrl = evening["full_url"] as? String, let thumbUrl = evening["thumb_url"] as? String else {
                    return
                }
                self.eveningImagePostInfo = PostStorageInfo(fullUrl: fullUrl, thumbUrl: thumbUrl)
            
        }
        if let night = value["Night"] as? [String:Any]{
            guard let fullUrl = night["full_url"] as? String, let thumbUrl = night["thumb_url"] as? String else {
                return
            }
            self.nightImagePostInfo = PostStorageInfo(fullUrl: fullUrl, thumbUrl: thumbUrl)
            
        }
        let author = value["Author"] as! [String:String]
        self.author = Daily3User(dictionary: author)
        self.timeStamp = value["timestamp"] as! Double
    }
    
 }
}

