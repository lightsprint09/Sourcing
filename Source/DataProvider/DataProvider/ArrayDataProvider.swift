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

import Foundation

/**
 `ArrayDataProvider` provides basic implementation to map arrays to a `DataProvider`.
 
 - seealso: `CollectionDataProvider`
 */
public final class ArrayDataProvider<ContentElement>: CollectionDataProvider {
    public typealias Element = ContentElement
    
    /// The content which is provided by the data provider
    public var content: [[Element]]
    
    /// An observable where one can subscribe to changes of data provider.
    public let observable: DataProviderObservable
    

    // MARK: Initializers
    
    /**
     Creates an instance of `ArrayDataProvider` with a flat collection which results a single section.
     
     - parameter rows: single section of content.
     */
    public convenience init(rows: [Element]) {
        self.init(sections: [rows])
    }
    
    /// Creates an empty `ArrayDataProvider`.
    public convenience init() {
        self.init(sections: [])
    }
    
    /**
     Creates an instance of`ArrayDataProvider` with an 2D array which results in a multiple sections.
     
     - parameter sections: 2D array.
     */
    public init(sections: [[Element]]) {
        self.content = sections
        observable = DataProviderObservable()
    }
    
    // MARK: Reconfiguration
    
    /**
     Reconfigures the data provider with new content.
     
     - parameter array: flat array.
     - parameter change: diff of the new data.
    */
    public func reconfigure(with rows: [Element], change: DataProviderChange = .unknown) {
        reconfigure(with: [rows], change: change)
    }
    
    /**
     Reconfigures the data provider with new content.
     
     - parameter array: 2D array.
     - parameter change: diff of the new data.
     */
    public func reconfigure(with array: [[Element]], change: DataProviderChange = .unknown) {
        self.content = array
        dataProviderDidChangeContets(with: change)
    }
    
    private func dataProviderDidChangeContets(with change: DataProviderChange) {
        Task { await observable.send(updates: change) }
    }
    
}
