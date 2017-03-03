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
//  DataProviding.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

import Foundation

public typealias ProcessUpdatesCallback<Object> = ([DataProviderUpdate<Object>]?) -> Void

/// `DataProviding` provides the data in a way which is related to `UITableViewDataSource` or `UICollectionViewDataSource`.
/// It is generic over Object, which is the kind of data it provides.
public protocol DataProviding: class {
    /**
     Element is the kind of data `DataProviding` provides.
     */
    associatedtype Element
    
    /**
     Returns the object for a given indexPath.
     
     - parameter indexPath: the indexPath
     */
    func object(at indexPath: IndexPath) -> Element
    
    /**
     Returns number of items for a given section.
     
     - return: number of items
     */
    func numberOfItems(inSection section: Int) -> Int
    
    /**
     Returns number of sections
     
     - return: number of sections
     */
    func numberOfSections() -> Int
    
    /**
     Section Index Titles for `UITableView`. Related to `UITableViewDataSource` method `sectionIndexTitlesForTableView`
     */
    var sectionIndexTitles: [String]? { get }
    
    var headerTitles: [String]? { get }
    
    func prefetchItems(at indexPaths: [IndexPath])
    
    func cancelPrefetchingForItems(at indexPaths: [IndexPath])
    
    /// Closure which gets called, when a data inside the provider changes and those changes should be propagated to the datasource.
    /// **Warning:** Only set this when you are updating the datasource.
    var whenDataProviderChanged: ProcessUpdatesCallback<Element>? { get set }
    
}

public extension DataProviding {
    var sectionIndexTitles: [String]? { return nil }
    
    var headerTitles: [String]? { return nil }
}

public extension DataProviding {
    
    func prefetchItems(at indexPaths: [IndexPath]) { }
    
    func cancelPrefetchingForItems(at indexPaths: [IndexPath]) { }

}

extension DataProviding where Element: Equatable {
    
    /**
     Returns the indexPath for a given object.
     
     - parameter object: the object you want the indexPath for.
     - return: the indexPath of the object, if available.
     */
    public func indexPath(for object: Element) -> IndexPath? {
        for section in  0..<numberOfSections() {
            for item in 0..<numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let o = self.object(at: indexPath)
                if o == object {
                    return indexPath
                }
            }
        }
        
        return nil
    }
}
