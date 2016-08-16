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
//  MultiTableViewDataSourceTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 10.08.16.
//

import XCTest
import UIKit
@testable import Sourcing


class MultiCellTableViewDataSourceTest: XCTestCase {
    let cellIdentifier = "cellIdentifier"
    let secondCellIdentifier = "cellIdentifier2"
    
    func testSetDataSource() {
        //Given
        let dataProvider = ArrayDataProvider(rows: [1])
        let tableView = UITableViewMock()
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let _ = MultiCellTableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequeables: cellConfig)
        
        //Then
        XCTAssertEqual(tableView.reloadedCount, 1)
        XCTAssertNotNil(tableView.dataSource)
        XCTAssertEqual(tableView.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let dataProvider = ArrayDataProvider(rows: [1])
        let tableView = UITableViewMock()
        let nib = UINib(data: NSData(), bundle: nil)
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nib, additionalConfiguartion: nil), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier, nib: nib, additionalConfiguartion: nil)]
        
        //When
        let _ = MultiCellTableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequeables: cellConfig)
        
        //Then
        XCTAssertEqual(tableView.registerdNibs.count, 2)
        XCTAssertNotNil(tableView.registerdNibs[cellIdentifier])
        XCTAssertNotNil(tableView.registerdNibs[secondCellIdentifier])
    }

    func testNumberOfSections() {
        //Given
        let dataProvider = ArrayDataProvider(sections: [[2], ["String"]])
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        
        //When
        let dataSource = MultiCellTableViewDataSource(tableView: realTableView, dataProvider: dataProvider, cellDequeables: cellConfig)
        let sectionCount = dataSource.numberOfSectionsInTableView(realTableView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let dataProvider = ArrayDataProvider(sections: [[2], ["String"]])
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        
        //When
        let dataSource = MultiCellTableViewDataSource(tableView: realTableView, dataProvider: dataProvider, cellDequeables: cellConfig)
        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 1)
    }

    func testDequCells() {
        //Given
        let dataProvider = ArrayDataProvider(sections: [[2], ["String"]])
        var didCallAdditionalConfiguartion = false
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguartion: { _, _ in
            didCallAdditionalConfiguartion = true
        } ), CellConfiguration<MockCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        let tableViewMock = UITableViewMock(mockCells: [cellIdentifier: MockCell<Int>(), secondCellIdentifier: MockCell<String>()])
        
        //When
        let dataSource = MultiCellTableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        let intCell = dataSource.tableView(realTableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        let stringCell = dataSource.tableView(realTableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        
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
        let dataProvider = ArrayDataProvider(rows: [1])
        let tableViewMock = UITableViewMock()
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = MultiCellTableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        dataSource.processUpdates([.Update(NSIndexPath(forRow: 2, inSection: 1), 100)])
        
        //Then
        let mockIntCell = tableViewMock.cellMocks[cellIdentifier] as! MockCell<Int>
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 100)
    }

    func testUpdateDataSourceWithNoData() {
        //Given
        let dataProvider = ArrayDataProvider(rows: [1])
        let tableViewMock = UITableViewMock()
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = MultiCellTableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        dataSource.processUpdates(nil)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 2)
    }
}
