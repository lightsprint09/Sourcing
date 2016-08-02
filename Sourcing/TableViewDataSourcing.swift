//
//
//  MultiCellTableViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

public protocol TableViewDataSourcing {
    associatedtype DataProviderr: DataProviding
    
    var dataProvider: DataProviderr { get }
    var tableView: UITableView { get }
    
    func updateTableView(cell: UITableViewCell, object: DataProviderr.Object)
    
}

public extension TableViewDataSourcing {
    func processUpdates(updates: [DataProviderUpdate<DataProviderr.Object>]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            case .Update(let indexPath, let object):
                guard let cell = self.tableView.cellForRowAtIndexPath(indexPath) else {
                    fatalError("Could not update Cell")
                }
                self.updateTableView(cell, object: object)
            case .Move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .InsertSection(let sectionIndex):
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .DeleteSection(let sectionIndex):
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            }
        }
        tableView.endUpdates()
    }
    
    var selectedObject: DataProviderr.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
}
