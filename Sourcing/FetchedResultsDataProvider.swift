//
//  FetchedResultsDataProvider.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 14.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import CoreData

open class FetchedResultsDataProvider<Object: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, DataProviding {
    /**
     Closure which gets called, when a data inside the provider changes and those changes should be propagated to the datasource.
     
     - warning: Only set this when you are updating the datasource. Only set this when you are updating the datasource by your own.
     */
    public var whenDataProviderChanged: ProcessUpdatesCallback<Object>?
    
    //The fetchedResultsController which backs the dataprovider
    public let fetchedResultsController: NSFetchedResultsController<Object>
    
    // Subscribe to updates of this dataProvider.
    public var dataProviderDidUpdate: ProcessUpdatesCallback<Object>?
    var updates: [DataProviderUpdate<Object>] = []
    
    /**
     Section Index Titles for `UITableView`. Related to `UITableViewDataSource` method `sectionIndexTitlesForTableView`
     */
    open var sectionIndexTitles: [String]? {
        return provideSectionIndexTitles ? fetchedResultsController.sectionIndexTitles : nil
    }
    // Decide wether section index titles sould be provided.
    public var provideSectionIndexTitles: Bool = true
    
    // Header titles for each section
    open var headerTitles: [String]? {
        guard let generateHeaderAt = generateHeaderAt else {
            return nil
        }
        return (0..<numberOfSections()).map { generateHeaderAt($0) }
    }
    
    /**
     Closure so provide header titles. Set this to generate custom header titles.
     
     **Example**:
     ```swift
         let headers = ["SectionOne", "SectionTwo"]
         let frcDataProvider = //
         frcDataProvider.generateHeaderAt = { sectionIndex
             return headers[sectionIndex]
         }
     ```
    */
    public var generateHeaderAt: ((Int) -> String)?
    
    /// Creates an instacte with a given `NSFetchedResultsController` which fetches matching objects.
    ///
    /// - Parameters:
    ///   - fetchedResultsController: a `NSFetchedResultsController` which provides the data fetched from CoreData.
    ///   - dataProviderDidUpdate: Subscribe to updates of this dataProvider.
    /// - Throws: If fetching fails.
    public init(fetchedResultsController: NSFetchedResultsController<Object>, dataProviderDidUpdate: ProcessUpdatesCallback<Object>? = nil) throws {
        self.fetchedResultsController = fetchedResultsController
        self.dataProviderDidUpdate = dataProviderDidUpdate
        super.init()
        fetchedResultsController.delegate = self
        try fetchedResultsController.performFetch()
    }
    
    /**
     Reconfigure the `NSFetchedResultsController` to changes the contents it provides to the data provider.
 
     - Parameter configuration: reconfigure the `NSFetchedResultsController` in this given block
     - Throws: If fetching fails.
     
     **Example**:
     ```swift
         let frcDataProvider = //
         let newFetchRequest = //
     
     frcDataProvider.reconfigure { frc in
         frc.fetchRequest = newFetchRequest
     }
     ```
     */
    public func reconfigure(with configuration: (NSFetchedResultsController<Object>) -> Void) throws {
        NSFetchedResultsController<Object>.deleteCache(withName: fetchedResultsController.cacheName)
        configuration(fetchedResultsController)
        
        try fetchedResultsController.performFetch()
        dataProviderDidChangeContets(with: nil)
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
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                           at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
        dataProviderDidChangeContets(with: updates)
    }
    
    func dataProviderDidChangeContets(with updates: [DataProviderUpdate<Object>]?, triggerdByTableView: Bool = false) {
        if !triggerdByTableView {
            whenDataProviderChanged?(updates)
        }
        dataProviderDidUpdate?(updates)
    }

}
