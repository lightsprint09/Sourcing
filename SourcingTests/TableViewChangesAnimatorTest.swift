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

final class TableViewChangesAnimatorTest: XCTestCase {
    
    var tableViewMock: UITableViewMock!
    var tableViewChangesAnimator: TableViewChangesAnimator!
    var observable = DataProviderObservableMock()
    
    override func setUp() {
        super.setUp()
        tableViewMock = UITableViewMock()
        tableViewChangesAnimator = TableViewChangesAnimator(tableView: tableViewMock, dataProviderObservable: observable)
    }
    
    func testInitDeinit() {
        //Given
        let observable = DataProviderObservableMock()
        var collectionViewChangesAnimator2: TableViewChangesAnimator? = TableViewChangesAnimator(tableView: tableViewMock,
                                                                                                           dataProviderObservable: observable)
        XCTAssertNotNil(observable.observer)
        
        //When
        collectionViewChangesAnimator2 = nil
        
        //Then
        XCTAssertNil(observable.observer)
    }
    
    func testProcessUnknownReload() {
        //When
        observable.observer?(.unknown)
        
        //Then
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 0)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 0)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 1)
    }
    
    func testProcessUpdatesInsert() {
        //Given
        let insertionIndexPath = IndexPath(row: 0, section: 0)
        let insertion = DataProviderChange.Change.insert(insertionIndexPath)
        
        //When
        observable.observer?(.changes([insertion]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.inserted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.inserted?.first, insertionIndexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesDelete() {
        //Given
        let deletetionIndexPath = IndexPath(row: 0, section: 0)
        let deletion = DataProviderChange.Change.delete(deletetionIndexPath)
        
        //When
        observable.observer?(.changes([deletion]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.deleted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.deleted?.first, deletetionIndexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesMove() {
        //Given
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 0, section: 0)
        let move = DataProviderChange.Change.move(oldIndexPath, newIndexPath)
        
        //When
        observable.observer?(.changes([move]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.moved?.from, oldIndexPath)
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.moved?.to, newIndexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesUpdate() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        let update = DataProviderChange.Change.update(indexPath)
        
        //When
        observable.observer?(.changes([update]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedIndexPaths.reloaded?.first, indexPath)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesInsertSection() {
        //Given
        let insertion = DataProviderChange.Change.insertSection(0)
        
        //When
        observable.observer?(.changes([insertion]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.first, 0)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesDeleteSection() {
        //Given
        let deleteSection = DataProviderChange.Change.deleteSection(0)
        
        //When
        observable.observer?(.changes([deleteSection]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.deleted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedSections.deleted?.first, 0)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesMoveSection() {
        //Given
        let moveSection = DataProviderChange.Change.moveSection(0, 1)
        
        //When
        observable.observer?(.changes([moveSection]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.moved?.from, 0)
        XCTAssertEqual(tableViewMock.modifiedSections.moved?.to, 1)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testProcessUpdatesFromDataSource() {
        //Given
        let insertSection = DataProviderChange.Change.insertSection(0)
        
        //When
        observable.observer?(.changes([insertSection]))
        
        //Then
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.count, 1)
        XCTAssertEqual(tableViewMock.modifiedSections.inserted?.first, 0)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 1)
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 0)
    }
    
    func testReloadAll() {
        //Given
        let change = DataProviderChange.unknown
        
        //When
        observable.observer?(change)
        
        //Then
        XCTAssertEqual(tableViewMock.executionCount.reloaded, 1)
        XCTAssertEqual(tableViewMock.executionCount.beginUpdates, 0)
        XCTAssertEqual(tableViewMock.executionCount.endUpdates, 0)
    }
}