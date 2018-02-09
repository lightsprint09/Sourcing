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

// The reusable view configuration can decide if it can configure a given view with an object or not.
/// If matching, it is able to configure the view with the object.
///
/// - Note: Dequeuing a view is not part of configuration.
/// - SeeAlso: `ReusableViewConfiguration`
public protocol ReusableViewConfiguring {
    
    /// The reusable view type which should be configured.
    associatedtype View
    /// The Object type which should configure the reusable view.
    associatedtype Object
    
    /// The type of the reusable view.
    var type: ReusableViewType { get }
    
    /// The reuse identifier for the given object
    /// which will be used deque the view.
    ///
    /// - Parameter object: the object
    /// - Returns: reuse identifier which fits to object
    func reuseIdentifier(for object: Object) -> String
    
    /// Configures the given view with at the index path with the given object.
    ///
    /// - Parameters:
    ///   - view: the view to configure
    ///   - indexPath: index path of the view
    ///   - object: the object which relates to the view
    func configure(_ view: View, at indexPath: IndexPath, with object: Object)
}
