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
//  TableViewDataSourcing.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

import UIKit
/**
 `TableViewDataSourcing` descripes a tableViewDataSource. It is generic over an DataProvider
 */
public protocol TableViewDataSourcing: UITableViewDataSource {
    associatedtype DataProvider: DataProviding
    
    /// The dataProvider which works as the dataSource of the tableView by providing specific data.
    var dataProvider: DataProvider { get }
    
    /// The tableView which should present the data.
    var tableView: TableViewRepresenting { get set }
    
    
    /// Updates a given cell with a given Object
    ///
    /// - parameter cell: the cell to configure.
    /// - parameter with: the object/data for the cell.
    func update(_ cell: UITableViewCell, with: DataProvider.Object)
    
    /// Processe data changes into the table view ui. If there is no specific information on the updates
    /// (e.g. update equals nil) it only reloads the tableView.
    ///
    /// - parameter updates: the updates to change the table view
    func processUpdates(_ updates: [DataProviderUpdate<DataProvider.Object>]?)
    
}

public extension TableViewDataSourcing {
    
    func processUpdates(_ updates: [DataProviderUpdate<DataProvider.Object>]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
                
            case .update(let indexPath, let object):
                guard let cell = self.tableView.cellForRowAtIndexPath(indexPath) else {
                    fatalError("Could not update Cell")
                }
                self.update(cell, with: object)
            case .move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .fade)
            case .delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
            case .insertSection(let sectionIndex):
                self.tableView.insertSections(IndexSet(integer: sectionIndex), withRowAnimation: .fade)
            case .deleteSection(let sectionIndex):
                self.tableView.deleteSections(IndexSet(integer: sectionIndex), withRowAnimation: .fade)
            }
        }
        tableView.endUpdates()
    }
    
    var selectedObject: DataProvider.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.object(at: indexPath)
    }
}
