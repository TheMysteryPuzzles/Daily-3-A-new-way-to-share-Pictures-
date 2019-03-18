//
//  FeedVcExt.swift
//  Storify
//
//  Created by Work on 7/1/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit


extension FeedViewController: D3ListDelegate,D3ListDatasource, SubCollectionViewDataSource,SubCollectionViewDelegate, PostCellDelegate {
    
    func d3ListView(_ d3CollectionView: UICollectionView, willDisplay cell: D3ListViewCell, forItemAt indexPath: IndexPath) {
        
        cell.subdataSource = self
        cell.subDelegate = self
        cell.addSubCollectionView(index: indexPath.row)
        
        cell.registerSubCollectionView(PostImageCell.self, forCellWithReuseIdentifier: "SubCell")
      
        cell.scrollSubCollectionView(at: IndexPath(item: 1, section: 0), scrollPosition: .centeredHorizontally, animated: false)
        if indexPath.item == (loadingPostCount - 1){
            loadFeed()
        }
       
     }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as! PostImageCell
        cell.backgroundColor = .clear
        
          let postSnapshot = posts[collectionView.tag]
        switch indexPath.item {
        case 0: if postSnapshot.1.eveningImagePostInfo != nil {
            cell.postImageView.loadImageUsingCache(withUrl: postSnapshot.1.eveningImagePostInfo!.thumb_Url)
            }
        case 1: if postSnapshot.1.morningImagePostInfo != nil {
            cell.postImageView.loadImageUsingCache(withUrl: postSnapshot.1.morningImagePostInfo!.thumb_Url)
            }
        case 2: if postSnapshot.1.nightImagePostInfo != nil {
            cell.postImageView.loadImageUsingCache(withUrl: postSnapshot.1.nightImagePostInfo!.thumb_Url)
            }
        default:
            break
        }
        return cell
    }
    
    
    func numberOfItems(inD3List d3List: D3ListView) -> Int{
        return posts.count
    }
    
    func d3ListView(_ d3CollectionView: D3ListView, cellForItemAt indexPath: IndexPath) -> D3ListViewCell{
        let postCell = d3CollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostDisplayCell
        
         if !posts.isEmpty{
            
            let postSnapshot = posts[indexPath.item]
            postCell.populateContent(postSnapshot.1)
            postCell.delegate = self
        }
        postCell.layer.cornerRadius = 8
        postCell.layer.masksToBounds = true
        postCell.backgroundColor = #colorLiteral(red: 0.162932882, green: 0.1667107496, blue: 0.2844091772, alpha: 1)
        return postCell
        
    }
    
    func showAuthorProfile(_ profile: Daily3User) {
        let accountVc = UserAccountViewController()
        accountVc.profile = profile
        self.navigationController?.pushViewController(accountVc, animated: true)
    }
    
    
    
   /* func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        print("PostCount\(posts.count)")
        return posts.count
        
    }*/
    
    /*func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }*/
    
  /*  func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
       /* if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! testCell
            cell.logOutButton.addTarget(self, action: #selector(performLogout), for: .touchUpInside)
            if let userProfileImageUrl = Daily3User.currentUser().profileImageDownloadUrl{
                cell.loginUserProfilePictureView.loadImageUsingCache(withUrl: userProfileImageUrl)
                let userFullName = Daily3User.currentUser().name
                if !userFullName.isEmpty{
                    cell.loginUserNameLabel.text = userFullName }
                
            }
            return cell
        }else {
            */
            let postCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostDisplayCell
            
            if !posts.isEmpty{
                
                let postSnapshot = posts[indexPath.item]
                postCell.populateContent(postSnapshot.1)
               // postCell.delegate = self
           }
            return postCell
        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == (loadingPostCount - 1){
            loadFeed()
        }
    }*/
    
    
    
}
