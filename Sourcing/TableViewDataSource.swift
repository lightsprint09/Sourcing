//
//  ExperimentalTableCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 23.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

/// Generic DataSoruce providing data to a tableview.
final public class TableViewDataSource<Object>: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public let dataProvider: AnyDataProvider<Object>
    public let dataModificator: DataModifying?
    public var tableView: TableViewRepresenting {
        didSet {
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    private let cells: Array<CellDequeable>
    public var displaySectionIndexTitles: Bool
    
    public init<TypedDataProvider: DataProviding>(tableView: TableViewRepresenting, dataProvider: TypedDataProvider,
                anyCells: Array<CellDequeable>, dataModificator: DataModifying? = nil, displaySectionIndexTitles: Bool = false)
                where TypedDataProvider.Object == Object {
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
    
    private func register(cells: Array<CellDequeable>) {
        for cell in cells where cell.nib != nil {
            tableView.registerNib(cell.nib, forCellReuseIdentifier: cell.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(_ object: Object) -> CellDequeable? {
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
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
        case .update(let indexPath, _):
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move(let indexPath, let newIndexPath):
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .delete(let indexPath):
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
        case .insertSection(let sectionIndex):
            tableView.insertSections(IndexSet(integer: sectionIndex), withRowAnimation: .fade)
        case .deleteSection(let sectionIndex):
            tableView.deleteSections(IndexSet(integer: sectionIndex), withRowAnimation: .fade)
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellDequeable.cellIdentifier, forIndexPath: indexPath)
        cellDequeable.configure(cell, with: object)
        
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return displaySectionIndexTitles ? dataProvider.sectionIndexTitles : nil
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let count = dataProvider.sectionIndexTitles?.count ?? -1
        if section == 0 && count == 0 {
            return nil
        }
        if section > count {
            return nil
        } else {
            return dataProvider.sectionIndexTitles?[section]
        }
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return dataModificator?.canMoveItem(at: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, causedByUserInteraction: true)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataModificator?.canDeleteItem(at: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let dataModificator = dataModificator, editingStyle == .delete {
            dataModificator.deleteItem(at: indexPath, causedByUserInteraction: true)
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
    convenience init<CellConfig: StaticCellDequeable, TypedDataProvider: DataProviding>(tableView: TableViewRepresenting,
                     dataProvider: TypedDataProvider, cell: CellConfig, dataModificator: DataModifying? = nil, displaySectionIndexTitles: Bool = false)
        where TypedDataProvider.Object == Object, CellConfig.Object == Object, CellConfig.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(tableView: tableView, dataProvider: typeErasedDataProvider, anyCells: [cell], dataModificator: dataModificator, displaySectionIndexTitles: displaySectionIndexTitles)
    }
    
    convenience init<CellConfig: StaticCellDequeable, TypedDataProvider: DataProviding>(tableView: TableViewRepresenting,
                     dataProvider: TypedDataProvider, cells: Array<CellConfig>, dataModificator: DataModifying? = nil, displaySectionIndexTitles: Bool = false)
        where TypedDataProvider.Object == Object, CellConfig.Object == Object, CellConfig.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(tableView: tableView, dataProvider: typeErasedDataProvider, anyCells: cells, dataModificator: dataModificator, displaySectionIndexTitles: displaySectionIndexTitles)
    }
}
