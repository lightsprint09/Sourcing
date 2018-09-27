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

/// Takes a data provider and transforms it with a given closure into a new data provider with a different type.
///
/// - Note: Transformation will only execute when an object is requested by calling `object(at:)`.
public final class LazyTransformationDataProvider<TargetType>: DataProvider {
    
    // MARK: - Init
    
    public init<D: DataProvider>(dataProvider: D, transform: @escaping (D.Element) -> TargetType) {
        self.numberOfSection = { dataProvider.numberOfSections() }
        self.numberOfElements = { dataProvider.numberOfItems(inSection: $0) }
        self.objectAtIndexPath = { transform(dataProvider.object(at: $0)) }
        self.observable = dataProvider.observable
    }
    
    // MARK: - Protocol DataProvider
    
    /// An observable where one can subscribe to changes of data provider.
    public var observable: DataProviderObservable
    
    /// Returns an object for a given index path.
    ///
    /// - Parameter indexPath: the index path to get the object for.
    /// - Returns: the object at the given index path.
    public func object(at indexPath: IndexPath) -> TargetType {
        return objectAtIndexPath(indexPath)
    }
    
    /// Returns the number of items in a given section.
    ///
    /// - Parameter section: the section.
    /// - Returns: number of items in the given section.
    public func numberOfItems(inSection section: Int) -> Int {
        return numberOfElements(section)
    }
    
    /// Return the number of sections.
    ///
    /// - Returns: the number of sections.
    public func numberOfSections() -> Int {
        return numberOfSection()
    }
    
    // MARK: - Private
    
    private let objectAtIndexPath: (_ indexPath: IndexPath) -> TargetType
    private let numberOfSection: () -> Int
    private let numberOfElements: (_ inSection: Int) -> Int
    
}

extension DataProvider {
    
    /// Lazy transforms the content witha given closure into a new data provider
    ///
    /// - Parameter transform: the closure which transforms the element into the target value
    /// - Returns: a `LazyTransformationDataProvider` which provides the newly transformed objects.
    ///
    /// - SeeAlso: `LazyTransformationDataProvider`
    public func lazyTransform<TargetType>(_ transform: @escaping (Element) -> TargetType) ->
        LazyTransformationDataProvider<TargetType> {
            return LazyTransformationDataProvider(dataProvider: self, transform: transform)
    }
}
