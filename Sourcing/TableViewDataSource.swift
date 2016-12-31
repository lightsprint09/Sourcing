//
//  ExperimentalTableCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 23.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation


/// Generic DataSoruce providing data to a tableview.
final public class TableViewDataSource<DataProvider: DataProviding>: NSObject, TableViewDataSourcing  {
    
    public let dataProvider: DataProvider
    public var tableView: TableViewRepresenting {
        didSet {
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    private let cells: Array<CellDequeable>
    
    public required init(tableView: TableViewRepresenting, dataProvider: DataProvider, cells: Array<CellDequeable>) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.cells = cells
        super.init()
        register(cells: cells)
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    public func update(_ cell: UITableViewCell, with object: DataProvider.Object) {
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Could not update Cell")
        }
        cellDequeable.configure(cell, with: object)
    }
    
    // MARK: UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.object(at: indexPath)
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellDequeable.cellIdentifier, forIndexPath: indexPath)
        update(cell, with: object)
        
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataProvider.sectionIndexTitles
    }
    
    private func register(cells: Array<CellDequeable>) {
        for cell in cells where cell.nib != nil {
            tableView.registerNib(cell.nib, forCellReuseIdentifier: cell.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(_ object: DataProvider.Object) -> CellDequeable? {
        for cell in cells where cell.canConfigureCell(with: object) {
            return cell
        }
        
        return nil
    }
}

extension TableViewDataSource {
    convenience init<CellConfig: StaticCellDequeable>(tableView: TableViewRepresenting, dataProvider: DataProvider, cell: CellConfig)
        where CellConfig.Object == DataProvider.Object, CellConfig.Cell.DataSource == DataProvider.Object, CellConfig.Cell: UITableViewCell {
            self.init(tableView: tableView, dataProvider: dataProvider, cells: [cell])
    }
    
    convenience init<CellConfig: StaticCellDequeable>(tableView: TableViewRepresenting, dataProvider: DataProvider, typedCells: Array<CellConfig>)
        where CellConfig.Object == DataProvider.Object, CellConfig.Cell.DataSource == DataProvider.Object, CellConfig.Cell: UITableViewCell {
            self.init(tableView: tableView, dataProvider: dataProvider, cells: typedCells)
    }
}
