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
//  DataProviderMock.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 10.01.17.
//

import Foundation
import Sourcing

/**
 `ArrayDataProvider` provides basic implementation to map arrays to an `DataProvider`.
 */
open class DataProviderMock<Object>: NSObject, ArrayDataProviding {
    /// Closure which gets called, when a data inside the provider changes and those changes should be propagated to the datasource.
    /// **Warning:** Only set this when you are updating the datasource.
    public var whenDataProviderChanged: (([DataProviderUpdate<Object>]?) -> Void)?

    fileprivate(set) open var data: [[Object]] = [[]]
    public let sectionIndexTitles: [String]? = []
    
    var prefetchedIndexPaths: [IndexPath]?
    var canceledPrefetchedIndexPaths: [IndexPath]?

    public func prefetchItems(at indexPaths: [IndexPath]) {
        prefetchedIndexPaths = indexPaths
    }
    
    public func cancelPrefetchingForItems(at indexPaths: [IndexPath]) {
        canceledPrefetchedIndexPaths = indexPaths
    }
}
