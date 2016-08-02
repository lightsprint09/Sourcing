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

final public class MultiCellCollectionViewDataSource<DataProvider: DataProviding>: NSObject, UICollectionViewDataSource {
    
    public required init(collectionView: UICollectionView, dataProvider: DataProvider, cellDequeables: Array<CellDequeable>) {
        self.collectionView = collectionView
        self.dataProvider = dataProvider
        self.cellDequeables = cellDequeables
        super.init()
        registerCells(cellDequeables)
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    public var selectedObject: DataProvider.Object? {
        guard let indexPath = collectionView.indexPathsForSelectedItems()?.first else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
    
    public func processUpdates(updates: [DataProviderUpdate<DataProvider.Object>]?) {
        guard let updates = updates else { return collectionView.reloadData() }
        var shouldUpdate = false
        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case .Insert(let indexPath):
                    self.collectionView.insertItemsAtIndexPaths([indexPath])
                case .Update(let indexPath, let object):
                    guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath), let cellDequeable = self.cellDequeableForIndexPath(object) else {
                        shouldUpdate = true
                        continue
                    }
                    cellDequeable.configureCell(cell, object: object)
                case .Move(let indexPath, let newIndexPath):
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                    self.collectionView.insertItemsAtIndexPaths([newIndexPath])
                case .Delete(let indexPath):
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                case .InsertSection(let sectionIndex):
                    self.collectionView.insertSections(NSIndexSet(index: sectionIndex))
                case .DeleteSection(let sectionIndex):
                    self.collectionView.deleteSections(NSIndexSet(index: sectionIndex))
                }
            }
            }, completion: nil)
        if shouldUpdate {
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: Private
    
    private let collectionView: UICollectionView
    private let dataProvider: DataProvider
    private let cellDequeables: Array<CellDequeable>
    
    private func registerCells(cellDequeables: Array<CellDequeable>) {
        for (_, cellDequeable) in cellDequeables.enumerate() where cellDequeable.nib != nil {
            collectionView.registerNib(cellDequeable.nib, forCellWithReuseIdentifier: cellDequeable.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(object: DataProvider.Object) -> CellDequeable? {
        for (_, cellDequeable) in cellDequeables.enumerate() where cellDequeable.canConfigurecellForItem(object) {
            return cellDequeable
        }
        
        return nil
    }
    
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let object = dataProvider.objectAtIndexPath(indexPath)
        
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellDequeable.cellIdentifier, forIndexPath: indexPath)
        cellDequeable.configureCell(cell, object: object)
        
        return cell
    }
    
    //    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    //        switch(kind) {
    //        case UICollectionElementKindSectionHeader:
    //            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: delegate.headerIdentifierForIndexPath(indexPath), forIndexPath: indexPath) as! Delegate.Header
    //            delegate.configureHeader(headerView, indexPath: indexPath)
    //            return headerView
    //
    //        case UICollectionElementKindSectionFooter:
    //            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: delegate.footerIdentifierForIndexPath(indexPath), forIndexPath: indexPath) as! Delegate.Footer
    //            delegate.configureFooter(footerView, indexPath: indexPath)
    //            return footerView
    //        default:
    //            return UICollectionReusableView()
    //        }
    //    }
    
}