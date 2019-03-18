//  Copyright © 2018 TheMysteryPuzzles.

import UIKit

@objc public protocol SubCollectionViewDelegate: class {
    
    
    @objc optional func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    @objc optional func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
    
}
