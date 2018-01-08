//
//  Copyright (C) DB Systel GmbH.
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

public enum ReuseableViewType {
    case cell
    case supplementaryView(kind: String)
}

/// A supplementary view configuration can decide if it can configure a given suplementary view with an object or not.
/// If `true` it can configure the view with the object. A configuration can be registered at the collection view with the configurations nib,
/// reuse identifier and element kind for later dequeuing.
///
/// - Note: Dequeuing a view is not part of configuration.
/// - SeeAlso: `StaticSupplementaryViewConfiguring`
public protocol ReuseableViewConfiguring {
    
    /// The reuse identifier which will be used to register and deque the cell.
    var reuseIdentifier: String { get }
    /// the element kind of the supplementary view.
    var type: ReuseableViewType { get }
    
    /// The nib which visualy represents supplementary view.
    var nib: UINib? { get }
    
    /// Configures the given view with the index path and the object.
    ///
    /// - Parameters:
    ///   - view: the view to configure
    ///   - indexPath: index path of the view
    ///   - object: the object which relates to the view
    func configure(_ view: AnyObject, at indexPath: IndexPath, with object: Any)
    
    /// Decide if `Self` can configure a view with a given object and a kind.
    ///
    /// - Parameters:
    ///   - object: the object.
    ///   - ofKind: the kind.
    /// - Returns: if `Self` can configure the view.
    func canConfigureView(with object: Any, ofKind: String?) -> Bool
}

/// The supplementary view configuration can decide if it can configure a given suplementary view with an object or not.
/// If `true` it can configure the view with the object. A configuration can be registered at the collection view with the configurations nib,
/// reuse identifier and element kind for later dequeuing.
///
/// - Note: By conforming to `StaticSupplementaryViewConfiguring` it can be statically proofen that a view and object matches each other.
/// - SeeAlso: `SupplementaryViewConfiguring`
public protocol StaticReuseableViewConfiguring: ReuseableViewConfiguring {
    /// The supplementary view type which should be configured.
    associatedtype View
    /// The Object type which should confihure the supplementary view.
    associatedtype Object
}

extension StaticReuseableViewConfiguring {
    
    /// Default implementation for all static supplementary view configurations.
    /// It uses the static View type and matches it dynamically to the given object type.
    /// If they match and element kind is equal as well, `canConfigureView` reponds with `true`.
    ///
    /// - Parameters:
    ///   - object: object which gets dynamically compared to `Self.View`
    ///   - kind: element kind which should match with `supplementaryElementKind`
    /// - Returns: if matching succeeded
    public func canConfigureView(with object: Any, ofKind kind: String?) -> Bool {
        switch type {
        case .cell:
            return object is Object
        case .supplementaryView(let supplementaryElementKind):
            return kind == supplementaryElementKind && object is Object
        }
        
    }
}

/// The supplementary view configuration can decide if it can configure a given suplementary view with an object or not.
/// If `true` it can configure the view with the object. A configuration can be registered at the collection view with the configurations nib,
/// reuse identifier and element kind for later dequeuing.
///
/// - Note: By conforming to `StaticSupplementaryViewConfiguring` it can be statically proofen that a view and object matches each other.
/// - Note: Dequeuing a view is not part of configuration.
/// - SeeAlso: `SupplementaryViewConfiguring`
/// - SeeAlso: `StaticSupplementaryViewConfiguring`
public struct BasicReuseableViewConfiguration<ReuseableView, ObjectInSection>: StaticReuseableViewConfiguring {
    
    public typealias View = ReuseableView
    public typealias Object = ObjectInSection
    
    /// The reuse identifier which will be used to register and deque the cell.
    public let reuseIdentifier: String
    public var type: ReuseableViewType
    
    /// The nib which visualy represents supplementary view.
    public let nib: UINib?
    
    private let configuration: ((View, IndexPath, Object) -> Void)?
    
    public init(reuseIdentifier: String, type: ReuseableViewType, nib: UINib? = nil, configuration: ((View, IndexPath, Object) -> Void)? = nil) {
        self.reuseIdentifier = reuseIdentifier
        self.type = type
        self.nib = nib
        self.configuration = configuration
    }
    
    /// Configures the given view with the index path and the object.
    ///
    /// - Parameters:
    ///   - view: the view to configure
    ///   - indexPath: index path of the view
    ///   - object: the object which relates to the view
    public func configure(_ view: AnyObject, at indexPath: IndexPath, with object: Any) {
        guard let view = view as? View, let object = object as? Object else {
            return
        }
        configuration?(view, indexPath, object)
    }
}

#if os(iOS) || os(tvOS)
    
    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing cells
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension BasicReuseableViewConfiguration where ReuseableView: ReuseIdentifierProviding {
        public init(nib: UINib? = nil, configuration: @escaping ((ReuseableView, IndexPath, Object) -> Void)) {
            self.reuseIdentifier = ReuseableView.reuseIdentifier
            self.nib = nib
            self.type = .cell
            self.configuration = configuration
        }
    }
    
    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing cells
    ///   - nib: the nib which represents the cell visually. Defaults to `nil`.
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension BasicReuseableViewConfiguration where ReuseableView: ConfigurableCell, ReuseableView.ObjectToConfigure == Object {
        public init(reuseIdentifier: String, nib: UINib? = nil, additionalConfiguration: ((Object, ReuseableView) -> Void)? = nil) {
            self.reuseIdentifier = reuseIdentifier
            self.nib = nib
            self.type = .cell
            self.configuration = { view, _, object in
                view.configure(with: object)
                additionalConfiguration?(object, view)
            }
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
    extension BasicReuseableViewConfiguration where ReuseableView: ConfigurableCell & ReuseIdentifierProviding, ReuseableView.ObjectToConfigure == Object {
        public init(nib: UINib? = nil, additionalConfiguration: ((Object, ReuseableView) -> Void)? = nil) {
            self.init(reuseIdentifier: View.reuseIdentifier, type: .cell, nib: nib, configuration: { (cell, _, object) in
                cell.configure(with: object)
                additionalConfiguration?(object, cell)
            })
        }
    }
#else
    
    /// Creates an instance of `BasicCellConfiguration`. And using the protocol implementation of `ConfigurableCell.configure` for configuration.
    ///
    /// - SeeAlso: `ConfigurableCell`
    /// - Parameters:
    ///   - reuseIdentifier: the reuse identifier for registering & dequeuing cells
    ///   - additionalConfiguration: a block to additionally configure the cell with the given object. Defaults to `nil`.
    extension BasicReuseableViewConfiguring where CellToConfigure: ConfigurableCell, CellToConfigure.ObjectToConfigure == ObjectOfCell {
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
    extension BasicReuseableViewConfiguring where CellToConfigure: ConfigurableCell & ReuseIdentifierProviding,
    CellToConfigure.ObjectToConfigure == ObjectOfCell {
        public init(additionalConfiguration: ((Object, Cell) -> Void)? = nil) {
            self.init(reuseIdentifier: CellToConfigure.reuseIdentifier, additionalConfiguration: additionalConfiguration)
        }
    }
    
#endif
