//
//  TableViewDataSource.swift
//  Moody
//
//  Created by Florian on 31/08/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import UIKit
/// Generic DataSoruce providing data to a tableview.
public class TableViewDataSource<Data: DataProvider, Cell: UITableViewCell, CellDequeable: StaticCellDequeable where Cell: ConfigurableCell, Cell.DataSource == Data.Object, CellDequeable.Object == Data.Object, CellDequeable.Cell == Cell>: NSObject, UITableViewDataSource {
    private let dynamicDataSource: MultiCellTableViewDataSource<Data>
    public required init(tableView: UITableView, dataProvider: Data, cellDequable: CellDequeable) {
        dynamicDataSource = MultiCellTableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequeables: [cellDequable])
        super.init()
        
    }
    /// The object which represents the selection in the TableView
    public var selectedObject: Data.Object? {
       return dynamicDataSource.selectedObject
    }

    public func processUpdates(updates: [DataProviderUpdate<Data.Object>]?) {
        dynamicDataSource.processUpdates(updates)
    }


    // MARK: UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dynamicDataSource.numberOfSectionsInTableView(tableView)
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicDataSource.tableView(tableView, numberOfRowsInSection:  section)
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return dynamicDataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
}

