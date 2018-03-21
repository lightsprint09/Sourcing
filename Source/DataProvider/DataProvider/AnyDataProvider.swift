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

/// Type erases a DataProvider.
///
/// - SeeAlso: `DataProvider`
public final class AnyDataProvider<Element>: DataProvider {
    
    /// An observable where one can subscribe to changes of the data provider.
    public var observable: DataProviderObservable

    private let objectAtIndexPath: (_ atIndexPath: IndexPath) -> Element
    private let numberOfItems: (_ inSextion: Int) -> Int
    private let numberOfSectionsCallback: () -> Int
    
    /// Type erases a DataProvider.
    ///
    /// - Parameter dataProvider: the data provider to type erase
    public init<D: DataProvider>(_ dataProvider: D) where Element == D.Element {
        objectAtIndexPath = { indexPath in
            return dataProvider.object(at: indexPath)
        }
        numberOfItems = { section in
            return dataProvider.numberOfItems(inSection: section)
        }
        numberOfSectionsCallback = {
            return dataProvider.numberOfSections()
        }
        self.observable = dataProvider.observable
    }
    
    /// Returns an object for a given index path.
    ///
    /// - Parameter indexPath: the index path to get the object for.
    /// - Returns: the object at the given index path.
    public func object(at indexPath: IndexPath) -> Element {
        return objectAtIndexPath(indexPath)
    }
    
    /// Returns the number of items in a given section.
    ///
    /// - Parameter section: the section.
    /// - Returns: number of items in the given section.
    public func numberOfItems(inSection section: Int) -> Int {
        return numberOfItems(section)
    }
    
    /// Return the number of sections.
    ///
    /// - Returns: the number of sections.
    public func numberOfSections() -> Int {
        return numberOfSectionsCallback()
    }
}
