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
    public struct StaticSupplementaryViewConfiguration<View: UICollectionReusableView, Object>: SupplementaryViewConfiguring {
        
        /// The cellIdentifier which will be used to register and deque the cell.
        public let reuseIdentifier: String
        public let supplementaryElementKind: String
        public let nib: UINib?
        
        private let configuration: ((View, IndexPath) -> Void)?
        
        public init(elementKind: String, reuseIdentifier: String, nib: UINib? = nil, configuration: ((View, IndexPath) -> Void)? = nil) {
            self.supplementaryElementKind = elementKind
            self.reuseIdentifier = reuseIdentifier
            self.configuration = configuration
            self.nib = nib
        }
        
        public func configure(_ view: AnyObject, at indexPath: IndexPath, with object: Any) -> AnyObject {
            if let view = view as? View {
                configuration?(view, indexPath)
            }
            return view
        }
        
        public func canConfigureView(with object: Any, ofKind kind: String) -> Bool {
            return kind == supplementaryElementKind && object is Object
        }
    }

    public typealias SupplementaryViewConfiguration<View: UICollectionReusableView> = StaticSupplementaryViewConfiguration<View, Any>
#endif
