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
 `ArrayDataProvider` provides basic implementation to map arrays to a `DataProviding`.
 
 - seealso: `ArrayDataProviding`
 */
public final class ArrayDataProvider<ContentElement>: ArrayDataProviding {
    public typealias Element = ContentElement
    
    /// The content which is provided by the data provider
    public var content: [[Element]]
    
    /// An observable where you can list on changes for the data provider.
    public var observable: DataProviderObservable {
        return defaultObservable
    }
    
    private let defaultObservable: DefaultDataProviderObservable
    
    // MARK: Initializers
    
    /**
     Creates an instance of `ArrayDataProvider` with a flat collection which results a single section.
     
     - parameter rows: single section of data.
     - parameter sectionTitle: title for the section. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public convenience init<Rows: Collection>(rows: Rows)
        where Rows.Iterator.Element == Element {
        self.init(sections: [Array(rows)])
    }
    
    /**
     Creates an instance of`ArrayDataProvider` with an 2D array which results in a multiple sections.
     
     - parameter sections: 2D array.
     - parameter sectionTitles: titles for the sections. nil by default.
     - parameter dataProviderDidUpdate: handler for recieving updates when datasource chnages. nil by default.
     */
    public init(sections: [[Element]]) {
        self.content = sections
        defaultObservable = DefaultDataProviderObservable()
    }
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: flat array.
     - parameter updates: diff of the new data.
     - parameter updateView: flag if the change of data is already set in the TableView.
    */
    public func reconfigure<Rows: Collection>(with rows: Rows, change: DataProviderChange = .unknown, updateView: Bool = true)
        where Rows.Iterator.Element == Element {
        reconfigure(with: [Array(rows)], change: change, updateView: updateView)
    }
    
    /**
     Reconfigures the dataSource with new data.
     
     - parameter array: 2D array.
     - parameter updates: diff of the new data.
     - parameter updateView: flag if the change of data is already set in the view.
     */
    public func reconfigure(with array: [[Element]], change: DataProviderChange = .unknown, updateView: Bool = true) {
        self.content = array
        dataProviderDidChangeContets(with: change, updateView: updateView)
    }
    
    private func dataProviderDidChangeContets(with updates: DataProviderChange, updateView: Bool = true) {
        defaultObservable.send(updates: updates)
    }
    
}
