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
//  MultiCellCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//
import UIKit

final public class CollectionViewDataSource<Object>: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    public let dataProvider: AnyDataProvider<Object>
    public let dataModificator: DataModifying?
    public var collectionView: CollectionViewRepresenting {
        didSet {
            collectionView.dataSource = self
            collectionView.reloadData()
        }
    }
    private let cells: Array<CellConfiguring>
    
    public init<DataProvider: DataProviding>(collectionView: CollectionViewRepresenting, dataProvider: DataProvider,
                anyCells: Array<CellConfiguring>, dataModificator: DataModifying? = nil)
        where DataProvider.Element == Object {
            self.collectionView = collectionView
            self.dataProvider = AnyDataProvider(dataProvider)
            self.cells = anyCells
            self.dataModificator = dataModificator
            super.init()
            dataProvider.whenDataProviderChanged = { [weak self] updates in
                self?.process(updates: updates)
            }
            registerCells(cells)
            collectionView.dataSource = self
            if #available(iOS 10.0, *) {
                collectionView.prefetchDataSource = self
            }
            collectionView.reloadData()
    }
    
    // MARK: Private
    
    private func registerCells(_ cellDequeables: Array<CellConfiguring>) {
        for cellDequeable in cellDequeables where cellDequeable.nib != nil {
            collectionView.registerNib(cellDequeable.nib, forCellWithReuseIdentifier: cellDequeable.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(_ object: Object) -> CellConfiguring? {
        return cells.first(where: { $0.canConfigureCell(with: object) })
    }
    
    func process(updates: [DataProviderUpdate<Object>]?) {
        guard let updates = updates else {
            return collectionView.reloadData()
        }
        collectionView.performBatchUpdates({
            updates.forEach(self.process)
        }, completion: nil)
    }
    
    private func process(update: DataProviderUpdate<Object>) {
        switch update {
        case .insert(let indexPath):
            collectionView.insertItemsAtIndexPaths([indexPath])
        case .update(let indexPath, _):
            collectionView.reloadItemsAtIndexPaths([indexPath])
        case .move(let indexPath, let newIndexPath):
            collectionView.moveItemAtIndexPath(indexPath, toIndexPath: newIndexPath)
        case .delete(let indexPath):
            collectionView.deleteItemsAtIndexPaths([indexPath])
        case .insertSection(let sectionIndex):
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        case .deleteSection(let sectionIndex):
            collectionView.deleteSections(IndexSet(integer: sectionIndex))
        case .moveSection(let section, let newSection):
            collectionView.moveSection(section, toSection: newSection)
        }
    }
    
    public var selectedObjects: Array<Object>? {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
            return nil
        }
        
        return selectedIndexPaths.map(dataProvider.object)
    }
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = dataProvider.object(at: indexPath)
        
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellDequeable.cellIdentifier, forIndexPath: indexPath)
        cellDequeable.configure(cell, with: object)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return dataModificator?.canMoveItem(at: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataModificator?.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, triggerdByTableView: true)
    }
    
    // MARK: UICollectionViewDataSourcePrefetching
    
    @available(iOS 10.0, *)
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        dataProvider.prefetchItems(at: indexPaths)
    }
    
    @available(iOS 10.0, *)
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        dataProvider.cancelPrefetchingForItems(at: indexPaths)
    }
}

// MARK: Typesafe initializers

extension CollectionViewDataSource {
    convenience init<CellConfig: StaticCellConfiguring, DataProvider: DataProviding>(collectionView: CollectionViewRepresenting,
                     dataProvider: DataProvider, cell: CellConfig, dataModificator: DataModifying? = nil)
        where DataProvider.Element == Object, CellConfig.Object == Object, CellConfig.Cell: UICollectionViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(collectionView: collectionView, dataProvider: typeErasedDataProvider, anyCells: [cell], dataModificator: dataModificator)
    }
    
    convenience init<CellConfig: StaticCellConfiguring, DataProvider: DataProviding>(collectionView: CollectionViewRepresenting,
                     dataProvider: DataProvider, cells: Array<CellConfig>, dataModificator: DataModifying? = nil)
        where DataProvider.Element == Object, CellConfig.Object == Object, CellConfig.Cell: UICollectionViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider)
            self.init(collectionView: collectionView, dataProvider: typeErasedDataProvider, anyCells: cells, dataModificator: dataModificator)
    }
}
