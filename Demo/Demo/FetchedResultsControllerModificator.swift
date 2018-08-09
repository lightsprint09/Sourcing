//
//  CoreDataModificator.swift
//  Leichatletik
//
//  Created by Lukas Schmidt on 02.02.17.
//  Copyright © 2017 freiraum. All rights reserved.
//

import Foundation
import CoreData
import Sourcing

class FetchedResultsControllerModificator<T: NSManagedObject>: DataModifying {
    let dataProvider: FetchedResultsDataProvider<T>
    let move: (_ from: (T, IndexPath), _ to: (T, IndexPath)) -> Void
    
    init(dataProvider: FetchedResultsDataProvider<T>, move: @escaping (_ from: (T, IndexPath), _ to: (T, IndexPath)) -> Void) {
        self.dataProvider = dataProvider
        self.move = move
    }
    
    func canMoveItem(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Moves item from sourceIndexPath to destinationIndexPath
    ///
    /// - Parameters:
    ///   - sourceIndexPath: Source's IndexPath
    ///   - destinationIndexPath: Destination's IndexPath
    ///   - updateView: determines if the view should be updated.
    ///                 Pass `false` if someone else take care of updating the change into the view
    func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, updateView: Bool) {
        let objectFrom = dataProvider.object(at: sourceIndexPath)
        let objectTo = dataProvider.object(at: destinationIndexPath)
        if updateView {
            move((objectFrom, sourceIndexPath), (objectTo, destinationIndexPath))
        } else {
            dataProvider.performNonUIRelevantChanges {
                move((objectFrom, sourceIndexPath), (objectTo, destinationIndexPath))
            }
        }
    }
    
    func canEditItem(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let managedObjectContext = dataProvider.fetchedResultsController.managedObjectContext
        let object = dataProvider.fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(object)
        _ = try? managedObjectContext.save()
    }
    
    func insertItem(at indexPath: IndexPath) {
        fatalError("Unimplemented")
    }
}
