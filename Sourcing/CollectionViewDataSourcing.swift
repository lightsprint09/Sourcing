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
//  CollectionViewDataSourcing.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

import Foundation

import UIKit
/**
 `TableViewDataSourcing`
 */
public protocol CollectionViewDataSourcing {
    associatedtype DataProvider: DataProviding
    
    var dataProvider: DataProvider { get }
    var collectionView: UICollectionView { get }
    
    func updateCollectionViewCell(cell: UICollectionViewCell, object: DataProvider.Object)
}

public extension CollectionViewDataSourcing {
    func processUpdates(updates: [DataProviderUpdate<DataProvider.Object>]?) {
        guard let updates = updates else { return collectionView.reloadData() }
        var shouldUpdate = false
        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case .Insert(let indexPath):
                    self.collectionView.insertItemsAtIndexPaths([indexPath])
                case .Update(let indexPath, let object):
                    guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) else {
                        shouldUpdate = true
                        continue
                    }
                    self.updateCollectionViewCell(cell, object: object)
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
    
    var selectedObject: DataProvider.Object? {
        guard let indexPath = collectionView.indexPathsForSelectedItems()?.first else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
}
