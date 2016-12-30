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
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, RESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//
//
//  MultiTableViewDataSourceTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 10.08.16.
//

import XCTest
import UIKit
@testable import Sourcing


class TableViewDataSource_MultiCellTest: XCTestCase {
    let cellIdentifier = "cellIdentifier"
    let secondCellIdentifier = "cellIdentifier2"
    
    var dataProvider: ArrayDataProvider<Any>!
    var tableViewMock: UITableViewMock!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider<Any>(sections: [[2], ["String"]], sectionIndexTitles: ["foo", "bar"])
        tableViewMock = UITableViewMock()
    }
    
    func testSetDataSource() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cells: cellConfig)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        XCTAssertNotNil(tableViewMock.dataSource)
        XCTAssertEqual(tableViewMock.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let nib = UINib(data: Data(), bundle: nil)
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nib, additionalConfiguartion: nil), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier, nib: nib, additionalConfiguartion: nil)]
        
        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cells: cellConfig)
        
        //Then
        XCTAssertEqual(tableViewMock.registerdNibs.count, 2)
        XCTAssertNotNil(tableViewMock.registerdNibs[cellIdentifier])
        XCTAssertNotNil(tableViewMock.registerdNibs[secondCellIdentifier])
    }

    func testNumberOfSections() {
        //Given
        let cells: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: realTableView, dataProvider: dataProvider, cells: cells)
        let sectionCount = dataSource.numberOfSections(in: realTableView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let cells: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: realTableView, dataProvider: dataProvider, cells: cells)
        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 1)
    }

    func testDequCells() {
        //Given
        var didCallAdditionalConfiguartion = false
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguartion: { _, _ in
            didCallAdditionalConfiguartion = true
        } ), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        let tableViewMock = UITableViewMock(mockTableViewCells: [cellIdentifier: MockCell<Int>(), secondCellIdentifier: MockCell<String>()])
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cells: cellConfig)
        
        let intCell = dataSource.tableView(realTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let stringCell = dataSource.tableView(realTableView, cellForRowAt: IndexPath(row: 0, section: 1))
        
        //Then
        let mockIntCell = tableViewMock.cellMocks[cellIdentifier] as! MockCell<Int>
        let mockStringCell = tableViewMock.cellMocks[secondCellIdentifier] as! MockCell<String>
        XCTAssert(didCallAdditionalConfiguartion)
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 2)
        XCTAssertTrue(intCell is MockCell<Int>)
        
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockStringCell.configuredObject, "String")
        XCTAssertTrue(stringCell is MockCell<String>)
    }

    func testUpdateDataSource() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cells: cellConfig)
        dataSource.processUpdates([.update(IndexPath(row: 2, section: 1), 100)])
        
        //Then
        let mockIntCell = tableViewMock.cellMocks[cellIdentifier] as! MockCell<Int>
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 100)
    }

    func testUpdateDataSourceWithNoData() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cells: cellConfig)
        dataSource.processUpdates(nil)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 2)
    }
    
    func testSectionIndexTitles() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cells: cellConfig)
        let realTableView = UITableView()
        let sectionTitles = dataSource.sectionIndexTitles(for: realTableView)
        
        //Then
        XCTAssertEqual(["foo", "bar"], sectionTitles!)
    }
    
    func testSetNewTableView() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        let secondTableview = UITableViewMock()
        
        //When
        XCTAssertNil(secondTableview.dataSource)
        let dataSource = TableViewDataSource(tableView: UITableView(), dataProvider: dataProvider, cells: cellConfig)
        dataSource.tableView = secondTableview
        //Then
        XCTAssertNotNil(secondTableview.dataSource)
        XCTAssertEqual(secondTableview.reloadedCount, 1)
    }
}
