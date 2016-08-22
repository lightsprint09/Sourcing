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
//  CollectionViewRepresenting.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 22.08.16.
//

import UIKit

public protocol CollectionViewRepresenting: class {
    var dataSource: UICollectionViewDataSource? { get set }
    
    func indexPathsForSelectedItems() -> [NSIndexPath]?
    
    func reloadData()
    
    func registerNib(nib: UINib?, forCellWithReuseIdentifier identifier: String)

    func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    
    func performBatchUpdates(updates: (() -> Void)?, completion: ((Bool) -> Void)?)

    func insertSections(sections: NSIndexSet)
    func deleteSections(sections: NSIndexSet)
    func reloadSections(sections: NSIndexSet)
    func moveSection(section: Int, toSection newSection: Int)
    
    func insertItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func reloadItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func moveItemAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath)
    
    func cellForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell?
    
}

extension UICollectionView: CollectionViewRepresenting { }