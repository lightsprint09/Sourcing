//
//  MultiCellCollectionViewDataSource.swift
//  Burgess
//
//  Created by Lukas Schmidt on 22.05.16.
//  Copyright © 2016 Digital Workroom. All rights reserved.
//

import Foundation
import UIKit

public class MultiCellCollectionViewDataSource<Data: DataProvider>: NSObject, UICollectionViewDataSource {
    
    public required init(collectionView: UICollectionView, dataProvider: Data, cellDequeables: Array<CellDequeable>) {
        self.collectionView = collectionView
        self.dataProvider = dataProvider
        self.cellDequeables = cellDequeables
        super.init()
        registerCells(cellDequeables)
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    public var selectedObject: Data.Object? {
        guard let indexPath = collectionView.indexPathsForSelectedItems()?.first else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
    
    public func processUpdates(updates: [DataProviderUpdate<Data.Object>]?) {
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
    let dataProvider: Data
    private let cellDequeables: Array<CellDequeable>
    
    private func registerCells(cellDequeables: Array<CellDequeable>) {
        for (_, cellDequeable) in cellDequeables.enumerate()  {
            collectionView.registerNib(cellDequeable.nib, forCellWithReuseIdentifier: cellDequeable.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(object: Data.Object) -> CellDequeable? {
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
        guard let cellDequeable = cellDequeableForIndexPath(object), cell = cellDequeable.dequeueReusableCell(collectionView, indexPath: indexPath, object: object) else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
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