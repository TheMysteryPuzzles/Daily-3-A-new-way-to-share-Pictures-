//
//  ViewController.swift
//  Storify
//
//  Created by Work on 2/11/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController {
    
    var image: UIImage?
    var selectedImageView: UIImageView!
    let ref = Database.database().reference(fromURL: "https://storify-a9ada.firebaseio.com/")
    var newPost: NewPost!
    var lastPost: Post!
    var userPostRef: DatabaseReference?
    var accessiblility = "public"
    var activityIndicator: UIActivityIndicatorView!
    
    enum TimesOfDay: CustomStringConvertible {
        case Morning
        case Evening
        case Night
        
        var description:String {
            switch self {
            case .Morning: return "Morning"
            case .Evening: return "Evening"
            case .Night: return "Night"
            }
        }
    }
    var morningImage: UIImage?
    var eveningImage: UIImage?
    var nightImage: UIImage?
    var selectedTimeOfDay: TimesOfDay?
    
    var isAllowedToDoNewPost: Bool!
    var lastPostId: String?
    
    
    
    lazy var newPostContentView: NewPostView = {
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let NewPostFrameHeight = (self.view.frame.height - navBarHeight) * 0.8
        let postView = NewPostView(frame: CGRect(x: 0, y: navBarHeight, width: self.view.frame.width, height: NewPostFrameHeight))
        postView.newPostCollectionViewDataSource = self
        postView.newPostViewController = self
        postView.backgroundColor = UIColor.green
        return postView
    }()
    
    
    lazy var newPostButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handlePrivacy), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Post", for: .normal)
        button.isEnabled = false
        button.backgroundColor = UIColor.blue
        return button
    }()
    
    
    private func setupNewPostButtonConstraints(){
        NSLayoutConstraint.activate([
            newPostButton.topAnchor.constraint(equalTo: newPostContentView.bottomAnchor),
            newPostButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            newPostButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            newPostButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
            ])
    }
    
    fileprivate func updateDataBase() {
        let uid = Auth.auth().currentUser!.uid
        var postId: String!
        var isEmpty:Bool = true{
            didSet{
                if isAllowedToDoNewPost {
                    self.userPostRef = ref.child("posts/\(accessiblility)").childByAutoId()
                    postId = self.userPostRef!.key
                    self.newPost = NewPost(uid: uid, ref: self.userPostRef!, date: self.getCurrentDate(), accessiblility: accessiblility)
                    self.newPost.createNewPostInDatabase {}
                }else{
                    self.userPostRef = ref.child("posts/\(accessiblility)/\(lastPostId!)")
                    postId = self.userPostRef!.key
                    self.newPost = NewPost(uid: uid, ref: self.userPostRef!, date: self.getCurrentDate(), accessiblility: accessiblility)
                }
            }
        }
        
        if let morningImg = self.morningImage {
            
            if isEmpty {isEmpty = false}
            self.newPost.morningImagePostInfo = PostInfo(img: morningImg, timeOfDay: "Morning", uid: uid, postId: postId)
        }
        if let eveningImg = self.eveningImage {
            if isEmpty {isEmpty = false}
            self.newPost.eveningImagePostInfo = PostInfo(img: eveningImg, timeOfDay: "Evening", uid: uid, postId: postId)            }
        if let nightImg = self.nightImage {
            if isEmpty {isEmpty = false}
            self.newPost.nightImagePostInfo = PostInfo(img: nightImg, timeOfDay: "Night", uid: uid, postId: postId)
        }
        
        if self.newPost != nil
        {
            self.newPost.uploadToDatabase(completionBlock: { (flag) in
                if flag == true {
                    self.activityIndicator.stopAnimating()
                    let defaults = UserDefaults.standard
                    let lastPostInfo = LastPostInfo(lastPId: self.newPost.postID, LastPDate: self.newPost.postDate, accesibility: self.newPost.accessibleTo)
                    defaults.set(lastPostInfo.encode(), forKey: self.newPost.userId); self.navigationController?.popViewController(animated: true)
                }
            })}else{
            // ERROR-> UI HERE
            self.newPostButton.isEnabled = false
        }
    }
    
    
    private func checkForLastPostAvailabilty(completionHandler: @escaping () -> ()){
        
        checkPermissions {[weak self] (postRef) in
            self?.userPostRef = postRef
            if self?.isAllowedToDoNewPost != nil , !(self?.isAllowedToDoNewPost!)! {
                postRef?.observeSingleEvent(of: .value, with: { (postSnapshot) in
                        self?.lastPost = Post(snapshot: postSnapshot)
                    completionHandler()
                    return
                   })
            }else{
                completionHandler()
            }
        }
    }
    
    
    @objc func handlePrivacy(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        newPostContentView.addPrivacyView()
    }
    
    @objc func handleNewPost(){
        //self.newPostView.morningPostImageView.alpha = 0.2
        self.newPostContentView.backgroundColor = UIColor.lightGray
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.activityIndicator.center = self.newPostContentView.center
        self.newPostContentView.postPrivacyContainerView.isHidden = true
        self.newPostContentView.addSubview(activityIndicator)
         self.activityIndicator.startAnimating()
        self.updateDataBase()
        
    }
    
    
    func setNaviagtionItemTitleForCurrentUser() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                    
                }
            })
        }
    }
    
    @objc func handleMorningImageSelection(tapGestureRecognizer: UITapGestureRecognizer){
        let imageView = tapGestureRecognizer.view as! UIImageView
        self.selectedImageView = imageView
        self.selectedTimeOfDay = TimesOfDay.Morning
        self.handleImageSelection()
    }
    
    @objc func handleEveningImageSelection(tapGestureRecognizer: UITapGestureRecognizer){
        let imageView = tapGestureRecognizer.view as! UIImageView
        self.selectedImageView = imageView
        handleImageSelection()
        self.selectedTimeOfDay = TimesOfDay.Evening
    }
    
    @objc func handleNightImageSelection(tapGestureRecognizer: UITapGestureRecognizer){
        let imageView = tapGestureRecognizer.view as! UIImageView
        self.selectedImageView = imageView
        handleImageSelection()
        self.selectedTimeOfDay = TimesOfDay.Night
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.checkForLastPostAvailabilty(completionHandler:{
            self.view.addSubview(self.newPostContentView)
            self.view.addSubview(self.newPostButton)
            self.setupNewPostButtonConstraints()
        })
    }
    
    @objc func cancelNewPost(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //NEW POST PERMISION
    private func isAllowedToDoNewPost(completionHandler: @escaping (Bool,String?)->()){
        let uid = Auth.auth().currentUser!.uid
        //MARK ->Downloading last User's post and comparing its date.
        //MARK -> WATCH FOR DEADLOCKS
        var key : String?
        let dispatchGroup = DispatchGroup()
        let postRef = self.ref.child("people").child(uid).child("posts")
        let query = postRef.queryOrderedByKey().queryLimited(toLast: 1)
        dispatchGroup.enter()
        query.observeSingleEvent(of: .value, with: {
            if $0.exists(){
                if let snapshot = $0.value as? [String:Any]{
                    if let value = snapshot.first?.value as? [String:Any] {
                        key = snapshot.first?.key
                        let timeStamp = value["timeStamp"] as! Double
                        let lastPostDate = self.convertTimeStampIntoDate(timeStamp: timeStamp)
                        if self.compareCurrentDate(with: lastPostDate){
                            completionHandler(true,key!)
                        }else{
                            completionHandler(false,key!)
                        }
                    }
                }
            }else{
                completionHandler(true,nil)}
                dispatchGroup.leave()
            })
    }
    
    
   private func checkPermissions(completionHandler: @escaping (DatabaseReference?)->()) {
        let uid = Auth.auth().currentUser!.uid
        let defaults = UserDefaults.standard
        // CHECKING IF LAST POST INFO IS AVAILABLE IN USER DEFAULTS
        if let lastPostInfo = defaults.value(forKey: uid) as? Data{
            let decoder = JSONDecoder()
            var dict = Dictionary<String,String>()
            if let strt = try? decoder.decode(LastPostInfo.self, from: lastPostInfo){
                 print("IDD\(strt.lastPostID)")
                dict = ["lastPostID":strt.lastPostID,"lastPostDate":strt.lastPostDate, "lastPostAccesibility": strt.lastPostAccesibility] }
           
            let postDate = dict["lastPostDate"]
            let accesibility = dict["lastPostAccesibility"]
            if compareCurrentDate(with: postDate!){
                self.isAllowedToDoNewPost = true
                return
            }else if let lastPostId = dict["lastPostID"]{
                self.isAllowedToDoNewPost = false
                self.lastPostId = lastPostId
                let postRef = self.ref.child("posts/\(accesibility!)/\(lastPostId)")
                DispatchQueue.main.async {
                      completionHandler(postRef)
                }
               
            }
            
        }else{
            isAllowedToDoNewPost(completionHandler: { (flag, key) in
                
                if flag{
                    self.isAllowedToDoNewPost = true
                    completionHandler(nil)
                    return
                }else if let availableKey = key , !flag {
                    self.isAllowedToDoNewPost = false
                    self.lastPostId = availableKey
                   completionHandler(nil)
                   return
                }
                
            })
        }
    }
    
    
    
    //DATE COMPARISION AND FORMATTING
    func compareCurrentDate(with lastPostDate:String)->Bool{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let currentDate = Date()
        if let postDate = formatter.date(from: lastPostDate){
            let order = NSCalendar.current.compare(currentDate, to: postDate, toGranularity: .day)
            switch order{
            case .orderedSame: return false
            default: return true
            }
        }
        return false
    }
    
    func getCurrentDate()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func convertTimeStampIntoDate(timeStamp: Double) -> String{
        let date = Date(timeIntervalSince1970: (timeStamp / 1_000.0))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
}

