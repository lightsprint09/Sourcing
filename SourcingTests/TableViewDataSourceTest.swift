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
// swiftlint:disable force_cast

class TableViewDataSourceTest: XCTestCase {
    
    let cellIdentifier = "cellIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var tableViewMock: UITableViewMock!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]], sectionIndexTitles: ["foo", "bar"])
        tableViewMock = UITableViewMock()
    }
    
    func testSetDataSource() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        XCTAssertNotNil(tableViewMock.dataSource)
        XCTAssertEqual(tableViewMock.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let nib = UINib(data: Data(), bundle: nil)
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nib)
        
        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        
        //Then
        XCTAssertEqual(tableViewMock.registerdNibs.count, 1)
        XCTAssertNotNil(tableViewMock.registerdNibs[cellIdentifier])
    }
    
    func testNumberOfSections() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        let sectionCount = dataSource.numberOfSections(in: realTableView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }
    
    func testNumberOfRowsInSections() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
        
        //Then
        
        XCTAssertEqual(rowCount, 3)
    }
    
    func testDequCells() {
        //Given
        var didCallAdditionalConfiguartion = false
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguartion:  { cell, object in
            didCallAdditionalConfiguartion = true
        })
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        let cell = dataSource.tableView(realTableView, cellForRowAt: IndexPath(row: 2, section: 1))
        
        //Then
        let mockCell = (tableViewMock.cellMocks[cellIdentifier] as! MockCell<Int>)
        XCTAssertEqual(mockCell.configurationCount, 1)
        XCTAssertEqual(mockCell.configuredObject, 10)
        XCTAssertEqual(tableViewMock.lastUsedReuseIdetifiers.first, cellIdentifier)
        XCTAssertTrue(cell is MockCell<Int>)
        XCTAssertTrue(didCallAdditionalConfiguartion)
    }
    
//    func testDequInvalidCells() {
//        //Given
//        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
//        tableViewMock = UITableViewMock(mockTableViewCells: [cellIdentifier: UITableViewCell()])
//        let realTableView = UITableView()
//        
//        //When
//        expectFatalError("Wrong Cell type. Expects MockCell<Int> but got UITableViewCell") {
//            let dataSource = TableViewDataSource(tableView: self.tableViewMock, dataProvider: self.dataProvider, cellDequable: cellConfig)
//            let _ = dataSource.tableView(realTableView, cellForRowAt: IndexPath(row: 2, section: 1))
//        }
//    }
    
    func testUpdateDataSource() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        dataSource.processUpdates([.update(IndexPath(row: 2, section: 1), 100)])
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        let mockCell = (tableViewMock.cellMocks[cellIdentifier] as! MockCell<Int>)
        XCTAssertEqual(mockCell.configuredObject, 100)
    }
    
    func testUpdateDataSourceWithNoData() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        dataSource.processUpdates(nil)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 2)
    }
    
    func testSelectedObject() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        tableViewMock.indexPathForSelectedRow = IndexPath(row: 0, section: 0)
        let selectedObject = dataSource.selectedObject
        
        //Then
        XCTAssertEqual(selectedObject, 2)
    }
    
    func testNoSelectedObject() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        let selectedObject = dataSource.selectedObject
        
        //Then
        XCTAssertNil(selectedObject)
    }
    
    func testSectionIndexTitles() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
        let sectionTitles = dataSource.sectionIndexTitles(for: realTableView)
        
        //Then
        XCTAssertEqual(["foo", "bar"], sectionTitles!)
    }
    
    func testSetNewTableView() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        let secondTableview = UITableViewMock()
        
        //When
        XCTAssertNil(secondTableview.dataSource)
        let dataSource = TableViewDataSource(tableView:  UITableView(), dataProvider: dataProvider, cellDequable: cellConfig)
        dataSource.tableView = secondTableview
        //Then
        XCTAssertNotNil(secondTableview.dataSource)
        XCTAssertEqual(secondTableview.reloadedCount, 1)
    }
    
    func testMoveIndexPaths() {
        //Given
        let cellConfig = CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)
        let dataProviderMock = DataProviderMock<Int>()
        
        //When
        let dataSource = TableViewDataSource(tableView: UITableView(), dataProvider: dataProviderMock, cellDequable: cellConfig)
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.tableView(UITableView(), moveRowAt: fromIndexPath, to: toIndexPath)
        
        
        //Then
        XCTAssertEqual(dataProviderMock.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataProviderMock.destinationIndexPath, toIndexPath)
    }
}
