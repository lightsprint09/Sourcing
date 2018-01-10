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

/// `DataProviding` provides the data in a way which is related to `UITableViewDataSource` or `UICollectionViewDataSource`.
/// It is generic over Object, which is the kind of data it provides.
public protocol DataProviding: class {
    
     /// Element is the kind of data `DataProviding` provides.
    associatedtype Element
    
    /// An observable where one can subscribe to changes of the data provider.
    var observable: DataProviderObservable { get }
    
    /// Returns an object for a given index path.
    ///
    /// - Parameter indexPath: the index path to get the object for.
    /// - Returns: the object at the given index path.
    func object(at indexPath: IndexPath) -> Element
    
    /// Returns the number of items in a given section.
    ///
    /// - Parameter section: the section.
    /// - Returns: number of items in the given section.
    func numberOfItems(inSection section: Int) -> Int
    
    /// Return the number of sections.
    ///
    /// - Returns: the number of sections.
    func numberOfSections() -> Int
    
}
