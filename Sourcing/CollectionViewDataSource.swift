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
//  CollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//


import UIKit


final public class CollectionViewDataSource<DataProvider: DataProviding, Cell: UICollectionViewCell, CellDequeable: StaticCellDequeable where Cell: ConfigurableCell, Cell.DataSource == DataProvider.Object, CellDequeable.Object == DataProvider.Object, CellDequeable.Cell == Cell>: NSObject, UICollectionViewDataSource {
    private let dynamicDataSoruce: MultiCellCollectionViewDataSource<DataProvider>
    public required init(collectionView: UICollectionView, dataProvider: DataProvider, cell: CellDequeable) {
        dynamicDataSoruce = MultiCellCollectionViewDataSource(collectionView: collectionView, dataProvider: dataProvider, cellDequeables: [cell])
        super.init()
    }
    
    public var selectedObject: DataProvider.Object? {
        return dynamicDataSoruce.selectedObject
    }
    
    public func processUpdates(updates: [DataProviderUpdate<DataProvider.Object>]?) {
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

