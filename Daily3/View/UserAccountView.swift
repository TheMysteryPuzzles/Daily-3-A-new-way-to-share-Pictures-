//
//  UserAccountView.swift
//  Storify
//
//  Created by Work on 5/28/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

class UserAccountView: UIView {
    
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.frame.minY, width: self.frame.width, height: self.frame.height * 0.2))
        
        view.backgroundColor = UIColor.green
        return view
    }()
    
    lazy var collectionViewLayout: UICollectionViewLayout = {
       let layout = UICollectionViewLayout()
       return layout
    }()
    
    lazy var collectionView: UICollectionView = {
       let cView = UICollectionView(frame: CGRect(x: 0, y: headerView.frame.maxY, width: self.frame.width, height: self.frame.height - headerView.frame.height), collectionViewLayout: collectionViewLayout)
        cView.backgroundColor = UIColor.purple
       return cView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
