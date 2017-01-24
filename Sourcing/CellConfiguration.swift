//
//  Copyright (C) 2016 Lukas Schmidt.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//
//  CellConfiguration.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//
import UIKit

public struct CellConfiguration<CellToConfigure: ConfigurableCell>: CellDequeable, StaticCellDequeable {
    public typealias Cell = CellToConfigure
    public typealias Object = Cell.DataSource
    
    public let cellIdentifier: String
    public let nib: UINib?
    
    let additionalConfiguartion: ((Object, Cell) -> Void)?
    
    public init(cellIdentifier: String, nib: UINib? = nil, additionalConfiguartion: ((Object, Cell) -> Void)? = nil) {
        self.cellIdentifier = cellIdentifier
        self.nib = nib
        self.additionalConfiguartion = additionalConfiguartion
    }
    
    public func canConfigureCell(with object: Any) -> Bool {
        return object is Object
    }
    
    public func configure(_ cell: AnyObject, with object: Any) -> AnyObject {
        if let object = object as? Object, let cell = cell as? Cell {
            cell.configure(with: object)
            additionalConfiguartion?(object, cell)
        }
        return cell
    }
}

extension CellConfiguration where CellToConfigure: CellIdentifierProviding {
    public init(nib: UINib? = nil, additionalConfiguartion: ((Object, Cell) -> Void)? = nil) {
        self.cellIdentifier = CellToConfigure.cellIdentifier
        self.nib = nib
        self.additionalConfiguartion = additionalConfiguartion
    }
}
