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

/// Type eareses a DataProviding.
final public class AnyDataProvider<Element>: DataProviding {
    
    /// An observable where you can list on changes for the data provider.
    public var observable: DataProviderObservable

    private let objectAtIndexPath: (_ atIndexPath: IndexPath) -> Element
    private let numberOfItems: (_ inSextion: Int) -> Int
    private let numberOfSectionsCallback: () -> Int
    
    private let prefetchItemsAtIndexPaths: ([IndexPath]) -> Void
    private let cancelPrefetchingForItemsAtIndexPaths: ([IndexPath]) -> Void
    
    /// Type eareses a DataProviding.
    ///
    /// - Parameter dataProvider: the data provider to type erase
    public init<DataProvider: DataProviding>(_ dataProvider: DataProvider) where Element == DataProvider.Element {
        objectAtIndexPath = { indexPath in
            return dataProvider.object(at: indexPath)
        }
        numberOfItems = { section in
            return dataProvider.numberOfItems(inSection: section)
        }
        numberOfSectionsCallback = {
            return dataProvider.numberOfSections()
        }
        prefetchItemsAtIndexPaths = { indexPaths in
            dataProvider.prefetchItems(at: indexPaths)
        }
        cancelPrefetchingForItemsAtIndexPaths = { indexPaths in
            dataProvider.cancelPrefetchingForItems(at: indexPaths)
        }
        self.observable = dataProvider.observable
    }
    
    /**
     Returns the object for a given indexPath.
     
     - parameter indexPath: the indexPath
     */
    public func object(at indexPath: IndexPath) -> Element {
        return objectAtIndexPath(indexPath)
    }
    
    /**
     Returns number of items for a given section.
     
     - return: number of items
     */
    public func numberOfItems(inSection section: Int) -> Int {
        return numberOfItems(section)
    }
    
    /**
     Returns number of sections
     
     - return: number of sections
     */
    public func numberOfSections() -> Int {
        return numberOfSectionsCallback()
    }
    
    /// Prefetch items into the data provider
    ///
    /// - Parameter indexPaths: a list of indexPaths to prefetch
    public func prefetchItems(at indexPaths: [IndexPath]) {
        prefetchItemsAtIndexPaths(indexPaths)
    }
    
    /// Prefetch items into the data provider
    ///
    /// - Parameter indexPaths: a list of indexPaths to prefetch
    public func cancelPrefetchingForItems(at indexPaths: [IndexPath]) {
        cancelPrefetchingForItemsAtIndexPaths(indexPaths)
    }
}
