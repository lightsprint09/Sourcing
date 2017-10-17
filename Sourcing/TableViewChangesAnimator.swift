//
//  Copyright (C) DB Systel GmbH.
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

import Foundation

public class TableViewChangesAnimator<Object> {
    
    private var dataPrvoiderObserver: NSObjectProtocol?
    public let dataProvider: ObservableDataProvider
    private let tableView: UITableView
    
    init<DataProvider: ObservableDataProvider>(tableView: UITableView, dataProvider: DataProvider) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        dataPrvoiderObserver = dataProvider.addObserver(observer: { [weak self] updates in
               self?.process(updates: updates)
        })
    }
    
    deinit {
        dataProvider.removeObserver(observer: dataPrvoiderObserver as Any)
    }
    
    private func process(update: DataProviderUpdate) {
        switch update {
        case .insert(let indexPath):
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .update(let indexPath):
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move(let indexPath, let newIndexPath):
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .delete(let indexPath):
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insertSection(let sectionIndex):
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .deleteSection(let sectionIndex):
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .moveSection(let indexPath, let newIndexPath):
            tableView.moveSection(indexPath, toSection: newIndexPath)
        }
    }
    
    /// Execute updates on your TableView. TableView will do a matching animation for each update
    ///
    /// - Parameter updates: list of updates to execute
    private func process(updates: [DataProviderUpdate]?) {
        guard let updates = updates else {
            return tableView.reloadData()
        }
        tableView.beginUpdates()
        updates.forEach(process)
        tableView.endUpdates()
    }
}
