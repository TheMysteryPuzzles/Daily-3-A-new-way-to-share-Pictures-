//
//  NewPostView.swift
//  Storify
//
//  Created by Work on 5/1/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

class NewPostView: UIView {
    
    
    var newPostCollectionView: UICollectionView!
    var newPostCollectionViewDataSource: UICollectionViewDataSource!
    
    lazy var PostCollectionViewFlowLayout: SubCollectionViewFlowLayout = {
        let flowLayout = SubCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemAlpha = 1.0
        flowLayout.sideItemScale = 0.9
        flowLayout.spacingMode = SpacingMode.overlap(visibleOffset: 100)
        return flowLayout
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //MARK-> Adding subview
    //    self.addSubview(morningPostImageView)
      //  self.addSubview(eveningPostImageView)
       // self.addSubview(nightPostImageView)
        
        //MARK-> Adding Constraints to subviews
      //  setupMorningImageViewConstratint()
       // setupEveningImageViewConstratint()
        //setupNightImageViewConstratint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var newPostViewController: NewPostViewController? {
        didSet{
            newPostCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: PostCollectionViewFlowLayout)
           // newPostCollectionView.dataSource = self
            newPostCollectionView.register(NewPostCell.self, forCellWithReuseIdentifier: "NewPostCell")
            newPostCollectionView.dataSource = newPostCollectionViewDataSource
          
            addSubview(newPostCollectionView)
            newPostCollectionView.backgroundColor = newPostCollectionView.hexStringToUIColor(hex: "#0f0c29")
            postButton.addTarget(newPostViewController, action: #selector(newPostViewController?.handleNewPost), for: .touchUpInside)
        }
    }
    
    var morningPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var eveningPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var nightPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    lazy var postPrivacyContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.lightGray
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
     var cancelButton: UIButton = {
       let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 15.0
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(dismissPrivacyView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
     var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 15.0
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate func addSubviewAndSetupConstraints() {
        // SETUP SUBVIEWS CONSTRAINTS
        postPrivacyContainerView.addSubview(self.pubicPrivateSegmentedControl)
        postPrivacyContainerView.addSubview(self.publicPrivateDetailTextLabel)
        postPrivacyContainerView.addSubview(self.cancelButton)
        postPrivacyContainerView.addSubview(self.postButton)
        setupPublicPrivateSegementedControlConstraints()
        setuppublicPrivateDetailTextLabelConstraints()
        setupCancelButtonConstraints()
        setupPostButtonConstraints()
    }
    
    func setupContainerViewConstraints(){
        postPrivacyContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        postPrivacyContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        postPrivacyContainerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        postPrivacyContainerView.heightAnchor.constraint(equalToConstant: self.frame.height/2).isActive = true
        
        addSubviewAndSetupConstraints()
    }
    
    private func setupMorningImageViewConstratint(){
        morningPostImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        morningPostImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        morningPostImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
    morningPostImageView.heightAnchor.constraint(equalToConstant: CGFloat(self.frame.height/2)).isActive = true
    }
    
   lazy var pubicPrivateSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Public","Private"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.white
        sc.layer.cornerRadius = 15.0
        sc.layer.masksToBounds = true
        sc.layer.borderWidth = 2
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(enumeratePublicPrivateSegmentControl), for: .valueChanged)
        return sc
    }()
    
    func setupPublicPrivateSegementedControlConstraints(){
        pubicPrivateSegmentedControl.topAnchor.constraint(equalTo: postPrivacyContainerView.topAnchor, constant: 27).isActive = true
        pubicPrivateSegmentedControl.centerXAnchor.constraint(equalTo: postPrivacyContainerView.centerXAnchor).isActive = true
        pubicPrivateSegmentedControl.widthAnchor.constraint(equalTo: postPrivacyContainerView.widthAnchor, constant: -20).isActive = true
        pubicPrivateSegmentedControl.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    
    private func setupEveningImageViewConstratint(){
        eveningPostImageView.topAnchor.constraint(equalTo: morningPostImageView.bottomAnchor).isActive = true
        eveningPostImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eveningPostImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        eveningPostImageView.heightAnchor.constraint(equalToConstant: CGFloat(self.frame.height/3)).isActive = true
        
    }
    private func setupNightImageViewConstratint(){
        nightPostImageView.topAnchor.constraint(equalTo: eveningPostImageView.bottomAnchor).isActive = true
        nightPostImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nightPostImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        nightPostImageView.heightAnchor.constraint(equalToConstant: CGFloat(self.frame.height/3)).isActive = true
    }
    
    private func setupCancelButtonConstraints(){
        cancelButton.bottomAnchor.constraint(equalTo: postPrivacyContainerView.bottomAnchor, constant: -10).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: postPrivacyContainerView.leftAnchor, constant: 10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: CGFloat(self.frame.width/2)-25).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    private func setupPostButtonConstraints(){
        postButton.bottomAnchor.constraint(equalTo: postPrivacyContainerView.bottomAnchor, constant: -10).isActive = true
        postButton.leftAnchor.constraint(equalTo: cancelButton.rightAnchor, constant: 10).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: (self.frame.width/2)-25).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func addPrivacyView(){
        self.hideView = true
        addSubview(postPrivacyContainerView)
        setupContainerViewConstraints()
    }
    
    @objc func dismissPrivacyView(){
        self.hideView = false
    }
    
    lazy var publicPrivateDetailTextLabel: UILabel = {
       let label = UILabel()
        label.text = "This post is by default public.It will be visible to everyone in explore tab."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    func setuppublicPrivateDetailTextLabelConstraints(){
        publicPrivateDetailTextLabel.topAnchor.constraint(equalTo: pubicPrivateSegmentedControl.bottomAnchor, constant: 25).isActive = true
        publicPrivateDetailTextLabel.centerXAnchor.constraint(equalTo: postPrivacyContainerView.centerXAnchor).isActive = true
        publicPrivateDetailTextLabel.widthAnchor.constraint(equalTo: postPrivacyContainerView.widthAnchor, constant: -25).isActive = true
        publicPrivateDetailTextLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

@objc func enumeratePublicPrivateSegmentControl(){
   if pubicPrivateSegmentedControl.selectedSegmentIndex == 0 {
    newPostViewController?.accessiblility = "public"
    publicPrivateDetailTextLabel.text = "This post is by default public.It will be visible to everyone in explore tab."
   }else{
    newPostViewController?.accessiblility = "private"
    publicPrivateDetailTextLabel.text = "The post is no longer visible in expore tab.Only your followers can view it"
    }
}
    
     var hideView: Bool = false {
        didSet{
            if hideView {
                morningPostImageView.isHidden = true
                eveningPostImageView.isHidden = true
                nightPostImageView.isHidden = true
                self.backgroundColor = UIColor(white: 1, alpha: 0.5)
            }else {
                postPrivacyContainerView.isHidden = true
                morningPostImageView.isHidden = false
                eveningPostImageView.isHidden = false
                nightPostImageView.isHidden = false
                newPostViewController?.newPostButton.isEnabled = true
                self.backgroundColor = UIColor.clear
            }
        }
    }
}


class NewPostCell: UICollectionViewCell{
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

