//
//  NewPostModel.swift
//  Storify
//
//  Created by Work on 5/1/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import Foundation
import Firebase


struct LastPostInfo: Codable {
    let lastPostID: String
    let lastPostDate: String
    let lastPostAccesibility: String
    
    init(lastPId: String, LastPDate: String, accesibility: String){
        self.lastPostDate = LastPDate
        self.lastPostID = lastPId
        self.lastPostAccesibility = accesibility
    }
    
    func encode()-> Data?{
        let encoder = JSONEncoder()
        let info = try? encoder.encode(self)
        return info
    }
    
}

class NewPost{
    
    
    public var userId: String
    public var postRef: DatabaseReference
    public var postID: String
    public  var postDate: String
    public var accessibleTo : String
    
    var morningImagePostInfo: PostInfo?
    var eveningImagePostInfo: PostInfo?
    var nightImagePostInfo: PostInfo?
    
    
    init(uid: String,ref: DatabaseReference,date: String, accessiblility: String){
        self.postID = ref.key
        self.postDate = date
        self.postRef = ref
        self.userId = uid
        self.accessibleTo = accessiblility
    }
    
    func createNewPostInDatabase(completionBlock: @escaping () -> Void){
        
        let dispatch = DispatchGroup()
      
        
        let data = ["Author": Daily3User.currentUser().author(),"Morning" : false , "Evening" : false , "Night" : false,"timestamp": ServerValue.timestamp()] as [String : Any?]
      
        
        dispatch.enter()
        postRef.setValue(data) { (error, _) in
            if error != nil{
                print("\(error!)")
                dispatch.leave()
                return
            }
            
            self.postRef.root.updateChildValues(
                ["people/\(self.userId)/posts/\(self.postID)/timeStamp": ServerValue.timestamp(),
                 "people/\(self.userId)/posts/\(self.postID)/accessibleTo": self.accessibleTo],
                withCompletionBlock: { (error, _) in
                    if error != nil{
                        print("\(error!)")
                        dispatch.leave()
                        return
                    }
                    completionBlock()
                    dispatch.leave()
            })
        }
    }
    
    func uploadToDatabase(completionBlock: @escaping (Bool)-> ()){
        
        let group = DispatchGroup()
        
        if morningImagePostInfo != nil{
            group.enter()
            morningImagePostInfo!.uploadInfoAndImageToDataBase(postRef: postRef, userId: userId, postId: postID) { (flag) in
                if flag == true{
                    group.leave()
                }
            }
        }
        if nightImagePostInfo != nil {
            group.enter()
            nightImagePostInfo!.uploadInfoAndImageToDataBase(postRef: postRef, userId: userId, postId: postID) { (flag) in
                if flag == true{
                    group.leave()
                }
                
            }
        }
        if eveningImagePostInfo != nil {
            
            group.enter()
            eveningImagePostInfo!.uploadInfoAndImageToDataBase(postRef: postRef, userId: userId, postId: postID){ (flag) in
                if flag == true{
                    group.leave()
                }
            }
            
        }
        
        group.notify(queue: .main){
            completionBlock(true)
        }
    }
}

class PostInfo  {
    var postTimeOfDay: String
    var image: UIImage
    var fullImagePath: String?
    var thumbImagePath: String?
    var fullImageMetaData: StorageMetadata?
    var thumbImageMetaData: StorageMetadata?
    var resizedImageData: Data?
    var thumbImageData: Data?
    var eveningImageView: UIImageView?
    
    init(img:UIImage, timeOfDay: String,uid:String,postId:String) {
        postTimeOfDay = timeOfDay
        self.image = img
        
        guard let resizedImage = UIImageJPEGRepresentation(image, 0.9) else {return}
        self.resizedImageData = resizedImage
        guard let thumbnailImageData = image.resizeImage(640, with: 0.7) else {return}
        self.thumbImageData = thumbnailImageData
        self.fullImagePath = "\(uid)/full/\(postId)/\(timeOfDay)/jpeg"
        self.thumbImagePath = "\(uid)/thumbnail/\(postId)/\(timeOfDay)/jpeg"
    }
    
    func uploadInfoAndImageToDataBase(postRef: DatabaseReference, userId: String,postId:String, completionHandler: @escaping (Bool)->()){
        
        
        print("uploading")
        let dispatchGroup = DispatchGroup()
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let storageRef = Storage.storage().reference()
        dispatchGroup.enter()
        storageRef.child(self.fullImagePath!).putData(self.resizedImageData!, metadata: metaData) {(fullMetaData, error) in
            
            if error != nil{
                print("\(error!)")
                return
            }
          //  self.eveningImageView?.image = UIImage(data: self.resizedImageData!)
            print("IMAGE UPLOADED")
            self.fullImageMetaData = fullMetaData
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        storageRef.child(self.thumbImagePath!).putData(self.thumbImageData!, metadata: metaData) { (thumbData, error) in
            if error != nil{
                print("\(error!)")
                return
            }
            self.thumbImageMetaData = thumbData
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main){
            let fullUrl = self.fullImageMetaData?.downloadURLs?[0].absoluteString
            let fullStorageUri = storageRef.child((self.fullImageMetaData?.path)!).description
            let thumbUrl = self.thumbImageMetaData?.downloadURLs?[0].absoluteString
            let thumbStorageUri = storageRef.child((self.thumbImageMetaData?.path)!).description
            let data = ["full_url": fullUrl ?? "" , "full_storage_uri": fullStorageUri, "thumb_url": thumbUrl ?? "", "thumb_storage_uri": thumbStorageUri] as [String:Any]
            postRef.child(self.postTimeOfDay).updateChildValues(data, withCompletionBlock: { (err, _) in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                completionHandler(true)
                
                
            })
            
        }
    }
}

