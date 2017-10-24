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

public final class ArrayDataProviderModifier<Element>: DataModifying {
    public var canMoveItems: Bool = false
    public var canDeleteItems: Bool = false
    
    private let dataProvider: ArrayDataProvider<Element>
    
    public init(dataProvider: ArrayDataProvider<Element>) {
        self.dataProvider = dataProvider
    }
    
    // MARK: Data Modification
    
    open func canMoveItem(at indexPath: IndexPath) -> Bool {
        return canMoveItems
    }
    
    /**
     Update item position in dataSource.
     
     - parameter sourceIndexPath: original indexPath.
     - parameter destinationIndexPath: destination indexPath.
     */
    open func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, updateView: Bool = false) {
        let soureElement = dataProvider.object(at: sourceIndexPath)
        var content = dataProvider.content
        content[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        content[destinationIndexPath.section].insert(soureElement, at: destinationIndexPath.item)
        let update = DataProviderChange.Change.move(sourceIndexPath, destinationIndexPath)
        dataProvider.reconfigure(with: content, change: .changes([update]), updateView: updateView)
    }
    
    open func canDeleteItem(at indexPath: IndexPath) -> Bool {
        return canDeleteItems
    }
    
    open func deleteItem(at indexPath: IndexPath, updateView: Bool = false) {
        var content = dataProvider.content
        content[indexPath.section].remove(at: indexPath.item)
        dataProvider.reconfigure(with: content, change: .changes([.delete(indexPath)]), updateView: updateView)
    }
}
