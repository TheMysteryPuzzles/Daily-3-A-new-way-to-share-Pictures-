//
//  BottomBarView.swift
//  Storify
//
//  Created by Work on 7/1/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

class BottomBar: UITabBar{
    
    var feedVc: FeedViewController!
    
   lazy var addNewPostBottomBarView: UIView = {
        let view = UIView()
    
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var addNewPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
      
        imageView.image = UIImage(named: "ic_addNewPost")
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNewPost)))
        imageView.contentMode = .scaleAspectFit

        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc func handleTrendingFeedTab(){
        self.feedVc.trendingAction()
    }
    @objc func handleHomeTab(){
        self.feedVc.homeAction()
    }
    
    @objc func handleNewPost(){
        self.feedVc.handleNewPost()
    }
    
    
    lazy var homeTab: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "ic_home")
         imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHomeTab)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var trendingTab: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "ic_trending_up")
      
         imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTrendingFeedTab)))
         imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var bottomBarStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [homeTab,addNewPostBottomBarView,trendingTab])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private func setupBottomBarStackViewConstraints(){
        bottomBarStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomBarStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomBarStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bottomBarStackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    private func setupAddNewPostImageViewConstraints(){
        addNewPostImageView.centerXAnchor.constraint(equalTo: addNewPostBottomBarView.centerXAnchor).isActive = true
        addNewPostImageView.centerYAnchor.constraint(equalTo: addNewPostBottomBarView.centerYAnchor).isActive = true
        addNewPostImageView.heightAnchor.constraint(equalTo: addNewPostBottomBarView.heightAnchor).isActive = true
        addNewPostImageView.widthAnchor.constraint(equalToConstant: addNewPostBottomBarView.frame.height).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.applyMainAppTheme()
        self.isUserInteractionEnabled = true
        addNewPostBottomBarView.addSubview(addNewPostImageView)
        setupAddNewPostImageViewConstraints()
    }
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        addSubview(bottomBarStackView)
        setupBottomBarStackViewConstraints()
        //addNewPostBottomBarView.addSubview(addNewPostImageView)
       // setupAddNewPostImageViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
