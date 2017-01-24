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
@testable import Sourcing

// swiftlint:disable force_cast force_try force_unwrapping
class TableViewDataSourceSingleCellTest: XCTestCase {
    
    let cellIdentifier = "cellIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var tableViewMock: UITableViewMock!
    var cell: CellConfiguration<MockCell<Int>>!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]], sectionIndexTitles: ["foo", "bar"])
        tableViewMock = UITableViewMock()
        cell = CellConfiguration(cellIdentifier: cellIdentifier)
    }
    
    func testSetDataSource() {
        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        XCTAssertNotNil(tableViewMock.dataSource)
        XCTAssertNotNil(tableViewMock.prefetchDataSource)
        XCTAssertEqual(tableViewMock.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let nib = UINib(data: Data(), bundle: nil)
        let cell = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nib)
        
        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //Then
        XCTAssertEqual(tableViewMock.registerdNibs.count, 1)
        XCTAssertNotNil(tableViewMock.registerdNibs[cellIdentifier] as Any)
    }
    
    func testNumberOfSections() {
        //Given
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        let sectionCount = dataSource.numberOfSections(in: realTableView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }
    
    func testNumberOfRowsInSections() {
        //Given
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 3)
    }
    
    func testDequCells() {
        //Given
        var didCallAdditionalConfiguartion = false
        let cell = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguartion: { _, _ in
            didCallAdditionalConfiguartion = true
        })
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        let cellForGivenRow = dataSource.tableView(realTableView, cellForRowAt: IndexPath(row: 2, section: 1))
        
        //Then
        let mockCell = (tableViewMock.cellMocks[cellIdentifier] as! MockCell<Int>)
        XCTAssertEqual(mockCell.configurationCount, 1)
        XCTAssertEqual(mockCell.configuredObject, 10)
        XCTAssertEqual(tableViewMock.lastUsedReuseIdetifiers.first, cellIdentifier)
        XCTAssertTrue(cellForGivenRow is MockCell<Int>)
        XCTAssertTrue(didCallAdditionalConfiguartion)
    }
        
    func testUpdateDataSource() {
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        dataSource.process(updates: [.update(IndexPath(row: 2, section: 1), 100)])
        
        //Then
        let mockCell = (tableViewMock.cellMocks[cellIdentifier] as! MockCell<Int>)
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        XCTAssertEqual(mockCell.configuredObject, 100)
    }
    
    func testUpdateDataSourceWithNoData() {
        //Given
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)

        //When
        dataSource.process(updates: nil)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 2)
    }
    
    func testSelectedObject() {
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        tableViewMock.indexPathForSelectedRow = IndexPath(row: 0, section: 0)
        let selectedObject = dataSource.selectedObject
        
        //Then
        XCTAssertEqual(selectedObject, 2)
    }
    
    func testNoSelectedObject() {
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        let selectedObject = dataSource.selectedObject
        
        //Then
        XCTAssertNil(selectedObject)
    }
    
    func testSectionIndexTitles() {
        //Given
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        let sectionTitles = dataSource.sectionIndexTitles(for: realTableView)
        
        //Then
        XCTAssertEqual(["foo", "bar"], sectionTitles!)
    }
    
    func testSetNewTableView() {
        //Given
        let secondTableview = UITableViewMock()
        
        //When
        XCTAssertNil(secondTableview.dataSource)
        let dataSource = TableViewDataSource(tableView: UITableView(), dataProvider: dataProvider, cell: cell)
        dataSource.tableView = secondTableview
        
        //Then
        XCTAssertNotNil(secondTableview.dataSource)
        XCTAssertEqual(secondTableview.reloadedCount, 1)
    }
    
    func testMoveIndexPaths() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = TableViewDataSource(tableView: UITableView(), dataProvider: dataProviderMock, cell: cellConfig)
        
        //When
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.tableView(UITableView(), moveRowAt: fromIndexPath, to: toIndexPath)
        
        //Then
        XCTAssertEqual(dataProviderMock.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataProviderMock.destinationIndexPath, toIndexPath)
    }
    
    func testProcessUpdatesInsert() {
        //Given
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //When
        let insertionIndexPath = IndexPath(row: 0, section: 0)
        let insertion = DataProviderUpdate<Int>.insert(insertionIndexPath)
        dataSource.process(updates: [insertion])
        
        //Then
        XCTAssertEqual(tableViewMock.insertedIndexPaths?.count, 1)
        XCTAssertEqual(tableViewMock.insertedIndexPaths?.first, insertionIndexPath)
        XCTAssertEqual(tableViewMock.beginUpdatesCalledCount, 1)
        XCTAssertEqual(tableViewMock.endUpdatesCalledCount, 1)
    }
    
    func testProcessUpdatesDelete() {
        //Given
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //When
        let deletetionIndexPath = IndexPath(row: 0, section: 0)
        let deletion = DataProviderUpdate<Int>.delete(deletetionIndexPath)
        dataSource.process(updates: [deletion])
        
        //Then
        XCTAssertEqual(tableViewMock.deleteIndexPaths?.count, 1)
        XCTAssertEqual(tableViewMock.deleteIndexPaths?.first, deletetionIndexPath)
        XCTAssertEqual(tableViewMock.beginUpdatesCalledCount, 1)
        XCTAssertEqual(tableViewMock.endUpdatesCalledCount, 1)
    }
    
    func testProcessUpdatesMove() {
        //Given
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //When
        let oldIndexPath = IndexPath(row: 0, section: 0)
        let newIndexPath = IndexPath(row: 0, section: 0)
        let move = DataProviderUpdate<Int>.move(oldIndexPath, newIndexPath)
        dataSource.process(updates: [move])
        
        //Then
        XCTAssertEqual(tableViewMock.deleteIndexPaths?.count, 1)
        XCTAssertEqual(tableViewMock.deleteIndexPaths?.first, oldIndexPath)
        XCTAssertEqual(tableViewMock.insertedIndexPaths?.count, 1)
        XCTAssertEqual(tableViewMock.insertedIndexPaths?.first, newIndexPath)
        XCTAssertEqual(tableViewMock.beginUpdatesCalledCount, 1)
        XCTAssertEqual(tableViewMock.endUpdatesCalledCount, 1)
    }
    
    func testProcessUpdatesInsertSection() {
        //Given
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //When
        let insertion = DataProviderUpdate<Int>.insertSection(0)
        dataSource.process(updates: [insertion])
        
        //Then
        XCTAssertEqual(tableViewMock.insertedSections?.count, 1)
        XCTAssertEqual(tableViewMock.insertedSections?.first, 0)
        XCTAssertEqual(tableViewMock.beginUpdatesCalledCount, 1)
        XCTAssertEqual(tableViewMock.endUpdatesCalledCount, 1)
    }
    
    func testProcessUpdatesSelecteSection() {
        //Given
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //When
        let deletion = DataProviderUpdate<Int>.deleteSection(0)
        dataSource.process(updates: [deletion])
        
        //Then
        XCTAssertEqual(tableViewMock.deleteSections?.count, 1)
        XCTAssertEqual(tableViewMock.deleteSections?.first, 0)
        XCTAssertEqual(tableViewMock.beginUpdatesCalledCount, 1)
        XCTAssertEqual(tableViewMock.endUpdatesCalledCount, 1)
    }
    
    func testProcessUpdatesFromDataSource() {
        //Given
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell)
        
        //When
        let deletion = DataProviderUpdate<Int>.deleteSection(0)
        dataProvider.reconfigure(with: [[]], updates: [deletion])
        
        //Then
        XCTAssertEqual(tableViewMock.deleteSections?.count, 1)
        XCTAssertEqual(tableViewMock.deleteSections?.first, 0)
        XCTAssertEqual(tableViewMock.beginUpdatesCalledCount, 1)
        XCTAssertEqual(tableViewMock.endUpdatesCalledCount, 1)
    }
    
    func testPrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource: UITableViewDataSourcePrefetching = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProviderMock, cell: cell)
        
        //When
        let prefetchedIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.tableView(UITableView(), prefetchRowsAt: prefetchedIndexPaths)
        
        //Then
        XCTAssertEqual(dataProviderMock.prefetchedIndexPaths!, prefetchedIndexPaths)
    }
    
    func testCenclePrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProviderMock, cell: cell)
        
        //When
        let canceldIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.tableView(UITableView(), cancelPrefetchingForRowsAt: canceldIndexPaths)
        
        //Then
        XCTAssertEqual(dataProviderMock.canceledPrefetchedIndexPaths!, canceldIndexPaths)
    }
    
    func testCanMoveCellAtIndexPath() {
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cell: cell, canMoveItemAtIndexPath: { _ in return true })
        
        //Then
        XCTAssertTrue(dataSource.tableView(UITableView(), canMoveRowAt: IndexPath(row: 0, section: 0)))
        
    }
}
