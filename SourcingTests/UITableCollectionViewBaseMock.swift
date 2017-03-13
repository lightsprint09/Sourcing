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
//  UITableCollectionViewBaseMock.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 22.08.16.
//

import UIKit

// swiftlint:disable force_cast force_try force_unwrapping
class UITableCollectionViewBaseMock {
    var reloadedCount = 0
    var lastUsedReuseIdetifiers = Array<String>()
    let cellMocks: Dictionary<String, AnyObject>
    var registerdNibs = Dictionary<String, UINib?>()
    
    var beginUpdatesCalledCount = 0
    var endUpdatesCalledCount = 0
    
    var insertedIndexPaths: Array<IndexPath>?
    var deletedIndexPaths: Array<IndexPath>?
    var reloadedIndexPaths: Array<IndexPath>?
    var movedIndexPath: (from: IndexPath, to: IndexPath)?
    
    var insertedSections: IndexSet?
    var deleteSections: IndexSet?
    var movedSection: (from: Int, to: Int)?

    func reloadData() {
        reloadedCount += 1
    }
    
    init(mockCells: Dictionary<String, AnyObject>) {
        cellMocks = mockCells
    }
    
    func registerNib(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        registerdNibs[identifier] = nib
    }
    
    func dequeueWithIdentifier<Cell>(_ identifier: String, forIndexPath indexPath: IndexPath) -> Cell {
        lastUsedReuseIdetifiers.append(identifier)
        
        return cellMocks[identifier]! as! Cell
    }
    
}
