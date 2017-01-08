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
final public class TableViewDataSource<DataProvider: DataProviding, CellConfig: StaticCellDequeable>: NSObject, TableViewDataSourcing where CellConfig.Object == DataProvider.Object, CellConfig.Cell.DataSource == DataProvider.Object, CellConfig.Cell: UITableViewCell {
    
    public let dataProvider: DataProvider
    public var tableView: TableViewRepresenting {
        didSet {
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    private let cellDequable: CellConfig
    private let canMoveItems: Bool
    
    public required init(tableView: TableViewRepresenting, dataProvider: DataProvider, cellDequable: CellConfig, canMoveItems: Bool = false) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.cellDequable = cellDequable
        self.canMoveItems = canMoveItems
        super.init()
        registerNib()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    public func update(_ cell: UITableViewCell, with object: DataProvider.Object) {
        guard let realCell = cell as? CellConfig.Cell else {
            fatalError("Wrong Cell type. Expects \(CellConfig.Cell.self) but got \(type(of: cell))")
        }
        let _ = cellDequable.configureCellTypeSafe(realCell, with: object)
    }
    
    private func registerNib() {
        guard let nib = cellDequable.nib else { return }
        tableView.registerNib(nib, forCellReuseIdentifier: cellDequable.cellIdentifier)
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellDequable.cellIdentifier, forIndexPath: indexPath)
        update(cell, with: object)
        
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
         return dataProvider.sectionIndexTitles
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataProvider.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath)
    }
}


