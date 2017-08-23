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
//  UITableViewMock.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 09.08.16.
//

import UIKit
import Sourcing

class UITableViewMock: UITableView {
    private var strongDataSource: UITableViewDataSource?
    override var dataSource: UITableViewDataSource? {
        get { return strongDataSource }
        set { strongDataSource = newValue }
    }
    private var storedIndexPathForSelectedRow: IndexPath?
    override var indexPathForSelectedRow: IndexPath? {
        get { return storedIndexPathForSelectedRow }
        set { storedIndexPathForSelectedRow = newValue }
    }
    private var strongPrefetchDataSource: UITableViewDataSourcePrefetching?
    override var prefetchDataSource: UITableViewDataSourcePrefetching? {
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

    init(mockTableViewCells: [String: UITableViewCell] = ["cellIdentifier": UITableViewCellMock<Int>()]) {
        cellMocks = mockTableViewCells
        super.init(frame: .zero, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        registerdNibs[identifier] = nib
    }
    
    override func reloadData() {
        reloadedCount += 1
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueWithIdentifier(identifier, forIndexPath: indexPath)
    }
    
    func dequeueWithIdentifier<Cell>(_ identifier: String, forIndexPath indexPath: IndexPath) -> Cell {
        lastUsedReuseIdetifiers.append(identifier)
        
        guard let cell = cellMocks[identifier] as? Cell else {
            fatalError("Could not find cell mock with identifier: \(identifier)")
        }
        
        return cell
    }
    
    override func beginUpdates() {
        beginUpdatesCalledCount += 1
    }
    
    override func endUpdates() {
        endUpdatesCalledCount += 1
    }
    
    override func insertRows(at indexPaths: [IndexPath], with withRowAnimation: UITableViewRowAnimation) {
        modifiedIndexPaths.inserted = indexPaths
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with withRowAnimation: UITableViewRowAnimation) {
        modifiedIndexPaths.deleted = indexPaths
    }
    
    override public func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        modifiedIndexPaths.reloaded = indexPaths
    }
    
    override func insertSections(_ sections: IndexSet, with withRowAnimation: UITableViewRowAnimation) {
        insertedSections = sections
    }
    
    override func deleteSections(_ sections: IndexSet, with withRowAnimation: UITableViewRowAnimation) {
        deleteSections = sections
    }
    
    override func moveSection(_ section: Int, toSection newSection: Int) {
        movedSection = (from: section, to: newSection)
    }
    
    override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        modifiedIndexPaths.moved = (from: indexPath, to: newIndexPath)
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = cellMocks.first
        return cell?.1 as? UITableViewCell
    }
}
