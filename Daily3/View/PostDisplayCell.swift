//
//  PostDisplayCell.swift
//  Storify
//
//  Created by Work on 6/3/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

protocol PostCellDelegate: class {
    func showAuthorProfile(_ profile: Daily3User)
}

class PostDisplayCell: D3ListViewCell {
    
    var post: Post!
    weak var delegate: PostCellDelegate?

    lazy var timeOfTheDayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = (UIImage(named: "ic_search")!)
       // imageView.layer.cornerRadius = 21
        return imageView
    }()
    
    
    lazy var postHeader: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var postSubHeader: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileHeaderTapped)))
        return view
    }()
    
    
    lazy var subCollectionViewCommentLikesSeperator: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var quoteOfTheDayTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
         label.font = UIFont.systemFont(ofSize: 12 , weight: .ultraLight)
    
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .scaleAspectFill
        /*label.collapsed = true
        label.collapsedAttributedLink = NSAttributedString(string: "Read More")
        label.expandedAttributedLink = NSAttributedString(string: "Read Less")
        label.setLessLinkWith(lessLink: "Close", attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey:UIColor.red], position: nil)*/
        label.text = "It was an amazing day with my aplsIt was an amazing day with my apls It was an amazing day with my apls It was an amazing day with my apls It was an amazing day with my apls"
        
        return label
    }()
    
    lazy var authorProfileImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var authorFullNameLabel: UILabelWithEdgeInsets = {
       let label = UILabelWithEdgeInsets()
        label.backgroundColor = UIColor.clear
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.boldSystemFont(ofSize: 22)
       label.textColor = UIColor.white
       return label
    }()
    
    lazy var postTimeStampLabel: UILabelWithEdgeInsets = {
        let label = UILabelWithEdgeInsets()
         label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    
    lazy var likesLabel: UILabelWithEdgeInsets = {
       let label = UILabelWithEdgeInsets()
        label.textColor = UIColor.white
       label.backgroundColor = UIColor.clear
       label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 Likes"
        label.backgroundColor = UIColor.clear
         label.font = UIFont(name: "Times New Roman", size: 18)
       return label
    }()
    
    lazy var like_CommentsSeperatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    lazy var commentsCountLabel: UILabelWithEdgeInsets = {
        let label = UILabelWithEdgeInsets()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Be the first to comment"
        label.adjustsFontSizeToFitWidth = true
         label.textColor = UIColor.white
        label.font = UIFont(name: "Times New Roman", size: 18)
        return label
    }()
    
    private func setupQuoteOfTheDayTextLabelConstraints(){
        quoteOfTheDayTextLabel.topAnchor.constraint(equalTo: postSubHeader.bottomAnchor).isActive = true
        quoteOfTheDayTextLabel.leftAnchor.constraint(equalTo: postHeader.leftAnchor).isActive = true
        quoteOfTheDayTextLabel.heightAnchor.constraint(equalToConstant: self.frame.height * 0.1).isActive = true
        quoteOfTheDayTextLabel.widthAnchor.constraint(equalTo: postHeader.widthAnchor).isActive = true
    }
    
    private func setupTimeOfTheDayImageViewConstraints(){
        timeOfTheDayImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        timeOfTheDayImageView.topAnchor.constraint(equalTo: postHeader.bottomAnchor, constant: 1).isActive = true
        timeOfTheDayImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        timeOfTheDayImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func setupLikesLabelConstraints(){
        likesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        likesLabel.leftAnchor.constraint(equalTo:
            like_CommentsSeperatorView.rightAnchor, constant: 1.5).isActive = true
        likesLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        likesLabel.widthAnchor.constraint(equalToConstant: (self.frame.width/2) - 2).isActive = true
    }
    
    private func setupLike_CommentsSeperatorLineConstraints(){
        like_CommentsSeperatorView.centerYAnchor.constraint(equalTo: commentsCountLabel.centerYAnchor).isActive = true
        like_CommentsSeperatorView.leftAnchor.constraint(equalTo: commentsCountLabel.rightAnchor, constant: 1.5).isActive = true
        like_CommentsSeperatorView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        like_CommentsSeperatorView.widthAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    
    private func setupCommentsCountLabelConstraints(){
        commentsCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        commentsCountLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
       
        commentsCountLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        commentsCountLabel.widthAnchor.constraint(equalToConstant: (self.frame.width/2) - 2).isActive = true
        
    }
    
    private func setupSubCollectionViewAndCommentLikesSeperator(){
        subCollectionViewCommentLikesSeperator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subCollectionViewCommentLikesSeperator.bottomAnchor.constraint(equalTo: commentsCountLabel.topAnchor, constant: -5).isActive = true
        subCollectionViewCommentLikesSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        subCollectionViewCommentLikesSeperator.widthAnchor.constraint(equalToConstant: self.frame.width * 0.95).isActive = true
    }
    
    private func setupPostHeaderConstraints(){
        postHeader.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        postHeader.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        postHeader.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        postHeader.heightAnchor.constraint(equalToConstant: self.frame.height * 0.2).isActive = true
    }
    
    private func setupAuthorProfileImageViewConstraints(){
        authorProfileImageView.centerYAnchor.constraint(equalTo: postSubHeader.centerYAnchor).isActive = true
     authorProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        authorProfileImageView.heightAnchor.constraint(equalToConstant: (self.frame.height * 0.1) - 4).isActive = true
     authorProfileImageView.widthAnchor.constraint(equalToConstant: (self.frame.height * 0.1) - 4).isActive = true
        authorProfileImageView.layer.cornerRadius = ((self.frame.height * 0.1) - 4)/2
    }
    
    private func setupAuthorFullNameLabelConstraints(){
        authorFullNameLabel.topAnchor.constraint(equalTo: authorProfileImageView.topAnchor, constant: 2).isActive = true
       authorFullNameLabel.heightAnchor.constraint(equalToConstant: ((self.frame.height*0.1)*0.6) - 2).isActive = true
        authorFullNameLabel.leadingAnchor.constraint(equalTo: authorProfileImageView.trailingAnchor, constant: 5).isActive = true
        authorFullNameLabel.trailingAnchor.constraint(equalTo: postSubHeader.trailingAnchor).isActive = true
      
    }
    
    private func setupTimeStampLabelConstraints(){
        postTimeStampLabel.topAnchor.constraint(equalTo: authorFullNameLabel.bottomAnchor, constant: 5).isActive = true
        postTimeStampLabel.leadingAnchor.constraint(equalTo: authorProfileImageView.trailingAnchor, constant: 5).isActive = true
        postTimeStampLabel.trailingAnchor.constraint(equalTo: postSubHeader.trailingAnchor).isActive = true
         postTimeStampLabel.heightAnchor.constraint(equalToConstant: ((self.frame.height*0.1)*0.3) - 2).isActive = true
    }
    
    private func setupPostSubHeaderConstraints(){
        postSubHeader.topAnchor.constraint(equalTo: postHeader.topAnchor).isActive = true
        postSubHeader.leftAnchor.constraint(equalTo: postHeader.leftAnchor).isActive = true
        postSubHeader.heightAnchor.constraint(equalToConstant: self.frame.height * 0.1).isActive = true
        postSubHeader.widthAnchor.constraint(equalTo: postHeader.widthAnchor).isActive = true
        postHeader.backgroundColor = postHeader.hexStringToUIColor(hex: "#24243e")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postHeader)
        setupPostHeaderConstraints()
        postHeader.addSubview(postSubHeader)
        setupPostSubHeaderConstraints()
        self.postSubHeader.addSubview(authorProfileImageView)
        setupAuthorProfileImageViewConstraints()
        self.postSubHeader.addSubview(authorFullNameLabel)
        setupAuthorFullNameLabelConstraints()
        self.postSubHeader.addSubview(postTimeStampLabel)
        setupTimeStampLabelConstraints()
        postHeader.addSubview(quoteOfTheDayTextLabel)
        setupQuoteOfTheDayTextLabelConstraints()
        addSubview(commentsCountLabel)
        setupCommentsCountLabelConstraints()
        addSubview(like_CommentsSeperatorView)
        setupLike_CommentsSeperatorLineConstraints()
        addSubview(likesLabel)
        setupLikesLabelConstraints()
        addSubview(subCollectionViewCommentLikesSeperator)
        setupSubCollectionViewAndCommentLikesSeperator()
        addSubview(timeOfTheDayImageView)
        setupTimeOfTheDayImageViewConstraints()
        
        self.changeTimeOfTheDayImage = {(image) in
            DispatchQueue.main.async(execute: {
                self.timeOfTheDayImageView.flipCurrentImage(with: image)
            })
        }
       
      
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func expandCaptionLabel() {
        
    }
    
    @objc func profileHeaderTapped(){
       delegate?.showAuthorProfile(post.author)
    }
    
    @objc func commentLabelTapped(){
        
    }
    
    func populateContent(_ post: Post){
        self.post = post
        let authorFullName = post.author.name
        self.authorFullNameLabel.text = authorFullName
        let timeStamp = convertTimeStampIntoDate(timeStamp: post.timeStamp)
        self.postTimeStampLabel.text = timeStamp
        if let profileImageUrl = post.author.profileImageDownloadUrl {
            self.authorProfileImageView.loadImageUsingCache(withUrl: profileImageUrl)
        }
        if post.morningImagePostInfo != nil {
            
        }
        if post.eveningImagePostInfo != nil {
            
        }
        if post.nightImagePostInfo != nil {
            
        }
    }
    
    //DATE STUFF
    
    func convertTimeStampIntoDate(timeStamp: Double) -> String{
        let date = Date(timeIntervalSince1970: (timeStamp / 1_000.0))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
}

// TEST CELL

class testCell :UITableViewCell{
    
    var loginUserProfilePictureView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 42.5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.9749622941, green: 0.2864883542, blue: 0.2989505529, alpha: 1)
        
        return imageView
    }()
    
    var loginUserNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nameless"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    var logOutButton : UIButton = {
       let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.9749622941, green: 0.2864883542, blue: 0.2989505529, alpha: 1)
        button.backgroundColor?.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupLoginUserNameLabelConstraints(){
        loginUserNameLabel.leftAnchor.constraint(equalTo: loginUserProfilePictureView.rightAnchor, constant: 10).isActive = true
        loginUserNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        loginUserNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loginUserNameLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupProfileImageViewConstraints(){
        loginUserProfilePictureView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        loginUserProfilePictureView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        loginUserProfilePictureView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        loginUserProfilePictureView.widthAnchor.constraint(equalToConstant: 85).isActive = true
    }

    
    func setupButtonConstraints(){
        logOutButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        textLabel?.isHidden = true
        addSubview(loginUserProfilePictureView)
        setupProfileImageViewConstraints()
        addSubview(loginUserNameLabel)
        setupLoginUserNameLabelConstraints()
        addSubview(logOutButton)
        setupButtonConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UILabelWithEdgeInsets: UILabel {
    
    var topInset: CGFloat = 0
    var bottomInset: CGFloat = 3.0
    var leftInset: CGFloat = 7.0
    var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
   
    
   /* override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }*/
}
