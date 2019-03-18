//
//  AccountHeaderCell.swift
//  Storify
//
//  Created by Work on 6/2/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

class AccountHeaderCell: UITableViewCell {
   
    var accountVc: UserAccountViewController? {
        didSet{
            followSwitch.addTarget(accountVc, action: #selector(accountVc?.valueChanged), for: .valueChanged)
        }
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private func setupProfileImageViewConstraints(){
    profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
     }
    
    var followSwitch: UISwitch = {
        let followSwicth =  UISwitch()
        followSwicth.translatesAutoresizingMaskIntoConstraints = false
        return followSwicth
    }()
    
    func setupFollowSwitchConstraints(){
        followSwitch.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        followSwitch.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    }
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = #colorLiteral(red: 0.9749622941, green: 0.2864883542, blue: 0.2989505529, alpha: 1)
        label.backgroundColor?.withAlphaComponent(0.7)
        label.text = " following"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
         label.text = " followers"
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.backgroundColor = #colorLiteral(red: 0.9749622941, green: 0.2864883542, blue: 0.2989505529, alpha: 1)
        label.backgroundColor?.withAlphaComponent(0.7)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var postsLabel: UILabel = {
        let label = UILabel()
         label.text = " posts"
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.backgroundColor = #colorLiteral(red: 0.9749622941, green: 0.2864883542, blue: 0.2989505529, alpha: 1)
        label.backgroundColor?.withAlphaComponent(0.7)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private func setupFollowersLabelConstraints(){
        followersLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        followersLabel.topAnchor.constraint(equalTo: followSwitch.bottomAnchor, constant: 15).isActive = true
        followersLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        followersLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    private func setupPostsLabelConstraints(){
        postsLabel.leftAnchor.constraint(equalTo: followersLabel.rightAnchor, constant: 15).isActive = true
        postsLabel.topAnchor.constraint(equalTo: followSwitch.bottomAnchor, constant: 15).isActive = true
        postsLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        postsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }
    private func setupFollowingLabelConstraints(){
        followingLabel.leftAnchor.constraint(equalTo: postsLabel.rightAnchor, constant: 15).isActive = true
        followingLabel.topAnchor.constraint(equalTo: followSwitch.bottomAnchor, constant: 15).isActive = true
        followingLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        followingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        textLabel?.isHidden = true
        self.backgroundView?.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        addSubview(profileImageView)
        setupProfileImageViewConstraints()
        addSubview(followSwitch)
        setupFollowSwitchConstraints()
        addSubview(followersLabel)
        setupFollowersLabelConstraints()
        addSubview(postsLabel)
        setupPostsLabelConstraints()
        addSubview(followingLabel)
        setupFollowingLabelConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
}
