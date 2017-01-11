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
import Foundation
import UIKit

final public class CollectionViewDataSource<Object>: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    public let dataProvider: DataProvider<Object>
    public var collectionView: CollectionViewRepresenting {
        didSet {
            collectionView.dataSource = self
            collectionView.reloadData()
        }
    }
    private let cells: Array<CellDequeable>
    private let canMoveItems: Bool
    
    public init<TypedDataProvider: DataProviding>(collectionView: CollectionViewRepresenting, dataProvider: TypedDataProvider,
                anyCells: Array<CellDequeable>, canMoveItems: Bool = false) where TypedDataProvider.Object == Object {
        self.collectionView = collectionView
        self.dataProvider = DataProvider(dataProvider: dataProvider)
        self.cells = anyCells
        self.canMoveItems = canMoveItems
        super.init()
        registerCells(cells)
        collectionView.dataSource = self
        if #available(iOS 10.0, *) {
            collectionView.prefetchDataSource = self
        }
        collectionView.reloadData()
    }
    
    func update(_ cell: UICollectionViewCell, with object: Object) {
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Could not find a cell to deuqe")
        }
        cellDequeable.configure(cell, with: object)
    }
    
    // MARK: Private

    private func registerCells(_ cellDequeables: Array<CellDequeable>) {
        for cellDequeable in cellDequeables where cellDequeable.nib != nil {
            collectionView.registerNib(cellDequeable.nib, forCellWithReuseIdentifier: cellDequeable.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(_ object: Object) -> CellDequeable? {
        for cell in cells where cell.canConfigureCell(with: object) {
            return cell
        }
        
        return nil
    }
    
    func process(updates: [DataProviderUpdate<Object>]?) {
        guard let updates = updates else {
            return collectionView.reloadData()
        }
        var shouldUpdate = false
        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case .insert(let indexPath):
                    self.collectionView.insertItemsAtIndexPaths([indexPath])
                case .update(let indexPath, let object):
                    guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) else {
                        shouldUpdate = true
                        continue
                    }
                    self.update(cell, with: object)
                case .move(let indexPath, let newIndexPath):
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                    self.collectionView.insertItemsAtIndexPaths([newIndexPath])
                case .delete(let indexPath):
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                case .insertSection(let sectionIndex):
                    self.collectionView.insertSections(IndexSet(integer: sectionIndex))
                case .deleteSection(let sectionIndex):
                    self.collectionView.deleteSections(IndexSet(integer: sectionIndex))
                }
            }
        }, completion: nil)
        if shouldUpdate {
            collectionView.reloadData()
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
        return canMoveItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataProvider.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath)
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
    convenience init<CellConfig: StaticCellDequeable, TypedDataProvider: DataProviding>(collectionView: CollectionViewRepresenting,
                     dataProvider: TypedDataProvider, cell: CellConfig)
        where TypedDataProvider.Object == Object, CellConfig.Cell: UICollectionViewCell {
            let typeErasedDataProvider = DataProvider(dataProvider: dataProvider)
            self.init(collectionView: collectionView, dataProvider: typeErasedDataProvider, anyCells: [cell])
    }
    
    convenience init<CellConfig: StaticCellDequeable, TypedDataProvider: DataProviding>(collectionView: CollectionViewRepresenting,
                     dataProvider: TypedDataProvider, cells: Array<CellConfig>)
        where TypedDataProvider.Object == Object, CellConfig.Cell: UICollectionViewCell {
            let typeErasedDataProvider = DataProvider(dataProvider: dataProvider)
            self.init(collectionView: collectionView, dataProvider: typeErasedDataProvider, anyCells: cells)
    }
}
