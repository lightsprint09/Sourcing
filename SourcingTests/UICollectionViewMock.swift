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
//  UICollectionViewMock.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 22.08.16.
//

import UIKit
import Sourcing

class MockCollectionCell<T>: UICollectionViewCell, ConfigurableCell {
    var configurationCount = 0
    var configuredObject: T?
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    func configureForObject(object: T) {
        configurationCount += 1
        configuredObject = object
    }
}
class UICollectionViewMock: UITableCollectionViewBaseMock, CollectionViewRepresenting {
    var dataSource: UICollectionViewDataSource?
    
    init(mockCollectionViewCells: Dictionary<String, UICollectionViewCell> = ["cellIdentifier": MockCollectionCell<Int>()]) {
        super.init(mockCells: mockCollectionViewCells)
    }
    
    func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return dequeueWithIdentifier(identifier, forIndexPath: indexPath)
    }
    
    func indexPathsForSelectedItems() -> [NSIndexPath]? {
        return nil
    }
    
    func performBatchUpdates(updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        updates?()
    }
    
    func insertSections(sections: NSIndexSet) {
    
    }
    func deleteSections(sections: NSIndexSet) {
        
    }
    func reloadSections(sections: NSIndexSet) {
    
    }
    func moveSection(section: Int, toSection newSection: Int) {
    
    }
    
    func insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
    
    }
    func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
    
    }
    func reloadItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
    
    }
    func moveItemAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
    
    }
    
    func cellForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell? {
        let cell = cellMocks.first
        return cell?.1 as? UICollectionViewCell
    }
}