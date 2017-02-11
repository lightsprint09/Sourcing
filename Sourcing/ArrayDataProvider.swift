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
//  ArrayDataProvider.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

import Foundation

/**
 `ArrayDataProvider` provides basic implementation to map arrays to an `DataProvider`.
 */
open class ArrayDataProvider<Object>: ArrayDataProviding, DataModifying {
    
    open var data: Array<Array<Object>>
    
    public var dataProviderDidUpdate: ProcessUpdatesCallback<Object>?
    /// Closure which gets called, when a data inside the provider changes and those changes should be propagated to the datasource.
    /// **Warning:** Only set this when you are updating the datasource.
    public var whenDataProviderChanged: ProcessUpdatesCallback<Object>?
    
    open var sectionIndexTitles: Array<String>?
   
    var canMoveItems: Bool = false
    var canDeleteItems: Bool = false
    
    // MARK: Initializers
    
    /**
     Creates an instance of`ArrayDataProvider` with an flat array which results in a single section.
     
     - parameter rows: single section of data.
     - parameter sectionTitle: title for the section. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public convenience init(rows: Array<Object>, sectionTitle: String? = nil) {
        var titles: Array<String>?
        if let sectionTitle = sectionTitle {
            titles = [sectionTitle]
        }
        self.init(sections: [rows], sectionIndexTitles: titles)
    }
    
    /**
     Creates an instance of`ArrayDataProvider` with an 2D array which results in a multiple sections.
     
     - parameter sections: 2D array.
     - parameter sectionTitles: titles for the sections. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public init(sections: [[Object]], sectionIndexTitles: Array<String>? = nil) {
        self.data = sections
        self.sectionIndexTitles = sectionIndexTitles
    }
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: flat array.
     - parameter updates: diff of the new data.
     - parameter causedByUserInteraction: flag if the changes are caused by a user
    */
    public func reconfigure(with array: Array<Object>, updates: Array<DataProviderUpdate<Object>>? = nil, causedByUserInteraction: Bool = false) {
        reconfigure(with: [array], updates: updates, causedByUserInteraction: causedByUserInteraction)
    }
    
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: 2D array.
     - parameter updates: diff of the new data.
     - parameter causedByUserInteraction: flag if the changes are caused by a user.
     */
    public func reconfigure(with array: Array<Array<Object>>, updates: Array<DataProviderUpdate<Object>>? = nil, causedByUserInteraction: Bool = false) {
        self.data = array
        if !causedByUserInteraction {
           dataProviderDidChangeContets(with: updates)
        }
    }
    
    func dataProviderDidChangeContets(with updates: [DataProviderUpdate<Object>]?) {
        dataProviderDidUpdate?(updates)
        whenDataProviderChanged?(updates)
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
    open func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, causedByUserInteraction: Bool) {
        let soureElement = object(at: sourceIndexPath)
        data[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        data[destinationIndexPath.section].insert(soureElement, at: destinationIndexPath.item)
        let update = DataProviderUpdate<Object>.move(sourceIndexPath, destinationIndexPath)
        if !causedByUserInteraction {
            dataProviderDidChangeContets(with: [update])
        }
        
    }
    
    open func canDeleteItem(at indexPath: IndexPath) -> Bool {
        return canDeleteItems
    }
    
    open func deleteItem(at indexPath: IndexPath, causedByUserInteraction: Bool) {
        data[indexPath.section].remove(at: indexPath.item)
        if !causedByUserInteraction {
            dataProviderDidChangeContets(with: [.delete(indexPath)])
        }
    }
    
}
