//
//  MultiCellTableViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 27.05.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

public class MultiCellTableViewDataSource<Data: DataProvider>: NSObject, UITableViewDataSource {
    
    public required init(tableView: UITableView, dataProvider: Data, cellDequeables: Array<CellDequeable>) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.cellDequeables = cellDequeables
        super.init()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    public var selectedObject: Data.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
    
    public func processUpdates(updates: [DataProviderUpdate<Data.Object>]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            case .Update(let indexPath, let object):
                guard let cell = self.tableView.cellForRowAtIndexPath(indexPath), let cellDequeable = self.cellDequeableForIndexPath(object) else {
                  fatalError("Could no Update Cell")
                }
                cellDequeable.configureCell(cell, object: object)
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
    
    
    // MARK: Private
    
    private let tableView: UITableView
    let dataProvider: Data
    let cellDequeables: Array<CellDequeable>
    
    private func registerCells(cellDequeables: Array<CellDequeable>) {
        for (_, cellDequeable) in cellDequeables.enumerate()  {
            tableView.registerNib(cellDequeable.nib, forCellReuseIdentifier: cellDequeable.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(object: Data.Object) -> CellDequeable? {
        for (_, cellDequeable) in cellDequeables.enumerate() where cellDequeable.canConfigurecellForItem(object) {
            return cellDequeable
        }
        
        return nil
    }
    
    // MARK: UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = dataProvider.objectAtIndexPath(indexPath)
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellDequeable.cellIdentifier, forIndexPath: indexPath)
        cellDequeable.configureCell(cell, object: object)
        
        return cell
    }
    
}