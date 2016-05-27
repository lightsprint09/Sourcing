//
//  CollectionViewDataSource.swift
//  Moody
//
//  Created by Florian on 31/08/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import UIKit


public class CollectionViewDataSource<Data: DataProvider, Cell: UICollectionViewCell, CellDequeable: StaticCellDequeable where Cell: ConfigurableCell, Cell.DataSource == Data.Object, CellDequeable.Object == Data.Object, CellDequeable.Cell == Cell>: NSObject, UICollectionViewDataSource {
    private let dynamicDataSoruce: MultiCellCollectionViewDataSource<Data>
    public required init(collectionView: UICollectionView, dataProvider: Data, cell: CellDequeable) {
        dynamicDataSoruce = MultiCellCollectionViewDataSource(collectionView: collectionView, dataProvider: dataProvider, cellDequeables: [cell])
        super.init()
    }

    public var selectedObject: Data.Object? {
       return dynamicDataSoruce.selectedObject
    }

    public func processUpdates(updates: [DataProviderUpdate<Data.Object>]?) {
        dynamicDataSoruce.processUpdates(updates)
    }
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dynamicDataSoruce.numberOfSectionsInCollectionView(collectionView)
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamicDataSoruce.collectionView(collectionView, numberOfItemsInSection: section)
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return dynamicDataSoruce.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
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

