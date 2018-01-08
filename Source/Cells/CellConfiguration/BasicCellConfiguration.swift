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
    
    /// The reuse identifier which will be used to register and deque the cell.
    public let reuseIdentifier: String
    
    #if os(iOS) || os(tvOS)
    /// The nib which represents the cell
    public let nib: UINib?
    #endif
    private let configuration: (Object, Cell) -> Void
    
    /**
     Configures a given cell with an object.
     
     - parameter cell: The cell one want to configure.
     - parameter object: The object which to configure the cell with.
     
     - return The configured cell
     */
    public func configure(_ cell: AnyObject, with object: Any) -> AnyObject {
        if let object = object as? Object, let cell = cell as? Cell {
            configuration(object, cell)
        }
        return cell
    }
    
    #if os(iOS) || os(tvOS)
    public init(reuseIdentifier: String, nib: UINib? = nil, configuration: @escaping (Object, Cell) -> Void) {
        self.reuseIdentifier = reuseIdentifier
        self.configuration = configuration
        self.nib = nib
    }
    #else
    public init(reuseIdentifier: String, configuration: @escaping (Object, Cell) -> Void) {
        self.reuseIdentifier = reuseIdentifier
        self.configuration = configuration
    }
    #endif
}

#if os(iOS) || os(tvOS)
    
extension BasicCellConfiguration where CellToConfigure: ConfigurableCell, CellToConfigure.ObjectToConfigure == ObjectOfCell {
    public init(reuseIdentifier: String, nib: UINib? = nil, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
        self.init(reuseIdentifier: reuseIdentifier, nib: nib, configuration: { object, cell in
            cell.configure(with: object)
            additionalConfiguration?(object, cell)
        })
    }
}

extension BasicCellConfiguration where CellToConfigure: ConfigurableCell & ReuseIdentifierProviding, CellToConfigure.ObjectToConfigure == ObjectOfCell {
    public init(nib: UINib? = nil, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
        self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, nib: nib, additionalConfiguration: additionalConfiguration)
    }
}

extension BasicCellConfiguration where CellToConfigure: ReuseIdentifierProviding {
    public init(configuration: @escaping (Object, Cell) -> Void, nib: UINib? = nil) {
        self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, nib: nib, configuration: configuration)
    }
}
#else

extension BasicCellConfiguration where CellToConfigure: ConfigurableCell, CellToConfigure.DataSource == ObjectOfCell {
    public init(reuseIdentifier: String, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
        self.init(reuseIdentifier: reuseIdentifier, configuration: { object, cell in
            cell.configure(with: object)
            additionalConfiguration?(object, cell)
        })
    }
}

extension BasicCellConfiguration where CellToConfigure: ConfigurableCell & ReuseIdentifierProviding, CellToConfigure.DataSource == ObjectOfCell {
    public init(additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
        self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, additionalConfiguration: additionalConfiguration)
    }
}

extension BasicCellConfiguration where CellToConfigure: ReuseIdentifierProviding {
    public init(configuration: @escaping (Object, Cell) -> Void) {
        self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, configuration: configuration)
    }
}

#endif
