//
//  ExperimentalTableCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 23.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
    
/// Generic DataSoruce providing data to a tableview.
final public class TableViewDataSource<Object>: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public let dataProvider: AnyDataProvider<Object>
    public let sectionTitleProvider: SectionTitleProviding?
    public let dataModificator: DataModifying?
    private let cells: [CellConfiguring]
    
    public init<TypedDataProvider: DataProviding>(dataProvider: TypedDataProvider,
          anyCells: [CellConfiguring], dataModificator: DataModifying? = nil, sectionTitleProvider: SectionTitleProviding? = nil)
                where TypedDataProvider.Element == Object {
        self.dataProvider = AnyDataProvider(dataProvider)
        self.dataModificator = dataModificator
        self.cells = anyCells
        self.sectionTitleProvider = sectionTitleProvider
        super.init()
    }
    
    private func cellDequeableForIndexPath(_ object: Object) -> CellConfiguring? {
        return cells.first(where: { $0.canConfigureCell(with: object) })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDequeable.cellIdentifier, for: indexPath)
        cellDequeable.configure(cell, with: object)
        
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitleProvider?.sectionIndexTitles
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleProvider?.titleForHeader(inSection: section)
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return dataModificator?.canMoveItem(at: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, updateView: true)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataModificator?.canDeleteItem(at: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let dataModificator = dataModificator, editingStyle == .delete {
            dataModificator.deleteItem(at: indexPath, updateView: true)
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
    convenience init<Cell: StaticCellConfiguring, TypedDataProvider: DataProviding>(dataProvider: TypedDataProvider, cell: Cell,
                     dataModificator: DataModifying? = nil, sectionTitleProvider: SectionTitleProviding? = nil)
        where TypedDataProvider.Element == Object, Cell.Object == Object, Cell.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(dataProvider: typeErasedDataProvider, anyCells: [cell],
                      dataModificator: dataModificator, sectionTitleProvider: sectionTitleProvider)
    }
    
    convenience init<Cell: StaticCellConfiguring, TypedDataProvider: DataProviding>(dataProvider: TypedDataProvider, cells: [Cell],
                     dataModificator: DataModifying? = nil, sectionTitleProvider: SectionTitleProviding? = nil)
        where TypedDataProvider.Element == Object, Cell.Object == Object, Cell.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(dataProvider: typeErasedDataProvider, anyCells: cells,
                      dataModificator: dataModificator, sectionTitleProvider: sectionTitleProvider)
    }
}

#endif
