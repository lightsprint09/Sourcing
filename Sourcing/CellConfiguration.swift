//
//  CellConfiguration.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 25.05.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit

struct CellConfiguration<Object, Cell: UICollectionViewCell where Cell: ConfigurableCell, Cell.DataSource == Object>: CellDequeable {
    let cellIdentifier: String
    let nib: UINib?
    let additionalConfiguartion: ((Object, Cell) -> Void)?
    
    init(cellIdentifier: String, nib: UINib? = nil, additionalConfiguartion: ((Object, Cell) -> Void)? = nil) {
        self.cellIdentifier = cellIdentifier
        self.nib = nib
        self.additionalConfiguartion = additionalConfiguartion
    }
    
    func dequeueReusableCell(collectionView: UICollectionView, indexPath: NSIndexPath, object: Any) ->  UICollectionViewCell? {
        if object is Object {
            return collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        }
        return nil
    }
    
    func canConfigurecellForItem(object: Any) -> Bool {
        return object is Object
    }
    
    func configureCell(cell: AnyObject, object: Any) -> AnyObject {
        if let object = object as? Object, cell = cell as? Cell {
            cell.configureForObject(object)
            additionalConfiguartion?(object, cell)
        }
        return cell
    }
}