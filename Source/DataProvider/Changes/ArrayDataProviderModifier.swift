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

import Foundation

/**
Wrapps an `ArrayDataProvider` and handles changes to manipulate the content of the provider.
 
- seealso: `DataModifying`
*/
@MainActor
public final class ArrayDataProviderModifier<Element>: DataModifying {
    /// Flag if items can be moved by the data source.
    public var canMoveItems: Bool = false
    
    /// Flag if items can be edited by the data source.
    public var canEditItems: Bool = false
    
    private let dataProvider: ArrayDataProvider<Element>
    
    private let createElement: (() -> Element)?
    
    /// Creates an `ArrayDataProvider` instance.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider which should be modifiable
    ///   - canMoveItems: Flag if items can be moved by the data source.
    ///   - canEditItems: Flag if items can be edited by the data source.
    public init(dataProvider: ArrayDataProvider<Element>, canMoveItems: Bool = false, canEditItems: Bool = false, createElement: (() -> Element)? = nil) {
        self.dataProvider = dataProvider
        self.canMoveItems = canMoveItems
        self.canEditItems = canEditItems
        self.createElement = createElement
    }
    
    /// Checks whether item at an indexPath can be moved
    ///
    /// - Parameter indexPath: the indexPath to check for if it can be moved
    /// - Returns: if the item can be moved
    public func canMoveItem(at indexPath: IndexPath) -> Bool {
        return canMoveItems
    }
    
    /// Moves item from sourceIndexPath to destinationIndexPath
    ///
    /// - Parameters:
    ///   - sourceIndexPath: Source's IndexPath
    ///   - destinationIndexPath: Destination's IndexPath
    ///   - updateView: determines if the view should be updated.
    ///                 Pass `false` if someone else take care of updating the change into the view
   public func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, updateView: Bool = true) {
        let soureElement = dataProvider.object(at: sourceIndexPath)
        var content = dataProvider.content
        content[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        content[destinationIndexPath.section].insert(soureElement, at: destinationIndexPath.item)
        let update = DataProviderChange.Change.move(sourceIndexPath, destinationIndexPath)
        let changes: DataProviderChange = updateView ? .changes([update]) : .viewUnrelatedChanges([update])
        dataProvider.reconfigure(with: content, change: changes)
    }
    
    /// Checks wethere item at an indexPath can be edited
    ///
    /// - Parameter indexPath: the indexPath to check for if it can be edited
    /// - Returns: if the item can be edited
    public func canEditItem(at indexPath: IndexPath) -> Bool {
        return canEditItems
    }
    
    /// Deleted item at a given indexPath
    ///
    /// - Parameters:
    ///   - indexPath: the indexPath to delete
    public func deleteItem(at indexPath: IndexPath) {
        var content = dataProvider.content
        content[indexPath.section].remove(at: indexPath.item)
        dataProvider.reconfigure(with: content, change: .changes([.delete(indexPath)]))
    }
    
    /// Inserts an element at given indexPath
    ///
    /// - Parameter: indexPath: the indexPath to insert
    public func insertItem(at indexPath: IndexPath) {
        guard let createElement = createElement else {
            return
        }
        var content = dataProvider.content
        let newElement = createElement()
        content[indexPath.section].insert(newElement, at: indexPath.item)
        dataProvider.reconfigure(with: content, change: .changes([.insert(indexPath)]))
    }
}
