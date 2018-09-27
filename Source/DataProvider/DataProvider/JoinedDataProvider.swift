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

/// Takes multiple data provider and aggregates them into a single on.
public final class JoinedDataProvider<Element>: DataProvider {
    
    /// Creates an instance of `JoinedDataProvider` by aggregating all given data providers
    ///
    /// - Parameter dataProviders: the data providers to aggregate.
    public init<D: DataProvider>(dataProviders: [D]) where D.Element == Element {
        self.dataProviders = dataProviders.map { AnyDataProvider($0) }
        self.observers = dataProviders.enumerated().map { [unowned self] section, dataProvider in
            dataProvider.observable.addObserver(observer: { self.translate(change: $0, section: section) })
        }
    }
    
    /// An observable where one can subscribe to changes of data provider.
    public var observable: DataProviderObservable { return innerObaseravle }
    
    /// Returns an object for a given index path.
    ///
    /// - Parameter indexPath: the index path to get the object for.
    /// - Returns: the object at the given index path.
    public func object(at indexPath: IndexPath) -> Element {
        let (dataProvider, realSection) = dataProviderAndIndexOffset(ofSection: indexPath.section)
        let realIndexPath = IndexPath(row: indexPath.row, section: realSection)
        
        return dataProvider.object(at: realIndexPath)
    }
    
    /// Returns the number of items in a given section.
    ///
    /// - Parameter section: the section.
    /// - Returns: number of items in the given section.
    public func numberOfItems(inSection section: Int) -> Int {
        let (dataProvider, realSection) = dataProviderAndIndexOffset(ofSection: section)
        return dataProvider.numberOfItems(inSection: realSection)
    }
    
    // Return the number of sections.
    ///
    /// - Returns: the number of sections.
    public func numberOfSections() -> Int {
        return dataProviders
            .map { $0.numberOfSections() }
            .reduce(0, +)
    }
    
    private func dataProviderAndIndexOffset(ofSection section: Int) -> (AnyDataProvider<Element>, Int) {
        var sectionI = 0
        for dataProvider in dataProviders {
            if section >= sectionI && section < sectionI + dataProvider.numberOfSections() {
                return (dataProvider, section - sectionI)
            }
            sectionI += dataProvider.numberOfSections()
        }
        
        fatalError("Invalid index")
    }
    
    private func translate(change: DataProviderChange, section: Int) {
        switch change {
        case .unknown:
            innerObaseravle.send(updates: change)
        case .changes(let changes):
            let sectionOffset = dataProviders[0..<section].map { $0.numberOfSections() }.reduce(0, +)
            innerObaseravle.send(updates: .changes(translate(changes: changes, sectionOffset: sectionOffset)))
        case .viewUnrelatedChanges(let changes):
            let sectionOffset = dataProviders[0..<section].map { $0.numberOfSections() }.reduce(0, +)
            innerObaseravle.send(updates: .viewUnrelatedChanges(translate(changes: changes, sectionOffset: sectionOffset)))
        }
    }
    
    private func translate(changes: [DataProviderChange.Change], sectionOffset: Int) -> [DataProviderChange.Change] {
        return changes.map { change in
            switch change {
            case .update(let indexPath):
                return .update(IndexPath(row: indexPath.row, section: sectionOffset + indexPath.section))
            case .delete(let indexPath):
                return .delete(IndexPath(row: indexPath.row, section: sectionOffset + indexPath.section))
            case .insert(let indexPath):
                return .insert(IndexPath(row: indexPath.row, section: sectionOffset + indexPath.section))
            case .move(let sourceIndexPath, let destinationIndexPath):
                return .move(IndexPath(row: sourceIndexPath.row, section: sectionOffset + sourceIndexPath.section),
                             IndexPath(row: destinationIndexPath.row, section: sectionOffset + destinationIndexPath.section))
            case .insertSection(let insertedSection):
                return .insertSection(sectionOffset + insertedSection)
            case .updateSection(let updatedSection):
                return .updateSection(sectionOffset + updatedSection)
            case .deleteSection(let deletedSection):
                return .deleteSection(sectionOffset + deletedSection)
            case .moveSection(let sourceSection, let destinationSource):
                return .moveSection(sectionOffset + sourceSection, sectionOffset + destinationSource)
            }
        }
    }
    
    deinit {
        dataProviders.enumerated().forEach { ( index, dataProvider) in
            dataProvider.observable.removeObserver(observer: observers[index])
        }
    }
    
    private let dataProviders: [AnyDataProvider<Element>]
    private let innerObaseravle = DefaultDataProviderObservable()
    private var observers: [NSObjectProtocol]!
    
}
