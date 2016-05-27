//
//  CellConfiguration.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 25.05.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit

public struct CellConfiguration<DisplayObject, CCell where CCell: ConfigurableCell, CCell.DataSource == DisplayObject>: CellDequeable, StaticCellDequeable {
    public typealias Object = DisplayObject
    public typealias Cell = CCell
    public let cellIdentifier: String
    public let nib: UINib?
    let additionalConfiguartion: ((Object, Cell) -> Void)?
    
    public  init(cellIdentifier: String, nib: UINib? = nil, additionalConfiguartion: ((Object, Cell) -> Void)? = nil) {
        self.cellIdentifier = cellIdentifier
        self.nib = nib
        self.additionalConfiguartion = additionalConfiguartion
    }
    
    public  func canConfigurecellForItem(object: Any) -> Bool {
        return object is Object
    }
    
    public func configureCell(cell: AnyObject, object: Any) -> AnyObject {
        if let object = object as? Object, cell = cell as? Cell {
            cell.configureForObject(object)
            additionalConfiguartion?(object, cell)
        }
        return cell
    }
}