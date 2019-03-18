//
//  PostImageCell.swift
//  Storify
//
//  Created by Work on 10/6/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
protocol ItemHeightDelegate {
    func itemHeight()->CGSize
}
class PostImageCell: UICollectionViewCell {

    lazy var headerView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 26))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    private func createPath(pathFrame: CGRect) -> UIBezierPath {
        let radius = CGFloat(24.0)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (pathFrame.width/2) - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: (pathFrame.width/2), y: 0), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(0), clockwise: false)
        path.addLine(to: CGPoint(x: pathFrame.width, y: 0))
        path.addLine(to: CGPoint(x: pathFrame.width, y: pathFrame.height))
        path.addLine(to: CGPoint(x: 0, y: pathFrame.height))
        path.close()
        return path
    }
    private func setupPostImageViewConstraints(){
        postImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 26).isActive = true
        postImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        postImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    override init(frame: CGRect) {
       
     super.init(frame: frame)
    addSubview(headerView)
   headerView.addMask(createPath(pathFrame: headerView.frame), frame: headerView.frame)
    addSubview(postImageView)
    setupPostImageViewConstraints()
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




