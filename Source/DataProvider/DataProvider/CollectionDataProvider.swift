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
/// `CollectionDataProvider` provides an interface for data providers which rely on a collection as internal data structure.
/// By conforming to this protocol you get most of the `DataProvider` requirements already implemented.
///
/// - SeeAlso: `ArrayDataProvider`
/// - SeeAlso: `AnyCollectionDataProvider`
public protocol CollectionDataProvider: DataProvider {
    associatedtype Container: Swift.Collection where Self.Container.Element: Collection, Self.Container.Element.Element == Self.Element
    
    /// The content which is provided by the data provider
    var content: Container { get }
}

public extension CollectionDataProvider {
    /// Return the number of sections.
    ///
    /// - Returns: the number of sections.
    func numberOfSections() -> Int {
        return content.count
    }
}

public extension CollectionDataProvider where Container.Index == Int,
                                            Container.Element.Index == Int {
    
    /// Returns an object for a given index path.
    ///
    /// - Parameter indexPath: the index path to get the object for.
    /// - Returns: the object at the given index path.
    func object(at indexPath: IndexPath) -> Element {
        return content[indexPath.section][indexPath.item]
    }

    /// Returns the number of items in a given section.
    ///
    /// - Parameter section: the section.
    /// - Returns: number of items in the given section.
    func numberOfItems(inSection section: Int) -> Int {
        return content[section].count
    }
}

public extension CollectionDataProvider where Element: Equatable {
    
    /**
     Returns the indexPath for a given object.
     
     - parameter object: the object to find the indexPath for.
     - return: the indexPath of the object, if available.
     */
    func indexPath(for object: Element) -> IndexPath? {
        for section in  0..<numberOfSections() {
            for item in 0..<numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let lookedUpObject = self.object(at: indexPath)
                if lookedUpObject == object {
                    return indexPath
                }
            }
        }
        
        return nil
    }
}
