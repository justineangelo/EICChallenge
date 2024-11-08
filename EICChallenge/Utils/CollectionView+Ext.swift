//
//  CollectionView+Ext.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/7/24.
//

import Foundation
import UIKit

extension UICollectionView {
    func setAutomaticDimension() {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    func registerWithNib<T: UICollectionViewCell>(_ cell: T.Type) {
        let identifier = String(describing: T.self)
        register(UINib(nibName: identifier, bundle: .main), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cell: T.Type, atIndexPath indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
