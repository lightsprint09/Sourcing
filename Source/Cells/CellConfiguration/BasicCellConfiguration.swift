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

/// A cell configuration can decide if it can configure a given cell with an object or not. If `true` it can configure the cell with the object.
/// A configuration can be registered at the collection view / table view with the configurations nib and reuse identifier for later dequeuing.
///
/// - Note: Dequeuing a cell is not part of a configuration.
/// - SeeAlso: `StaticSupplementaryViewConfiguring`
/// - SeeAlso: `CellConfiguring`
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
    public func configure(_ cell: AnyObject, with object: Any) {
        guard let object = object as? Object, let cell = cell as? Cell else {
            return
        }
        configuration(object, cell)
    }
    
    #if os(iOS) || os(tvOS)
    
    /// Creates an instance of `BasicCellConfiguration`.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing cells
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - configuration: a block to configure the cell with the given object.
    public init(reuseIdentifier: String, nib: UINib? = nil, configuration: @escaping (Object, Cell) -> Void) {
        self.reuseIdentifier = reuseIdentifier
        self.configuration = configuration
        self.nib = nib
    }
    #else
    /// Creates an instance of `BasicCellConfiguration`.
    ///
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing cells
    ///   - configuration: a block to configure the cell with the given object.
    public init(reuseIdentifier: String, configuration: @escaping (Object, Cell) -> Void) {
        self.reuseIdentifier = reuseIdentifier
        self.configuration = configuration
    }
    #endif
}

#if os(iOS) || os(tvOS)

    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing cells
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension BasicCellConfiguration where CellToConfigure: ConfigurableCell, CellToConfigure.ObjectToConfigure == ObjectOfCell {
        public init(reuseIdentifier: String, nib: UINib? = nil, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
            self.init(reuseIdentifier: reuseIdentifier, nib: nib, configuration: { object, cell in
                cell.configure(with: object)
                additionalConfiguration?(object, cell)
            })
        }
    }
    
    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    /// In addition it uses the `ReuseIdentifierProviding` as a reuse identifier.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - SeeAlso: `ReuseIdentifierProviding`
    /// - Parameters:
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension BasicCellConfiguration where CellToConfigure: ConfigurableCell & ReuseIdentifierProviding, CellToConfigure.ObjectToConfigure == ObjectOfCell {
        public init(nib: UINib? = nil, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
            self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, nib: nib, additionalConfiguration: additionalConfiguration)
        }
    }
#else

    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing cells
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension BasicCellConfiguration where CellToConfigure: ConfigurableCell, CellToConfigure.ObjectToConfigure == ObjectOfCell {
        public init(reuseIdentifier: String, additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
            self.init(reuseIdentifier: reuseIdentifier, configuration: { object, cell in
                cell.configure(with: object)
                additionalConfiguration?(object, cell)
            })
        }
    }

    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    /// In addition it uses the `ReuseIdentifierProviding` as a reuse identifier.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - SeeAlso: `ReuseIdentifierProviding`
    /// - Parameters:
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension BasicCellConfiguration where CellToConfigure: ConfigurableCell & ReuseIdentifierProviding, CellToConfigure.ObjectToConfigure == ObjectOfCell {
        public init(additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
            self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, additionalConfiguration: additionalConfiguration)
        }
    }

#endif
