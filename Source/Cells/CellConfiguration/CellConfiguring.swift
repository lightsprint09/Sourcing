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
//  CellConfiguring.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//
import UIKit

/// A cell configuration can decide if it can configure a given cell with an object or not. If `true` it can configure the cell with the object.
/// A configuration can be registered at the collection view / table view with the configurations nib and reuse identifier for later dequeuing.
///
/// - Note: Dequeuing a cell is not part of a configuration.
/// - Note: `CellConfiguring` is loosly typed, for useage in dynamic Collection/TableViews. Use `StaticCellConfiguring` when possible for more compiler support.
/// - SeeAlso: `StaticSupplementaryViewConfiguring`
public protocol CellConfiguring {
    /// The cellIdentifier which will be used to register and deque the cell.
    var reuseIdentifier: String { get }
    
    #if os(iOS) || os(tvOS)
    /// The nib which visualy represents the cell.
    var nib: UINib? { get }
    #endif
    
    /**
     Check if the cell can be used to display this specific object.
     
     - parameter object: The object which to check for.
     
     - return If the cell can be used for given object
     */
    func canConfigureCell(with object: Any) -> Bool
    
    /**
     Configures a given cell with an object.
     
     - parameter cell: The cell one want to configure.
     - parameter object: The object which to configure the cell with.
    */
    func configure(_ cell: AnyObject, with object: Any)
}
