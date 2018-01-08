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
#if os(iOS) || os(tvOS)
    /// The supplementary view configuration can decide if it can configure a given suplementary view with an object or not.
    /// If `true` it can configure the view with the object. A configuration can be registered at the collection view with the configurations nib,
    /// reuse identifier and element kind for later dequeuing.
    ///
    /// - Note: By conforming to `StaticSupplementaryViewConfiguring` it can be statically proofen that a view and object matches each other.
    /// - Note: Dequeuing a view is not part of configuration.
    /// - SeeAlso: `SupplementaryViewConfiguring`
    /// - SeeAlso: `StaticSupplementaryViewConfiguring`
    public struct BasicSupplementaryViewConfiguration<ReuseableView: UICollectionReusableView, ObjectInSection>: StaticSupplementaryViewConfiguring {
        
        public typealias View = ReuseableView
        public typealias Object = ObjectInSection
        
        /// The reuse identifier which will be used to register and deque the cell.
        public let reuseIdentifier: String
        
        /// the element kind of the supplementary view.
        public let supplementaryElementKind: String
        
        /// The nib which visualy represents supplementary view.
        public let nib: UINib?
        
        private let configuration: ((View, IndexPath, Object) -> Void)?
        
        /// Creats an instance of `BasicSupplementaryViewConfiguration` which represents a View Configuration configuration.
        ///
        /// - Parameters:
        ///   - elementKind: the element kind of the supplementary view
        ///   - reuseIdentifier: the reuse identifier kind of the supplementary view
        ///   - nib: the nib which represents the view visually. Defaults to nil.
        ///   - configuration: configuration block to configure the view after dequeing. Defaults to nil.
        public init(elementKind: String, reuseIdentifier: String, nib: UINib? = nil, configuration: ((View, IndexPath, Object) -> Void)? = nil) {
            self.supplementaryElementKind = elementKind
            self.reuseIdentifier = reuseIdentifier
            self.configuration = configuration
            self.nib = nib
        }
        
        /// Configures the given view with the index path and the object.
        ///
        /// - Parameters:
        ///   - view: the view to configure
        ///   - indexPath: index path of the view
        ///   - object: the object which relates to the view
        public func configure(_ view: UICollectionReusableView, at indexPath: IndexPath, with object: Any) {
            guard let view = view as? View, let object = object as? Object else {
                return
            }
            configuration?(view, indexPath, object)
        }
    }
#endif
