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

class UICollectionViewMock: UICollectionView {
    private var strongDataSource: UICollectionViewDataSource?
    override var dataSource: UICollectionViewDataSource? {
        get { return strongDataSource }
        set { strongDataSource = newValue }
    }
    
    private var strongPrefetchDataSource: UICollectionViewDataSourcePrefetching?
    override var prefetchDataSource: UICollectionViewDataSourcePrefetching? {
        get { return strongPrefetchDataSource }
        set { strongPrefetchDataSource = newValue }
    }
    
    var reloadedCount = 0
    var lastUsedReuseIdetifiers = [String]()
    let cellMocks: [String: AnyObject]
    var registerdNibs = [String: UINib?]()
    
    var beginUpdatesCalledCount = 0
    var endUpdatesCalledCount = 0
    
   var modifiedIndexPaths: ModifiedIndexPaths = ModifiedIndexPaths()
    
    var insertedSections: IndexSet?
    var deleteSections: IndexSet?
    var movedSection: (from: Int, to: Int)?
    
    init(mockCollectionViewCells: [String: UICollectionViewCell] = ["cellIdentifier": UICollectionViewCellMock<Int>()]) {
        cellMocks = mockCollectionViewCells
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dequeueWithIdentifier<Cell>(_ identifier: String, forIndexPath indexPath: IndexPath) -> Cell {
        lastUsedReuseIdetifiers.append(identifier)
        
        guard let cell = cellMocks[identifier] as? Cell else {
            fatalError("Could not find cell mock with identifier: \(identifier)")
        }
        
        return cell
    }
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueWithIdentifier(identifier, forIndexPath: indexPath)
    }
    
    private var selectedIndexPaths: [IndexPath]?
    override var indexPathsForSelectedItems: [IndexPath]? {
        get { return selectedIndexPaths }
        set { selectedIndexPaths = newValue }
    }
    
    override func reloadData() {
        reloadedCount += 1
    }
    
    override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        registerdNibs[identifier] = nib
    }
    
    override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        beginUpdatesCalledCount += 1
        endUpdatesCalledCount += 1
        updates?()
    }
    
    override func insertSections(_ sections: IndexSet) {
        insertedSections = sections
    }
    
    override func deleteSections(_ sections: IndexSet) {
        deleteSections = sections
    }
    
    override func reloadSections(_ sections: IndexSet) {
    
    }
    
    override func moveSection(_ section: Int, toSection newSection: Int) {
        movedSection = (from: section, to: newSection)
    }
    
    override func insertItems(at indexPaths: [IndexPath]) {
        modifiedIndexPaths.inserted = indexPaths
    }
    
    override func deleteItems(at indexPaths: [IndexPath]) {
        modifiedIndexPaths.deleted = indexPaths
    }
    
    override func reloadItems(at indexPaths: [IndexPath]) {
        modifiedIndexPaths.reloaded = indexPaths
    }
    
    override func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        modifiedIndexPaths.moved = (from: indexPath, to: newIndexPath)
    }
    
    func cellForItematAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = cellMocks.first
        return cell?.1 as? UICollectionViewCell
    }
}
