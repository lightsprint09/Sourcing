//
//  Copyright (C) 2017 Lukas Schmidt.
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
//  DataModifying.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 31.01.17.
//

import Foundation

public protocol DataModifying {
    /// Moves item from sourceIndexPath to destinationIndexPath
    ///
    /// - Parameters:
    ///   - sourceIndexPath: Source's IndexPath
    ///   - destinationIndexPath: Destination's IndexPath
    ///   - updateView: determins if the view should be updated.
    ///                 Pass `false` if someone else take care of updating the change into the view
    func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, updateView: Bool)
    
    /// Checks wethere item at an indexPath can be moved
    ///
    /// - Parameter indexPath: the indexPath to check for if it can be moved
    /// - Returns: if the item can be moved
    func canMoveItem(at indexPath: IndexPath) -> Bool
    
    /// Deleted item at a given indexPath
    ///
    /// - Parameters:
    ///   - indexPath: the indexPath you want to delete
    func deleteItem(at indexPath: IndexPath)
    
    /// Checks wethere item at an indexPath can be deleted
    ///
    /// - Parameter indexPath: the indexPath to check for if it can be deleted
    /// - Returns: if the item can be deleted
    func canDeleteItem(at indexPath: IndexPath) -> Bool
}
