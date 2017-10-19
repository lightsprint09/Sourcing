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
import UIKit

/**
 A listener that observers changes of an dataprovider. It create animations to make changes visible in the view by using
 ``UITableView`s APIs to animate cells. You can configurate your animatones needed for each change.
 */
public final class TableViewChangesAnimator {
    
    public let dataProvider: DataProviderObservable
    
    private var dataPrvoiderObserver: NSObjectProtocol?
    private let tableView: UITableView
    
    public init<DataProvider: DataProviderObservable>(tableView: UITableView, dataProvider: DataProvider) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        dataPrvoiderObserver = dataProvider.addObserver(observer: { [weak self] update in
            switch update {
            case .unknown:
                self?.tableView.reloadData()
            case .changes(let updates):
                self?.process(updates: updates)
            }
        })
    }
    
    deinit {
        dataProvider.removeObserver(observer: dataPrvoiderObserver as Any)
    }
    
    private func process(update: DataProviderChange.Change) {
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
    private func process(updates: [DataProviderChange.Change]) {
        tableView.beginUpdates()
        updates.forEach(process)
        tableView.endUpdates()
    }
}
