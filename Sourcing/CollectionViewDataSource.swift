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


final public class CollectionViewDataSource<DataProvider: DataProviding, CellConfig: StaticCellDequeable where CellConfig.Object == DataProvider.Object>: NSObject, CollectionViewDataSourcing {
    
    public let collectionView: UICollectionView
    public let dataProvider: DataProvider
    let cellConfiguration: CellConfig
    
    public required init(collectionView: UICollectionView, dataProvider: DataProvider, cell: CellConfig) {
        self.collectionView = collectionView
        self.dataProvider = dataProvider
        self.cellConfiguration = cell
        super.init()
        registerNib()
        collectionView.dataSource = self
        collectionView.reloadData()
    }
   
    public func updateCollectionViewCell(cell: UICollectionViewCell, object: DataProvider.Object) {
        guard let cell = cell as? CellConfig.Cell else { return }
        cellConfiguration.configureTypeSafe(cell, object: object)
    }
    
    func registerNib() {
        guard let nib = cellConfiguration.nib else { return }
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellConfiguration.cellIdentifier)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellConfiguration.cellIdentifier, forIndexPath: indexPath)
        if let typedCell = cell as? CellConfig.Cell {
            cellConfiguration.configureTypeSafe(typedCell, object: object)
        } else {
            fatalError()
        }
        
        return cell
    }    
}

