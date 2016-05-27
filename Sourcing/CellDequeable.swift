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
        
    func canConfigurecellForItem(object: Any) -> Bool
    func configureCell(cell: AnyObject, object: Any) -> AnyObject
}

public protocol StaticCellDequeable: CellDequeable {
    associatedtype Object
    associatedtype Cell
}