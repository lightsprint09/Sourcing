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
open class ArrayDataProvider<Element>: ArrayDataProviding, DataModifying {
    
    open var contents: [[Element]]
    
    public var dataProviderDidUpdate: ProcessUpdatesCallback<Element>?
    /// Closure which gets called, when a data inside the provider changes and those changes should be propagated to the datasource.
    /// **Warning:** Only set this when you are updating the datasource.
    public var whenDataProviderChanged: ProcessUpdatesCallback<Element>?
    
    open var headerTitles: [String]?
    open var sectionIndexTitles: [String]?
   
    public var canMoveItems: Bool = false
    public var canDeleteItems: Bool = false
    
    // MARK: Initializers
    
    /**
     Creates an instance of`ArrayDataProvider` with an flat array which results in a single section.
     
     - parameter rows: single section of data.
     - parameter sectionTitle: title for the section. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public convenience init(rows: [Element], headerTitle: String? = nil) {
        self.init(sections: [rows], headerTitles: headerTitle.map { [$0] })
    }
    
    /**
     Creates an instance of`ArrayDataProvider` with an 2D array which results in a multiple sections.
     
     - parameter sections: 2D array.
     - parameter sectionTitles: titles for the sections. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public init(sections: [[Element]], headerTitles: [String]? = nil, sectionIndexTitles: [String]? = nil) {
        self.contents = sections
        self.sectionIndexTitles = sectionIndexTitles
        self.headerTitles = headerTitles
    }
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: flat array.
     - parameter updates: diff of the new data.
     - parameter triggerdByTableView: flag if the change of data is already set in the TableView.
    */
    public func reconfigure(with array: [Element], updates: [DataProviderUpdate<Element>]? = nil, triggerdByTableView: Bool = false) {
        reconfigure(with: [array], updates: updates, triggerdByTableView: triggerdByTableView)
    }
    
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: 2D array.
     - parameter updates: diff of the new data.
     - parameter triggerdByTableView: flag if the change of data is already set in the TableView..
     */
    public func reconfigure(with array: [[Element]], updates: [DataProviderUpdate<Element>]? = nil, triggerdByTableView: Bool = false) {
        self.contents = array
        dataProviderDidChangeContets(with: updates, triggerdByTableView: triggerdByTableView)
    }
    
    func dataProviderDidChangeContets(with updates: [DataProviderUpdate<Element>]?, triggerdByTableView: Bool = false) {
        if !triggerdByTableView {
            whenDataProviderChanged?(updates)
        }
        dataProviderDidUpdate?(updates)
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
    open func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, triggerdByTableView: Bool = false) {
        let soureElement = object(at: sourceIndexPath)
        contents[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        contents[destinationIndexPath.section].insert(soureElement, at: destinationIndexPath.item)
        let update = DataProviderUpdate<Element>.move(sourceIndexPath, destinationIndexPath)
        dataProviderDidChangeContets(with: [update], triggerdByTableView: triggerdByTableView)
    }
    
    open func canDeleteItem(at indexPath: IndexPath) -> Bool {
        return canDeleteItems
    }
    
    open func deleteItem(at indexPath: IndexPath, triggerdByTableView: Bool = false) {
        contents[indexPath.section].remove(at: indexPath.item)
        dataProviderDidChangeContets(with: [.delete(indexPath)], triggerdByTableView: triggerdByTableView)
    }
    
}
