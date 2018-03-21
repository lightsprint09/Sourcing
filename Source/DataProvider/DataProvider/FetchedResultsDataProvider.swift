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
import CoreData

/// `FetchedResultsDataProvider` uses a `NSFetchedResultsController` as a backing store to transform it into a data provider.
public final class FetchedResultsDataProvider<Object: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, DataProvider {
    
    /// The fetched results controller which backs the data provider.
    public let fetchedResultsController: NSFetchedResultsController<Object>
    
    /// An observable where one can subscribe to changes of data provider.
    public var observable: DataProviderObservable {
        return defaultObservable
    }
    
    private let defaultObservable: DefaultDataProviderObservable
    
    var updates: [DataProviderChange.Change] = []
    private var performsViewUnrelatedChange = false
    
    /// Creates an instance of `FetchedResultsDataProvider` backed by a `NSFetchedResultsController`. Performs a fetch to populate the data.
    ///
    /// - Parameter fetchedResultsController: the fetched results controller backing the data provider.
    /// - Throws: if fetching fails.
    public init(fetchedResultsController: NSFetchedResultsController<Object>) throws {
        self.fetchedResultsController = fetchedResultsController
        self.defaultObservable = DefaultDataProviderObservable()
        super.init()
        fetchedResultsController.delegate = self
        try fetchedResultsController.performFetch()
    }
    
    /// Reconfigure the `NSFetchedResultsController` with a new fetch request. This will refetch all objects.
    ///
    /// - Parameter configure: a block to perform the reconfiguration.
    /// - Throws: if fetching fails
    public func reconfigure(with configure: (NSFetchedResultsController<Object>) -> Void) throws {
        NSFetchedResultsController<Object>.deleteCache(withName: fetchedResultsController.cacheName)
        configure(fetchedResultsController)
        
        try fetchedResultsController.performFetch()
        defaultObservable.send(updates: .unknown)
    }

    /// Perform changes to your model object, which won`t result in an updated view.
    /// This can be helpful when performing a move operation amnd if the view is already in the correct state.
    ///
    /// - Parameter execute: block to perform the changes in.
    public func performNonUIRelevantChanges(_ execute: () -> Void) {
        performsViewUnrelatedChange = true
        execute()
        performsViewUnrelatedChange = false
    }
    
    /// Returns an object for a given index path.
    ///
    /// - Parameter indexPath: the index path to get the object for.
    /// - Returns: the object at the given index path.
    public func object(at indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    /// Returns the number of items in a given section.
    ///
    /// - Parameter section: the section.
    /// - Returns: number of items in the given section.
    public func numberOfItems(inSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    /// Return the number of sections.
    ///
    /// - Returns: the number of sections.
    public func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    /// Returns the index path of an object if it is contains in the data provider.
    ///
    /// - Parameter object: the object to get the index path for.
    /// - Returns: the index path for the given object.
    public func indexPath(for object: Object) -> IndexPath? {
        return fetchedResultsController.indexPath(forObject: object)
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                           at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            updates.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.update(indexPath))
        case .move:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
            updates.append(.move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.delete(indexPath))
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange sectionInfo: NSFetchedResultsSectionInfo,
                           atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            updates.append(.insertSection(sectionIndex))
        case .delete:
            updates.append(.deleteSection(sectionIndex))
        default: break
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let updatesIndexPaths = updates.compactMap { update -> IndexPath? in
            switch update {
            case .update(let indexPath):
                return indexPath
            default: return nil
            }
        }
        updates = updates.compactMap { update -> DataProviderChange.Change? in
            if case .move(_, let newIndexPath) = update, updatesIndexPaths.contains(newIndexPath) {
               return nil
            }
            return update
        }
        dataProviderDidChangeContents(with: updates)
        let updatesByMoves = updates.compactMap { operation -> DataProviderChange.Change? in
            if case .move(_, let newIndexPath) = operation {
                return .update(newIndexPath)
            }
            return nil
        }
        dataProviderDidChangeContents(with: updatesByMoves)
    }
    
    func dataProviderDidChangeContents(with updates: [DataProviderChange.Change]) {
        if performsViewUnrelatedChange {
            defaultObservable.send(updates: .viewUnrelatedChanges(updates))
        } else {
            defaultObservable.send(updates: .changes(updates))
        }
    }

}
