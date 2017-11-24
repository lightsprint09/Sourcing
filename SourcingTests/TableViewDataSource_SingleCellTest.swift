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
//  TableViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 10.08.16.
//

import XCTest
import UIKit
import Sourcing

// swiftlint:disable force_cast force_unwrapping
class TableViewDataSourceSingleCellTest: XCTestCase {
    
    let cellIdentifier = "cellIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var dataModificator: DataModificatorMock!
    var tableViewMock: UITableViewMock!
    var cell: CellConfiguration<UITableViewCellMock<Int>>!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        tableViewMock = UITableViewMock()
        cell = CellConfiguration(cellIdentifier: cellIdentifier)
        dataModificator = DataModificatorMock()
    }
    
    func testNumberOfSections() {
        //Given
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell)
        let sectionCount = dataSource.numberOfSections(in: realTableView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }
    
    func testNumberOfRowsInSections() {
        //Given
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell)
        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 3)
    }
    
    func testDequeCells() {
        //Given
        var didCallAdditionalConfigurtion = false
        let cell = CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguration: { _, _ in
            didCallAdditionalConfigurtion = true
        })
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell)
        let cellForGivenRow = dataSource.tableView(tableViewMock, cellForRowAt: IndexPath(row: 2, section: 1))
        
        //Then
        let UITableViewCellMock = (tableViewMock.cellDequeueMock.cells[cellIdentifier] as! UITableViewCellMock<Int>)
        XCTAssertEqual(UITableViewCellMock.configurationCount, 1)
        XCTAssertEqual(UITableViewCellMock.configuredObject, 10)
        XCTAssertEqual(tableViewMock.cellDequeueMock.dequeueCellReuseIdentifiers.first, cellIdentifier)
        XCTAssertTrue(cellForGivenRow is UITableViewCellMock<Int>)
        XCTAssertTrue(didCallAdditionalConfigurtion)
    }
    
    func testMoveIndexPaths() {
        //Given
        let cellConfig = CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier)
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = TableViewDataSource(dataProvider: dataProviderMock,
                                             cell: cellConfig, dataModificator: dataModificator)
        
        //When
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.tableView(tableViewMock, moveRowAt: fromIndexPath, to: toIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataModificator.destinationIndexPath, toIndexPath)
        XCTAssert(dataModificator.triggeredByUserInteraction ?? false)
    }
    
    func testPrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource: UITableViewDataSourcePrefetching = TableViewDataSource(dataProvider: dataProviderMock, cell: cell)
        
        //When
        let prefetchedIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.tableView(tableViewMock, prefetchRowsAt: prefetchedIndexPaths)
        
        //Then
        XCTAssertEqual(dataProviderMock.prefetchedIndexPaths!, prefetchedIndexPaths)
    }
    
    func testCenclePrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = TableViewDataSource(dataProvider: dataProviderMock, cell: cell)
        
        //When
        let canceldIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.tableView(tableViewMock, cancelPrefetchingForRowsAt: canceldIndexPaths)
        
        //Then
        XCTAssertEqual(dataProviderMock.canceledPrefetchedIndexPaths!, canceldIndexPaths)
    }
    
    func testCanMoveCellAtIndexPath() {
        //Given
        dataModificator.canMoveItemAt = true
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell, dataModificator: dataModificator)
        
        //Then
        XCTAssertTrue(dataSource.tableView(tableViewMock, canMoveRowAt: IndexPath(row: 0, section: 0)))
        
    }
    
    func testCanMoveCellAtIndexPathWithOutDataModificator() {
        //Given
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell)
        
        //When
        let canMove = dataSource.tableView(tableViewMock, canMoveRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertFalse(canMove)
    }
    
    func testCanDeleteCell() {
        //Given
        dataModificator.canDeleteItemAt = true
         let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell, dataModificator: dataModificator)
        
        //When
        let canDelete = dataSource.tableView(tableViewMock, canEditRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssert(canDelete)
    }
    
    func testCanDeleteCellWithOutDataModificator() {
        //Given
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell)
        
        //When
        let canDelete = dataSource.tableView(tableViewMock, canEditRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertFalse(canDelete)
    }
    
    func testDeleteCell() {
        //Given
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell, dataModificator: dataModificator)
        let deletedIndexPath = IndexPath(row: 0, section: 0)
        
        //When
        dataSource.tableView(tableViewMock, commit: .delete, forRowAt: deletedIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.deletedIndexPath, deletedIndexPath)
        XCTAssert(dataModificator.triggeredByUserInteraction ?? false)
    }
    
    func testTitleForHeaderInSection() {
        //Given
        let sectionTitleProvider = StaticSectionTitlesProvider(sectionHeaderTitles: ["foo", "bar"])
        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cell: cell,
                                         dataModificator: dataModificator, sectionTitleProvider: sectionTitleProvider)
        
        //When
        let sectionTitle = dataSource.tableView(tableViewMock, titleForHeaderInSection: 1)
        
        //Then
        XCTAssertEqual(sectionTitle, "bar")
    }
    
}
