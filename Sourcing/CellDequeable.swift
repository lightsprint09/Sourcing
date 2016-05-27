//
//  CellDequeable.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 25.05.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit

public protocol CellDequeable {
    var cellIdentifier: String { get }
    var nib: UINib? { get }
    
    func dequeueReusableCell(collectionView: UICollectionView, indexPath: NSIndexPath, object: Any) ->  UICollectionViewCell?
    func canConfigurecellForItem(object: Any) -> Bool
    func configureCell(cell: UICollectionViewCell, object: Any) -> UICollectionViewCell
}

public protocol StaticCellDequeable: CellDequeable {
    associatedtype Object
    associatedtype Cell: UICollectionViewCell
}