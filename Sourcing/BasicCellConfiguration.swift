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

import UIKit

public struct BasicCellConfiguration<CellToConfigure, ObjectOfCell>: CellConfiguring, StaticCellConfiguring {
    public typealias Cell = CellToConfigure
    public typealias Object = ObjectOfCell
    
    public let cellIdentifier: String
    public let nib: UINib?
    public let configuration: (Object, Cell) -> Void
    
    public init(cellIdentifier: String, configuration: @escaping (Object, Cell) -> Void, nib: UINib? = nil) {
        self.cellIdentifier = cellIdentifier
        self.configuration = configuration
        self.nib = nib
    }
    
    public func configure(_ cell: AnyObject, with object: Any) -> AnyObject {
        if let object = object as? Object, let cell = cell as? Cell {
            configuration(object, cell)
        }
        return cell
    }
}

extension BasicCellConfiguration where CellToConfigure: ConfigurableCell, CellToConfigure.DataSource == ObjectOfCell {
    public init(cellIdentifier: String, nib: UINib? = nil, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
        self.init(cellIdentifier: cellIdentifier, configuration: { object, cell in
            cell.configure(with: object)
            additionalConfiguration?(object, cell)
        }, nib: nib)
    }
}

extension BasicCellConfiguration where CellToConfigure: ConfigurableCell & CellIdentifierProviding, CellToConfigure.DataSource == ObjectOfCell {
    public init(nib: UINib? = nil, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
        self.init(cellIdentifier: CellToConfigure.cellIdentifier, nib: nib, additionalConfiguration: additionalConfiguration)
    }
}

extension BasicCellConfiguration where CellToConfigure: CellIdentifierProviding {
    public init(configuration: @escaping (Object, Cell) -> Void, nib: UINib? = nil) {
        self.init(cellIdentifier: CellToConfigure.cellIdentifier, configuration: configuration, nib: nib)
    }
}
