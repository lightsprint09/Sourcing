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

class CoreDataModificator<T: NSManagedObject>: DataModifying {
    let dataProvider: FetchedResultsDataProvider<T>
    let move: (_ from:(T, IndexPath), _ to:(T, IndexPath)) -> Void
    
    init(dataProvider: FetchedResultsDataProvider<T>, move: @escaping (_ from:(T, IndexPath), _ to:(T, IndexPath)) -> Void) {
        self.dataProvider = dataProvider
        self.move = move
    }
    
    func canMoveItem(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, updateView: Bool) {
        let objectFrom = dataProvider.object(at: sourceIndexPath)
        let objectTo = dataProvider.object(at: destinationIndexPath)
        dataProvider.executeChangeByUserInteraction {
            move((objectFrom, sourceIndexPath), (objectTo, destinationIndexPath))
        }        
    }
    
    func canDeleteItem(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deleteItem(at indexPath: IndexPath, updateView: Bool) {
        let managedObjectContext = dataProvider.fetchedResultsController.managedObjectContext
        let object = dataProvider.fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(object)
        _ = try? managedObjectContext.save()
    }
}
