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
//  StaticCellConfiguring.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

/// `StaticCellConfiguring` provides a more static typed cell abstraction. See `CellConfiguring` for basic information
public protocol StaticCellConfiguring: CellConfiguring {
    /// The type of object which should be displayed in the cell.
    associatedtype Object
    
    /// The cell which should display the object.
    associatedtype Cell
}

extension StaticCellConfiguring {
    
    /// Check if the cell can be used to display this specific object. It compares the static `Self.Object` with the dynamically given `object type`.
    ///
    /// - Parameter object: the object to compare to the static `Self.Object`.
    /// - Returns: if match succeeds
    public func canConfigureCell(with object: Any) -> Bool {
        return object is Object
    }
}
