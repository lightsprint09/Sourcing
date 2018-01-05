//
//  ExperimentalTableCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 23.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
    
/// `TableViewDataSource` uses data provider and provides the data as a `UITableViewDataSource`
final public class TableViewDataSource<Object>: NSObject, UITableViewDataSource {
    /// The data provider which provides the data to the data source
    public let dataProvider: AnyDataProvider<Object>
    
    /// Provides section header titles and section index titles
    public let sectionTitleProvider: SectionTitleProviding?
    
    /// Optional data modificator can be used to modify the data providers content
    public let dataModificator: DataModifying?
    
    private let cellConfigurations: [CellConfiguring]
    
    /// Creates an instance with a data provider and cell configurations
    /// which will be displayed in the collection view.
    ///
    /// - Note: This initializer is loosly typed. If you just display one cell, use the strongly typed initializer.
    /// - Parameters:
    ///   - dataProvider: the data provider which provides data to the data source
    ///   - anyCells: the cell configuration for the collection view cells
    ///   - dataModificator: optional data modifier.
    ///   - sectionTitleProvider: provides section header titles and section index titles.
    public init<TypedDataProvider: DataProviding>(dataProvider: TypedDataProvider,
          anyCellConfigurations: [CellConfiguring], dataModificator: DataModifying? = nil, sectionTitleProvider: SectionTitleProviding? = nil)
                where TypedDataProvider.Element == Object {
        self.dataProvider = AnyDataProvider(dataProvider)
        self.dataModificator = dataModificator
        self.cellConfigurations = anyCellConfigurations
        self.sectionTitleProvider = sectionTitleProvider
        super.init()
    }
    
    private func cellDequeableForIndexPath(_ object: Object) -> CellConfiguring? {
        return cellConfigurations.first(where: { $0.canConfigureCell(with: object) })
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
        let cellDequeable: CellConfiguring! = cellDequeableForIndexPath(object)
        precondition(cellDequeable != nil, "Unexpected cell type at \(indexPath) for object of type")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDequeable.reuseIdentifier, for: indexPath)
        cellDequeable.configure(cell, with: object)
        
        return cell
    }
    
    // MARK: Section Index Titles
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitleProvider?.sectionIndexTitles
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        precondition(self.sectionTitleProvider != nil, "Must not called when sectionTitleProvider is nil")
        let sectionTitleProvider: SectionTitleProviding! = self.sectionTitleProvider
        return sectionTitleProvider.section(forSectionIndexTitle: title, at: index)
    }
    
    // MARK: SectionHeader & SectionFooter
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleProvider?.titleForHeader(inSection: section)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionTitleProvider?.titleForFooter(inSection: section)
    }
    
    // MARK: Editing
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
}

// MARK: Typesafe initializers

public extension TableViewDataSource {
    /// Creates an instance with a data provider and cell configuration
    /// which will be displayed in the collection view.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider which provides data to the data source
    ///   - cell: the cell configuration for the collection view cell
    ///   - dataModificator: optional data modifier.
    ///   - sectionTitleProvider: provides section header titles and section index titles.
    convenience init<Cell: StaticCellConfiguring, TypedDataProvider: DataProviding>(dataProvider: TypedDataProvider, cellConfiguration: Cell,
                     dataModificator: DataModifying? = nil, sectionTitleProvider: SectionTitleProviding? = nil)
        where TypedDataProvider.Element == Object, Cell.Object == Object, Cell.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: [cellConfiguration],
                      dataModificator: dataModificator, sectionTitleProvider: sectionTitleProvider)
    }
    
    /// Creates an instance with a data provider and cell configurations
    /// which will be displayed in the collection view.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider which provides data to the data source
    ///   - cells: the cell configuration for the collection view cells
    ///   - dataModificator: optional data modifier.
    ///   - sectionTitleProvider: provides section header titles and section index titles.
    convenience init<Cell: StaticCellConfiguring, TypedDataProvider: DataProviding>(dataProvider: TypedDataProvider, cellConfigurations: [Cell],
                     dataModificator: DataModifying? = nil, sectionTitleProvider: SectionTitleProviding? = nil)
        where TypedDataProvider.Element == Object, Cell.Object == Object, Cell.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(dataProvider: typeErasedDataProvider, anyCellConfigurations: cellConfigurations,
                      dataModificator: dataModificator, sectionTitleProvider: sectionTitleProvider)
    }
}

#endif
