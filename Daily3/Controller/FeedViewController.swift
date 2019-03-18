//
//  FeedViewController.swift
//  Storify
//
//  Created by Work on 3/23/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import Firebase


class FeedViewController: UIViewController, UITabBarDelegate {

    lazy var uid = Auth.auth().currentUser!.uid
    lazy var database = Database.database()
    lazy var ref = self.database.reference(fromURL: "https://storify-a9ada.firebaseio.com/")
    lazy var postRef = self.database.reference(withPath: "posts")
    
    var followingRef :DatabaseReference?
    static let postsPerLoad = 3
    static let postsLimit: UInt = 4
    
    var query: DatabaseQuery!
    var posts = [(Accesibilty,Post)]()
    var loadingPostCount = 0
    var nextEntry: String?
    var showTrending = false
    var observers = [DatabaseQuery]()
    var newPost = false
    var followChanged = false
    var isFirstOpen = true
    var d3List: D3List!
    var activityIndicator: UIActivityIndicatorView!
    var bottomBar: BottomBar!
    
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        followingRef?.removeAllObservers()
        postRef.removeAllObservers()
        for observer in observers{
            observer.removeAllObservers()
        }
        observers = [DatabaseQuery]()
      }
    
    
    fileprivate func setupBottomBar() {

        bottomBar = BottomBar()
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBar)
        NSLayoutConstraint.activate([
             bottomBar.bottomAnchor.constraint(equalTo: self.view.safeBottomAnchor),
             bottomBar.leadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 50)
            ])
        bottomBar.feedVc = self
        let unsafeBottomUnsafeAreaView = UIView()
     
        unsafeBottomUnsafeAreaView.translatesAutoresizingMaskIntoConstraints = false
       unsafeBottomUnsafeAreaView.backgroundColor = #colorLiteral(red: 0.3571172357, green: 0.04455052316, blue: 0.8773006797, alpha: 1)
        self.view.addSubview(unsafeBottomUnsafeAreaView)
        
        NSLayoutConstraint.activate([
            unsafeBottomUnsafeAreaView.topAnchor.constraint(equalTo: self.view.safeBottomAnchor),
            unsafeBottomUnsafeAreaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            unsafeBottomUnsafeAreaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            unsafeBottomUnsafeAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        if checkUserLoginStatus(){
            self.uid = Auth.auth().currentUser!.uid
            setupD3List()
        
            self.followingRef = database.reference(withPath: "people/\(uid)/following")
            
            if newPost {
                reloadFeed()
                newPost = false
                return
            }
            if !showTrending && followChanged {
                reloadFeed()
                followChanged = false
                return
            }
            loadData()
         }
    }
    
    fileprivate func setupD3List() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController!.navigationBar.frame.height
        let navAndStatusBarHeight = statusBarHeight + navBarHeight
        let displayWidth = self.view.frame.width
        let displayHeight = self.view.frame.height
        self.d3List = D3List(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: displayWidth, height: displayHeight - (navAndStatusBarHeight + 50 + self.view.safeAreaInsets.bottom)))
      
       self.d3List.register(PostDisplayCell.self, forCellWithReuseIdentifier: "postCell")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        d3List.refreshControl = refreshControl
        self.d3List.delegate = self
        self.d3List.dataSource = self
        self.view.addSubview(d3List)
    }
    
    fileprivate func setupNavigationView() {
        
        let topUnsafeView = UIView()
        topUnsafeView.backgroundColor = #colorLiteral(red: 0.8338278532, green: 0.4056952596, blue: 0.887965858, alpha: 1)
        topUnsafeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topUnsafeView)
        NSLayoutConstraint.activate([
              topUnsafeView.heightAnchor.constraint(equalToConstant: 20),
            topUnsafeView.topAnchor.constraint(equalTo: self.view.topAnchor),
            topUnsafeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topUnsafeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
          
            ])
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .done, target: self, action: #selector(handleSearch))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search"), style: .done, target: self, action: #selector(handleSearch))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.9446316219, blue: 0.9727292737, alpha: 1)
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.9446316219, blue: 0.9727292737, alpha: 1)
        self.navigationController?.navigationBar.applyNavBarMainAppTheme()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupBottomBar()
        setupNavigationView()
        setupActivityIndicator()
      }
    
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        reloadFeed()
        sender.endRefreshing()
    }

    
    private func displayActivityIndicator(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func removeActivityIndicator(){
         self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    private func loadHomeFeedPosts(){
        let dispatchGroup = DispatchGroup()
        followingRef?.observeSingleEvent(of: .value) { (followingSnapshot) in
            if followingSnapshot.exists(){
                guard let followedPeople = followingSnapshot.value as? [String:Any] else{
                    self.startUpdatingHomeFeedLive()
                    self.loadFeed()
                    self.listenPostDeleteion()
                    return
                }
                for (followedPersonUid,lastSnyncedPost) in followedPeople {
                     dispatchGroup.enter()
                    let thisPersonPostsRef = self.ref.child("people/\(followedPersonUid)/posts")
                    let query = thisPersonPostsRef.queryOrderedByKey().queryStarting(atValue: lastSnyncedPost)
                    query.observeSingleEvent(of: .value, with: { (postSnapshot) in
                        if postSnapshot.exists(){
                            var updateData = [AnyHashable:Any]()
                            if let posts = postSnapshot.value as? [String:Any]{
                                for post in posts {
                                    if let postInfo = post.value as? [String:Any]{
                                    updateData["feed/\(self.uid)/\(post.key)"] = postInfo["accessibleTo"]
                                        updateData["people/\(self.uid)/following/\(followedPersonUid)"] = post.key
                                    }
                                }
                                self.ref.updateChildValues(updateData, withCompletionBlock: { (_, _) in
                                    dispatchGroup.leave()
                              })
                            }
                          }else{
                            dispatchGroup.leave()
                        }
                    })
                    
                }
                dispatchGroup.notify(queue: .main){
                    self.startUpdatingHomeFeedLive()
                    self.loadFeed()
                }
            }
        }
    }
    
    private func listenPostDeleteion(){
        
        postRef.observe(.childRemoved) { (deletedPost) in
            if let index = self.posts.index(where: {$0.1.postId == deletedPost.key}){
                self.posts.remove(at: index)
                self.loadingPostCount -= 1
                let i = self.posts.distance(from: self.posts.startIndex, to: index)
                self.d3List.deleteItems(at: [IndexPath(item: i, section: 0)])
            }
        }
    }
    
    private func startUpdatingHomeFeedLive(){
        followingRef = self.ref.child("people/\(uid)/following")
        followingRef?.observe(.childAdded) { (followingSnapshot) in
           let followedUid = followingSnapshot.key
            let followedUserPostRef: DatabaseQuery = self.ref.child("people").child(followedUid).child("posts")
            if followingSnapshot.exists() && (followingSnapshot.value is String){
                followedUserPostRef.queryOrderedByKey().queryStarting(atValue: followingSnapshot.value)
            }
            followedUserPostRef.observe(.childAdded, with: { (postSnapshot) in
                if postSnapshot.key != followingSnapshot.key{
                    if let postInfo = postSnapshot.value as? [String:Any] {
                       
                    let updates: [AnyHashable:Any] = ["feed/\(self.uid)/\(postSnapshot.key)": postInfo["accessibleTo"]!,
                                   "people/\(self.uid)/following/\(followedUid)": postSnapshot.key]
                        self.ref.updateChildValues(updates)
                        
                    }
                   }
                 })
             self.observers.append(followedUserPostRef)
           }
        
        followingRef?.observe(.childRemoved) { (snapshot) in
            //TODO -> REMOVE ALL UNFOLLWED PEOPLE POSTS FROM FEED
            self.ref.child("people/\(snapshot.key)/posts").removeAllObservers()
        }
    }
    
    
    fileprivate func loadPost(_ snapShotAndAccesiblity: (String, DataSnapshot)){
        let post = Post(snapshot: snapShotAndAccesiblity.1)
        self.posts.append((Accesibilty(accesibleTo: snapShotAndAccesiblity.0), post))
      //   let last = posts.count - 1
       // print("Last\(last)")
        self.d3List.reloadData()
        //self.d3List.insertItems(at: [IndexPath(item: last, section: 0)])
    }
    
    func loadFeed(){
        print("Loading feed")
        if observers.isEmpty && !posts.isEmpty{
            print("IF CONDITION")
            removeActivityIndicator()
         
            for post in posts {
                var ref: DatabaseReference!
                if !showTrending{
                    ref = postRef.child(post.0.description)
                }else{
                    ref = postRef.child("public")
                }
                ref.child(post.1.postId).observeSingleEvent(of: .value) { (postSnapshot) in
                    if postSnapshot.exists(){
                        print("Exists")
                       // Mark -> todo COMMENTS AND LISTENING OF COMMENTS AND LIKES
                    }else{
                        if let index = self.posts.index(where: {$0.1.postId == post.1.postId}){
                            self.posts.remove(at: index)
                            let i = self.posts.distance(from: self.posts.startIndex, to: index)
                            self.loadingPostCount -= 1
                            self.d3List.deleteItems(at: [IndexPath(item: i, section: 0)])
                            if self.posts.isEmpty {
                              // self.tableView.backgroundView = self.emptyFeedLabel
                            }
                        }
                    }
                }
            }
            
        }else{
        var query = self.query?.queryOrderedByKey()
        if let queryEnding = nextEntry{
            query = query?.queryEnding(atValue: queryEnding)
        }
        loadingPostCount = posts.count + FeedViewController.postsPerLoad
        query?.queryLimited(toLast: FeedViewController.postsLimit).observeSingleEvent(of: .value, with: { (feedSnapshot) in
            self.removeActivityIndicator()
            if let reversed = feedSnapshot.children.allObjects as? [DataSnapshot], !reversed.isEmpty {
            // self.tableView.backgroundView = nil
                self.nextEntry = reversed[0].key
                var results = [Int:(String,DataSnapshot)]()
                let extraElement = reversed.count > FeedViewController.postsPerLoad ? 1 : 0
                let dispatch = DispatchGroup()
               // self.d3List.performBatchUpdates({
                    for index in stride(from: reversed.count - 1 , through: extraElement, by: -1){
                        
                        let item = reversed[index]
                        
                        if self.showTrending{
                            self.loadPost(("public",item))
                        }else{
                        dispatch.enter()
                        let current = reversed.count - 1 - index
                        let accesiblity = item.value as! String
                        self.postRef.child("\(accesiblity)").child(item.key).observeSingleEvent(of: .value, with: { (postSnapshot) in
                            results[current] = (accesiblity,postSnapshot)
                            dispatch.leave()
                        })
                      }
                    }
                    dispatch.notify(queue: .main){
                        if !self.showTrending{
                          
                            for index in 0..<(reversed.count - extraElement){
                            if let snapShotAndAccesiblity = results[index]{
                                if snapShotAndAccesiblity.1.exists(){
                                    self.loadPost(snapShotAndAccesiblity)
                                    
                                }else{
                                   self.loadingPostCount -= 1
                                   self.ref.child("feed/\(self.uid)/\(snapShotAndAccesiblity.1.key)").removeValue()
                                }
                            }
                            }
                        }
                    }
              //  }, completion: nil)
            }else if self.posts.isEmpty && !self.showTrending{
                if self.isFirstOpen{
                    self.showTrending = true
                    self.reloadFeed()
                    self.isFirstOpen = false
                }else{
                   // self.tableView.backgroundView = self.emptyFeedLabel
                }
            }
        })
    }
}
    
    private func reloadFeed(){
        followingRef?.removeAllObservers()
        postRef.removeAllObservers()
        for observer in observers{
            observer.removeAllObservers()
        }
        observers = [DatabaseQuery]()
        posts = [(Accesibilty, Post)]()
        loadingPostCount = 0
        nextEntry = nil
        cleanD3List()
        loadData()
        
    }
    
    internal func cleanD3List(){
        if d3List!.numberOfItems(inSection: 0) > 0 {
            d3List.reloadSections([0])
        }
    }
    
   private func loadData(){
        self.displayActivityIndicator()
        if showTrending {
            query = postRef.child("public")
            loadFeed()
            listenPostDeleteion()
        }else{
            query = self.database.reference(withPath: "feed/\(uid)")
            loadHomeFeedPosts()
        }
    }
    
    
  
    
    
    func handleLike(){
        
    }
  
    @objc func handlePostDetail(){
        
    }
    
    @objc func handleAuthorAccount(profile: Daily3User){
        
    }
    

    public func handleNewPost(){
        self.isFirstOpen = false
     self.navigationController?.pushViewController(NewPostViewController(), animated: true)
    }
  
    func setNaviagtionItemTitleForCurrentUser() {
        let titleImage = UIImage(named: "logoTitle")
        let titleImageView = UIImageView(image: titleImage)
   
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
    }
    
    var emptyFeedLabel : UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.text = "Please follow Anyone to get you feed populated with yours followed people post"
        label.textColor = UIColor.darkText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    private func setupEmptyFeedLabelConstraints(){
        emptyFeedLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        emptyFeedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emptyFeedLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        emptyFeedLabel.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    
    fileprivate func checkUserLoginStatus() -> Bool {
        
        if Auth.auth().currentUser?.uid == nil {

           perform(#selector(performLogout), with: nil, afterDelay: 0)
            return false
        }else{
            setNaviagtionItemTitleForCurrentUser()
            return true
        }
    }
   
   
 
    @objc func performLogout(){
        
        do{
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginVC = LoginViewController()
        loginVC.rootVcReference = self
        loginVC.modalPresentationStyle = .currentContext
      //  modalPresentationStyle
        self.tabBarController?.tabBar.isHidden = true
        present(loginVC, animated: true, completion: nil)
    }
  
    @objc func handleSearch(){
        let searchVc = SearchViewController()
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    private func setupActivityIndicator(){
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.activityIndicator.isHidden = true
    }
   
    public func homeAction() {
        showTrending = false
        reloadFeed()
    }
    
     public func trendingAction() {
        posts =  [(Accesibilty, Post)]()
        showTrending = true
        reloadFeed()
    }
    
    
}

public var d3ListSize: CGSize?
public var d3ListItemSize: CGSize?{
let topInset: CGFloat = 20
let sideInset: CGFloat = 20
let nextVisibleItemHeight: CGFloat = 50
let itemSpacing: CGFloat = 30
let xInsets = sideInset * 2
let yInsets = itemSpacing + nextVisibleItemHeight + topInset
    if let size = d3ListSize{
        let  cellWidth = screenWidth - xInsets
        let  cellHeight = size.height - yInsets
        return CGSize(width: cellWidth, height: cellHeight)
    }
return nil
    
}

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

