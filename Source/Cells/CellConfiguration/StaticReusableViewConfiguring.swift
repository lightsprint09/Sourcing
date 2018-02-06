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

/// The reusable view configuration can decide if it can configure a given view with an object or not.
/// If matching, it is able to configure the view with the object.
///
/// - Note: By conforming to `StaticReusableViewConfiguring` it can be statically proven that a view and object matches each other.
/// - SeeAlso: `ReusableViewConfiguring`
public protocol StaticReusableViewConfiguring: ReusableViewConfiguring {
    /// The reusable view type which should be configured.
    associatedtype View
    /// The Object type which should configure the reusable view.
    associatedtype Object
}

extension StaticReusableViewConfiguring {
    
    /// Default implementation for all static reusable view configurations.
    /// It uses the static view type and matches it dynamically to the given object type.
    /// If they match and element kind is equal as well, `canConfigureView` reponds with `true`.
    /// Patameter `kind` will only be used for comparison when view type is `.supplementaryView`.
    ///
    /// - Parameters:
    ///   - kind: element kind which should match with `supplementaryElementKind`.
    ///   - object: object which gets dynamically compared to `Self.View`
    /// - Returns: if matching succeeded
    public func canConfigureView(ofKind kind: String?, with object: Any) -> Bool {
        switch type {
        case .cell:
            return object is Object
        case .supplementaryView(let supplementaryElementKind):
            return kind == supplementaryElementKind && object is Object
        }
        
    }
}
