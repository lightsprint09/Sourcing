//
//  FetchedResultsDataProvider.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 14.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import CoreData
 
final class FetchedResultsDataProvider<Object: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, DataProviding {

    let dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())?
    let fetchedResultsController: NSFetchedResultsController<Object>
    var updates: [DataProviderUpdate<Object>] = []
    
    var sectionIndexTitles: Array<String>? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    public init(fetchedResultsController: NSFetchedResultsController<Object>, dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) ->())? = nil) throws {
        self.fetchedResultsController = fetchedResultsController
        self.dataProviderDidUpdate = dataProviderDidUpdate
        super.init()
        fetchedResultsController.delegate = self
        try fetchedResultsController.performFetch()
    }
    
    public func reconfigure(with fetchRequest: (NSFetchRequest<Object>) -> ()) throws {
        NSFetchedResultsController<Object>.deleteCache(withName: fetchedResultsController.cacheName)
        fetchRequest(fetchedResultsController.fetchRequest)
        try fetchedResultsController.performFetch()
        dataProviderDidUpdate?(nil)
    }
    
    public func object(at indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    public func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    public func indexPath(for object: Object) -> IndexPath? {
        return fetchedResultsController.indexPath(forObject: object)
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            updates.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            let object = self.object(at: indexPath)
            updates.append(.update(indexPath, object))
        case .move:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
            updates.append(.move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.delete(indexPath))
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            updates.append(.insertSection(sectionIndex))
        case .delete:
            updates.append(.deleteSection(sectionIndex))
        default: break
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataProviderDidUpdate?(updates)
    }

}
