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
    @available(iOS 10.0, *)
    var prefetchDataSource: UICollectionViewDataSourcePrefetching? { get set }
    
    var indexPathsForSelectedItems: [IndexPath]? { get }
    
    func reloadData()
    
    func registerNib(_ nib: UINib?, forCellWithReuseIdentifier identifier: String)

    func dequeueReusableCellWithReuseIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> UICollectionViewCell
    
    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)

    func insertSections(_ sections: IndexSet)
    func deleteSections(_ sections: IndexSet)
    func reloadSections(_ sections: IndexSet)
    func moveSection(_ section: Int, toSection newSection: Int)
    
    func insertItemsAtIndexPaths(_ indexPaths: [IndexPath])
    func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath])
    func reloadItemsAtIndexPaths(_ indexPaths: [IndexPath])
    func moveItemAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath)
    
    func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell?
    
}

extension UICollectionView: CollectionViewRepresenting { }
