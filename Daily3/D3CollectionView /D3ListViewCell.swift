//  Copyright © 2018 TheMysteryPuzzles.


import UIKit

@objc open class D3ListViewCell: UICollectionViewCell {
    
    open var subdataSource: SubCollectionViewDataSource!
    open var subDelegate: SubCollectionViewDelegate?
    open var indexPath: Int?
    open var subCollectionViewItemSize: CGSize?
    private var subCollectionViewFrame: CGRect?
    open var changeTimeOfTheDayImage: ((UIImage) -> Void)?
    
    
    lazy var subCollectionViewFlowLayout: SubCollectionViewFlowLayout = {
        let flowLayout = SubCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemAlpha = 1.0
        flowLayout.sideItemScale = 0.9
        flowLayout.spacingMode = SpacingMode.overlap(visibleOffset: 100)
        return flowLayout
    }()
    
    
    
    lazy private var subCollectionView : UICollectionView = {
        let frame = CGRect(x: 0, y: (self.frame.height*0.2)+5, width: self.frame.width, height: self.frame.height - ((self.frame.height*0.2) + 30))
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: subCollectionViewFlowLayout)
        collectionView.collectionViewLayout = subCollectionViewFlowLayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    public func addSubCollectionView(index: Int){
        subCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        subCollectionView.delegate = self
        subCollectionView.backgroundColor = UIColor.clear
        subCollectionView.dataSource = self
        subCollectionView.tag = index
        self.addSubview(subCollectionView)
        subCollectionView.reloadData()
        
      }
    
     public func registerSubCollectionView(_ cellClass: AnyClass? , forCellWithReuseIdentifier identifier: String){
        self.subCollectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func scrollSubCollectionView(at: IndexPath, scrollPosition: UICollectionViewScrollPosition, animated: Bool){
        self.subCollectionView.scrollToItem(at: at, at: scrollPosition, animated: animated)
    }
    
    public func register(nib: UINib?, forCellWithReuseIdentifier identifier: String){
        self.subCollectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
 
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension D3ListViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    public func scrollViewDidEndDecelerating(_: UIScrollView){
      
        let test =  CGPoint(x: self.subCollectionView.center.x + self.subCollectionView.contentOffset.x,y:
                                                   self.subCollectionView.center.y + self.subCollectionView.contentOffset.y)
        
        var centerCellIndexPath: IndexPath? = subCollectionView.indexPathForItem(at: test)
        //self.convert(self.center, to: subCollectionView)
        switch centerCellIndexPath?.item {
        case 0: changeTimeOfTheDayImage!(UIImage(named: "ic_comment")!)
        print("1")
        case 1: changeTimeOfTheDayImage!(UIImage(named: "ic_search")!)
        print("2")
        case 2: changeTimeOfTheDayImage!(UIImage(named: "ic_delete")!)
        print("3")
        default:
            break
        }
    }
  
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (subdataSource?.collectionView(collectionView, numberOfItemsInSection: section))!
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (subdataSource?.collectionView(collectionView, cellForItemAt: indexPath))!
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        subDelegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.subDelegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
}


