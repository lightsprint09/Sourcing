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
//  TableViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

import UIKit

/// Generic DataSoruce providing data to a tableview.
final public class TableViewDataSource<DataProvider: DataProviding, CellConfig: StaticCellDequeable where CellConfig.Object == DataProvider.Object, CellConfig.Cell.DataSource == DataProvider.Object>: NSObject, UITableViewDataSource, TableViewDataSourcing {
    public typealias DataProviderr = DataProvider
    
    public let dataProvider: DataProvider
    public let tableView: UITableView
    let cellConfiguration: CellConfig
    
    public required init(tableView: UITableView, dataProvider: DataProvider, cellDequable: CellConfig) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.cellConfiguration = cellDequable
        
        super.init()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    public func updateTableView(cell: UITableViewCell, object: DataProvider.Object) {
        guard let cell = cell as? CellConfig.Cell else { return }
        cell.configureForObject(object)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellConfiguration.cellIdentifier, forIndexPath: indexPath)
        if let typedCell = cell as? CellConfig.Cell{
            cellConfiguration.configureTypeSafe(typedCell, object: object)
        } else {
            fatalError()
        }
        
        return cell
    }
}


