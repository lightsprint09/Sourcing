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

import UIKit

class UITableViewMockDelegateMock: NSObject, UITableViewDelegate {
    var rowActions: [UITableViewRowAction]?
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return rowActions
    }
}

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
    
    var registerdNibs = [String: UINib?]()
    
    var cellDequeueMock: CellDequeueMock<UITableViewCell>
    
    var executionCount = ExecutionCount()
    
    var modifiedIndexPaths: ModifiedIndexPaths = ModifiedIndexPaths()
    var modifiedSections = ModifiedSections()
    var executedRowAnimations = [UITableViewRowAnimation]()

    init(mockTableViewCells: [String: UITableViewCell] = ["reuseIdentifier": UITableViewCellMock<Int>()]) {
        cellDequeueMock = CellDequeueMock(cells: mockTableViewCells, dequeueCellReuseIdentifiers: [])
        super.init(frame: .zero, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        registerdNibs[identifier] = nib
    }
    
    override func reloadData() {
        executionCount.reloaded += 1
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return cellDequeueMock.dequeueWithIdentifier(identifier, forIndexPath: indexPath)
    }
    
    override func beginUpdates() {
        executionCount.beginUpdates += 1
    }
    
    override func endUpdates() {
        executionCount.endUpdates += 1
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        modifiedIndexPaths.inserted = indexPaths
        executedRowAnimations.append(animation)
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        modifiedIndexPaths.deleted = indexPaths
        executedRowAnimations.append(animation)
    }
    
    override public func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        modifiedIndexPaths.reloaded = indexPaths
        executedRowAnimations.append(animation)
    }
    
    override func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        modifiedSections.inserted = sections
        executedRowAnimations.append(animation)
    }
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        modifiedSections.updated = sections
        executedRowAnimations.append(animation)
    }
    
    override func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        modifiedSections.deleted = sections
        executedRowAnimations.append(animation)
    }
    
    override func moveSection(_ section: Int, toSection newSection: Int) {
        modifiedSections.moved = (from: section, to: newSection)
    }
    
    override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        modifiedIndexPaths.moved = (from: indexPath, to: newIndexPath)
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        return cellDequeueMock.cells.first?.value
    }
}
