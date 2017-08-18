//
//  ExperimentalTableCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 23.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

/// Generic DataSoruce providing data to a tableview.
final public class TableViewDataSource<Object>: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public let dataProvider: AnyDataProvider<Object>
    public let dataModificator: DataModifying?
    public var tableView: UITableView {
        didSet {
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    private let cells: Array<CellConfiguring>
    public var displaySectionIndexTitles: Bool
    
    public init<TypedDataProvider: DataProviding>(tableView: UITableView, dataProvider: TypedDataProvider,
                anyCells: Array<CellConfiguring>, dataModificator: DataModifying? = nil, displaySectionIndexTitles: Bool = false)
                where TypedDataProvider.Element == Object {
        self.tableView = tableView
        self.dataProvider = AnyDataProvider(dataProvider)
        self.dataModificator = dataModificator
        self.cells = anyCells
        self.displaySectionIndexTitles = displaySectionIndexTitles
        super.init()
        dataProvider.whenDataProviderChanged = { [weak self] updates in
            self?.process(updates: updates)
        }
        register(cells: cells)
        tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
        tableView.reloadData()
    }
    
    private func register(cells: Array<CellConfiguring>) {
        for cell in cells where cell.nib != nil {
            tableView.register(cell.nib, forCellReuseIdentifier: cell.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(_ object: Object) -> CellConfiguring? {
        return cells.first(where: { $0.canConfigureCell(with: object) })
    }
    
    public func process(updates: [DataProviderUpdate<Object>]?) {
        guard let updates = updates else {
            return tableView.reloadData()
        }
        tableView.beginUpdates()
        updates.forEach(process)
        tableView.endUpdates()
    }
    
    func process(update: DataProviderUpdate<Object>) {
        switch update {
        case .insert(let indexPath):
            tableView.insertRows(at: [indexPath], with: .fade)
        case .update(let indexPath, _):
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move(let indexPath, let newIndexPath):
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .delete(let indexPath):
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insertSection(let sectionIndex):
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .deleteSection(let sectionIndex):
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .moveSection(let indexPath, let newIndexPath):
            tableView.moveSection(indexPath, toSection: newIndexPath)
        }
    }
    
    public var selectedObject: Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return nil
        }
        return dataProvider.object(at: indexPath)
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
            fatalError("Unexpected cell type at \(indexPath) for object of type")
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellDequeable.cellIdentifier, for: indexPath)
        cellDequeable.configure(cell, with: object)
        
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return displaySectionIndexTitles ? dataProvider.sectionIndexTitles : nil
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitlesCount = dataProvider.headerTitles?.count ?? -1
        if section == 0 && headerTitlesCount == 0 {
            return nil
        }
        if section > headerTitlesCount {
            return nil
        } else {
            return dataProvider.headerTitles?[section]
        }
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return dataModificator?.canMoveItem(at: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, triggerdByTableView: true)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataModificator?.canDeleteItem(at: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let dataModificator = dataModificator, editingStyle == .delete {
            dataModificator.deleteItem(at: indexPath, triggerdByTableView: true)
        }
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        dataProvider.prefetchItems(at: indexPaths)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        dataProvider.cancelPrefetchingForItems(at: indexPaths)
    }

}

// MARK: Typesafe initializers

public extension TableViewDataSource {
    convenience init<CellConfig: StaticCellConfiguring, TypedDataProvider: DataProviding>(tableView: UITableView,
                     dataProvider: TypedDataProvider, cell: CellConfig,
                     dataModificator: DataModifying? = nil, displaySectionIndexTitles: Bool = false)
        where TypedDataProvider.Element == Object, CellConfig.Object == Object, CellConfig.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(tableView: tableView, dataProvider: typeErasedDataProvider, anyCells: [cell],
                      dataModificator: dataModificator, displaySectionIndexTitles: displaySectionIndexTitles)
    }
    
    convenience init<CellConfig: StaticCellConfiguring, TypedDataProvider: DataProviding>(tableView: UITableView,
                     dataProvider: TypedDataProvider, cells: Array<CellConfig>,
                     dataModificator: DataModifying? = nil, displaySectionIndexTitles: Bool = false)
        where TypedDataProvider.Element == Object, CellConfig.Object == Object, CellConfig.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(tableView: tableView, dataProvider: typeErasedDataProvider, anyCells: cells,
                      dataModificator: dataModificator, displaySectionIndexTitles: displaySectionIndexTitles)
    }
}
