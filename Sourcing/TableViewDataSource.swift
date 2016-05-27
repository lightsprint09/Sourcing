//
//  TableViewDataSource.swift
//  Moody
//
//  Created by Florian on 31/08/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import UIKit

public class TableViewDataSource<Delegate: DataSourceDelegate, Data: DataProvider, Cell: UITableViewCell where Delegate.Object == Data.Object, Cell: ConfigurableCell, Cell.DataSource == Data.Object>: NSObject, UITableViewDataSource {
    
    public required init(tableView: UITableView, dataProvider: Data, delegate: Delegate, additionalConfigureCellWithObject: ((Data.Object, Cell) -> ())? = nil) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.delegate = delegate
        self.additionalConfigureCellWithObject = additionalConfigureCellWithObject
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
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? Cell else { break }
                cell.configureForObject(object)
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
    private let dataProvider: Data
    private weak var delegate: Delegate!
    private let additionalConfigureCellWithObject: ((Data.Object, Cell) -> ())?


    // MARK: UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = dataProvider.objectAtIndexPath(indexPath)
        let identifier = delegate.cellIdentifierForObject(object)
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell
            else { fatalError("Unexpected cell type at \(indexPath)") }
        additionalConfigureCellWithObject?(object, cell)
        cell.configureForObject(object)
        
        return cell
    }

}

