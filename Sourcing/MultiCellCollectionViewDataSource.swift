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

final public class MultiCellCollectionViewDataSource<DataProvider: DataProviding>: NSObject, CollectionViewDataSourcing {
    
    public let dataProvider: DataProvider
    public var collectionView: CollectionViewRepresenting {
        didSet {
            collectionView.dataSource = self
            collectionView.reloadData()
        }
    }
    private let cellDequeables: Array<CellDequeable>
    
    public required init(collectionView: CollectionViewRepresenting, dataProvider: DataProvider, cellDequeables: Array<CellDequeable>) {
        self.collectionView = collectionView
        self.dataProvider = dataProvider
        self.cellDequeables = cellDequeables
        super.init()
        registerCells(cellDequeables)
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    public func update(_ cell: UICollectionViewCell, with object: DataProvider.Object) {
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Could not find a cell to dequeue")
        }
        let _ = cellDequeable.configure(cell, with: object)
    }
    
    
    // MARK: Private
    
    
    fileprivate func registerCells(_ cellDequeables: Array<CellDequeable>) {
        for cellDequeable in cellDequeables where cellDequeable.nib != nil {
            collectionView.registerNib(cellDequeable.nib, forCellWithReuseIdentifier: cellDequeable.cellIdentifier)
        }
    }
    
    fileprivate func cellDequeableForIndexPath(_ object: DataProvider.Object) -> CellDequeable? {
        for (_, cellDequeable) in cellDequeables.enumerated() where cellDequeable.canConfigureCell(with: object) {
            return cellDequeable
        }
        
        return nil
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
        let _ = cellDequeable.configure(cell, with: object)
        
        return cell
    }
}
