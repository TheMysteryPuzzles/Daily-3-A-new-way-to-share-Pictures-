//
//  UserAccountViewController.swift
//  Storify
//
//  Created by Work on 5/28/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import Firebase

class UserAccountViewController: UIViewController {

    
    var profileView: UserAccountView!
    var profile: Daily3User!
    let uid = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    var postIds = [String:Any]()
    var postSnapshots = [DataSnapshot]()
    var loadingPostCount = 0
    var firebaseRefs = [DatabaseReference]()
    var headerView: AccountHeaderCell!{
        didSet{
            headerView!.accountVc = self
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = profile.name
        var yAxis = (self.navigationController?.navigationBar.frame.height)!
        
        let view = UserAccountView(frame: CGRect(x: 0, y: yAxis, width: self.view.frame.width, height: self.view.frame.height - yAxis))
        
        self.view.addSubview(view)
        
        
        
        
     //   tableView.register(AccountHeaderCell.self, forCellReuseIdentifier: "header")
    //    tableView.register(PostDisplayCell.self, forCellReuseIdentifier: "postCell")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for ref in firebaseRefs {
            ref.removeAllObservers()
        }
        firebaseRefs = [DatabaseReference]()
    }
    
    @objc func valueChanged(){
        if profile.userID == uid{
            // work to be done here of notifications
        }
        toggleFollow(headerView.followSwitch.isOn)
    }
    
    func registerToFollowStatusUpdate(){
        let followStatusRef = ref.child("people/\(uid)/following/\(profile.userID)")
        followStatusRef.observe(.value){
            self.headerView.followSwitch.isOn = $0.exists()
        }
        firebaseRefs.append(followStatusRef)
    }
    
    // UNDONE : NOTIFICATION ENABLED STATUS UPDATE
    
    func registerForFollowingCount(){
        let followingRef = ref.child("people/\(profile.userID)/following")
        followingRef.observe(.value) { (snapshot) in
            self.headerView.followingLabel.text = " \(snapshot.childrenCount)" +  self.headerView.followingLabel.text!
            self.headerView.followingLabel.accessibilityLabel = "\(snapshot.childrenCount) following"
        }
        firebaseRefs.append(followingRef)
    }
    
    func registerForFollowersCount() {
        let followersRef = ref.child("followers/\(profile.userID)")
        followersRef.observe(.value, with: {
            self.headerView.followersLabel.text = " \($0.childrenCount)" + self.headerView.followersLabel.text!
            self.headerView.followersLabel.accessibilityLabel = "\($0.childrenCount) followers"
        })
        firebaseRefs.append(followersRef)
    }
    
    func registerForPostsCount() {
        let userPostsRef = ref.child("people/\(profile.userID)/posts")
        userPostsRef.observe(.value, with: {
            self.headerView.postsLabel.text = " \($0.childrenCount)" +  self.headerView.postsLabel.text!
            self.headerView.postsLabel.accessibilityLabel = "\($0.childrenCount) posts"
        })
        firebaseRefs.append(userPostsRef)
    }
    
   /* func registerForPostDeletion(){
        let userPostRef = ref.child("people/\(profile.userID)/posts")
        userPostRef.observe(.childRemoved) { (snapshot) in
            var index = 0
            for post in self.postSnapshots{
                if post.key == snapshot.key{
                    self.postSnapshots.remove(at: index)
                    self.loadingPostCount -= 1
                    self.tableView.deleteRows(at: [IndexPath(item: index, section: 1)], with: .automatic)
                    return
                }
                index += 1
            }
            self.postIds.removeValue(forKey: snapshot.key)
        }
        firebaseRefs.append(userPostRef)
    }*/
    /*
    func loadUserPosts(){
        print(profile.userID)
        
        
        ref.child("people/\(profile.userID)/posts").observeSingleEvent(of: .value) { (postsSnapshot) in
            
            if postsSnapshot.exists() {print("Exits")}
            if var posts = postsSnapshot.value as? [String:Any]{
               
                 var index = self.postSnapshots.count - 1
                if !self.postSnapshots.isEmpty{
                    self.tableView.performBatchUpdates({
                        for post in self.postSnapshots.reversed() {
                            if posts.removeValue(forKey: post.key) == nil {
                                self.postSnapshots.remove(at: index)
                                self.tableView.deleteRows(at: [IndexPath(item: index, section: 1)], with: .automatic)
                                return
                            }
                            index -= 1
                        }
                    }, completion: nil)
                  
            }else{
                    self.postIds = posts
                    self.loadfeed()
                }
                self.registerForPostDeletion()
            }
        }
    }
    */
   /* private func loadfeed(){
     loadingPostCount += postSnapshots.count + 10
        self.tableView.performBatchUpdates({
            for _ in 1...10{
                if let post = postIds.popFirst(){
                    if let postInfo = post.value as? [String:Any]{
                        let postId = post.key
                        let accesiblity = postInfo["accessibleTo"] as! String
                        
                    
                    self.ref.child("posts/\(accesiblity)").child(postId).observeSingleEvent(of: .value) { (postSnapshot) in
                        if postSnapshot.exists() {print("EXISTS")}
                        self.postSnapshots.append(postSnapshot)
                        self.tableView.insertRows(at: [IndexPath(item: self.postSnapshots.count - 1, section: 1)], with: .automatic)
                        }
                    }
                }else{
                    break
                }
            }
        }, completion: nil)
      
        
    }
    */
    
    
 
    private func loadData(){
        registerToFollowStatusUpdate()
        registerForFollowersCount()
        registerForFollowingCount()
        registerForPostsCount()
        //loadUserPosts()
    }
    
    func toggleFollow(_ follow: Bool){
        let feedViewController = self.navigationController?.viewControllers[0] as? FeedViewController
       feedViewController?.followChanged = true
        let myFeed = "feed/\(uid)/"
        ref.child("people/\(profile.userID)/posts").observeSingleEvent(of: .value) { (snapshot) in
            var lastPostID: Any = true
            var updateData = [String:Any]()
            if let posts = snapshot.value as? [String:Any]{
                // ADD/REMOVE followed user's posts to the home feed
                for post in posts {
                    if let postInfo = post.value as? [String:Any]{
                    updateData[myFeed + post.key] = follow ? postInfo["accessibleTo"] : NSNull()
                        lastPostID = post.key
                    }
                }
                
                //ADD/REMOVE followed user to the following list
                updateData["people/\(self.uid)/following/\(self.profile.userID)"] = follow ? lastPostID : NSNull()
                
                // ADD/REMOVE signed-in user to the list of followers
                updateData["followers/\(self.profile.userID)/\(self.uid)"] = follow ? true : NSNull()
                
                self.ref.updateChildValues(updateData, withCompletionBlock: { (error, _) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                })
                
            }
            
        }
    }
    
   
  
    // MARK -> TABLEVIEW STUFF

/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        print("count:\(postSnapshots.count)")
        return postSnapshots.count
    }*/
    
  /*  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let header = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! AccountHeaderCell
           // header.view
            headerView = header
           
            guard let url = profile.profileImageDownloadUrl else {
                return header
            }
            header.profileImageView.loadImageUsingCache(withUrl: url)
             return header
            
        }else{
          /*  print("SECTION 2")
            let postCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostDisplayCell
            postCell.authorFullNameLabel.isHidden = true
            postCell.postTimeStampLabel.isHidden = true
            postCell.authorProfileImageView.isHidden = true
            postCell.morningImageView.topAnchor.constraint(equalTo: postCell.topAnchor, constant: 10).isActive = true
        
            let postSnapshot = postSnapshots[indexPath.item]
            if let value = postSnapshot.value as? [String:Any],let morningPost = value["Morning"] as? [String:Any]{
                if let thumbUrl = morningPost["thumb_url"] as? String{
                    print("thumb exixts")
                    postCell.morningImageView.loadImageUsingCache(withUrl: thumbUrl)*/
                }
            }
            return postCell
        }
        
    }*/
    
/*    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 85
        }else{
            return 450
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == 1 && indexPath.item == (loadingPostCount - 3){
            loadfeed()
        }
    }
    */
    

}
