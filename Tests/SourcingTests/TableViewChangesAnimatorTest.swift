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

import XCTest
import Sourcing

@MainActor
final class TableViewChangesAnimatorTest: XCTestCase {
    
    func testInitDeinit() {
        //Given
        let tableViewMock = UITableViewMock()
        let observable = DataProviderObservableMock()

        var tableViewChangesAnimator: TableViewChangesAnimator? = TableViewChangesAnimator(tableView: tableViewMock,
                                                                                            observable: observable)
        XCTAssertNotNil(observable.observer)
        
        //When
        tableViewChangesAnimator = nil
        
        //Then
        XCTAssertNil(observable.observer)
    }
    
    func testProcessUnknownReload() {
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        //When
         observable.send(updates: .unknown)
        
        //Then
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 0)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 0)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 1)
    }
    
    func testProcessUpdatesInsert() {
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        //Given
        let insertionIndexPath = IndexPath(row: 0, section: 0)
        let insertion = DataProviderChange.Change.insert(insertionIndexPath)
        
        //When
         observable.send(updates: .changes([insertion]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.inserted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.inserted?.first, insertionIndexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
        XCTAssertEqual(tableViewMock.executedRowAnimations.first, UITableView.RowAnimation.none)
    }
    
    func testProcessUpdatesDelete() {
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        //Given
        let deletetionIndexPath = IndexPath(row: 0, section: 0)
        let deletion = DataProviderChange.Change.delete(deletetionIndexPath)
        
        //When
         observable.send(updates: .changes([deletion]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.deleted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.deleted?.first, deletetionIndexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
        XCTAssertEqual(tableViewMock.executedRowAnimations.first, UITableView.RowAnimation.none)
    }
    
    func testProcessUpdatesMove() {
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        //Given
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 0, section: 0)
        let move = DataProviderChange.Change.move(oldIndexPath, newIndexPath)
        
        //When
         observable.send(updates: .changes([move]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.moved?.from, oldIndexPath)
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.moved?.to, newIndexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesUpdate() {
        //Given
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        let indexPath = IndexPath(row: 0, section: 0)
        let update = DataProviderChange.Change.update(indexPath)
        
        //When
         observable.send(updates: .changes([update]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.reloaded?.first, indexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
        XCTAssertEqual(tableViewMock.executedRowAnimations.first, UITableView.RowAnimation.none)
    }
    
    func testProcessUpdatesInsertSection() {
        //Given
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        let insertion = DataProviderChange.Change.insertSection(0)
        
        //When
         observable.send(updates: .changes([insertion]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.first, 0)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
        XCTAssertEqual(tableViewMock.executedRowAnimations.first, UITableView.RowAnimation.none)
    }
    
    func testProcessUpdatesDeleteSection() {
        //Given
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        let deleteSection = DataProviderChange.Change.deleteSection(0)
        
        //When
         observable.send(updates: .changes([deleteSection]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.deleted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedSections.deleted?.first, 0)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
        XCTAssertEqual(tableViewMock.executedRowAnimations.first, UITableView.RowAnimation.none)
    }
    
    func testProcessUpdatesMoveSection() {
        //Given
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        let moveSection = DataProviderChange.Change.moveSection(0, 1)
        
        //When
         observable.send(updates: .changes([moveSection]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.moved?.from, 0)
        XCTAssertEqual(tableViewMock.modifiedSections.moved?.to, 1)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesUpdateSection() {
        //Given
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        let updateSection = DataProviderChange.Change.updateSection(0)
        
        //When
         observable.send(updates: .changes([updateSection]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.updated, IndexSet([0]))
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesFromDataSource() {
        //Given
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        let insertSection = DataProviderChange.Change.insertSection(0)
        
        //When
         observable.send(updates: .changes([insertSection]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.first, 0)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testReloadAll() {
        //Given
        let tableViewMock = UITableViewMock()
        let configuration = TableViewChangesAnimator.Configuration(insert: .none, update: .none, move: .none,
                                                                delete: .none, insertSection: .none, deleteSection: .none)
        let observable = DataProviderObservableMock()
        let tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, observable: observable, configuration: configuration)
        let change = DataProviderChange.unknown
        
        //When
         observable.send(updates: change)
        
        //Then
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 1)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 0)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 0)
    }
    
    func testProcessUpdatesWithReconfigurationFromDataSource() {
        //Given
        var cell: UITableViewCellMock<Int>?
        var indexPath: IndexPath?
        var object: Int?
        let cellConfiguration = CellConfiguration<UITableViewCellMock<Int>>(reuseIdentifier: "reuseIdentifier") {
            cell = $0
            indexPath = $1
            object = $2
        }
        let tableViewMock = UITableViewMock(mockTableViewCells: ["reuseIdentifier": UITableViewCellMock<Int>()])
        let observable = DataProviderObservableMock()
        let dataProvider = ArrayDataProvider(rows: [1])
        let tableViewChangesAnimator = TableViewChangesAnimator(
            tableView: tableViewMock,
            dataProvider: dataProvider,
            cellConfiguration: cellConfiguration
        )

        let change = DataProviderChange.changes([.update(IndexPath(row: 0, section: 0))])
        
        //When
        dataProvider.reconfigure(with: [2], change: change)
        
        //Then
        XCTAssertNotNil(cell)
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
        XCTAssertEqual(object, 2)
    }
}
