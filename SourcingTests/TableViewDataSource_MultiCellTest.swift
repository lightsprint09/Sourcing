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

// swiftlint:disable force_cast force_try force_unwrapping
class TableViewDataSourceMultiCellTest: XCTestCase {
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
        let cells: [CellConfiguration<UITableViewCellMock<Int>>] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier),
                                      CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: secondCellIdentifier)]

        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, anyCells: cells)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 1)
        XCTAssertNotNil(tableViewMock.dataSource)
        XCTAssertNotNil(tableViewMock.prefetchDataSource)
        XCTAssertEqual(tableViewMock.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let nib = UINib(data: Data(), bundle: nil)
        let cellConfig: [CellDequeable] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier, nib: nib, additionalConfiguartion: nil),
                                           CellConfiguration<UITableViewCellMock<String>>(nib: nib, additionalConfiguartion: nil)]
        
        //When
        let _ = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, anyCells: cellConfig)
        
        //Then
        XCTAssertEqual(tableViewMock.registerdNibs.count, 2)
        XCTAssertNotNil(tableViewMock.registerdNibs[cellIdentifier] as Any)
        XCTAssertNotNil(tableViewMock.registerdNibs[secondCellIdentifier] as Any)
    }

    func testNumberOfSections() {
        //Given
        let cells: [CellDequeable] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier),
                                           CellConfiguration<UITableViewCellMock<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: realTableView, dataProvider: dataProvider, anyCells: cells)
        let sectionCount = dataSource.numberOfSections(in: realTableView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let cells: [CellDequeable] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier),
                                      CellConfiguration<UITableViewCellMock<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(tableView: realTableView, dataProvider: dataProvider, anyCells: cells)
        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 1)
    }

    func testDequCells() {
        //Given
        var didCallAdditionalConfiguartion = false
        let cellConfig: [CellDequeable] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier, additionalConfiguartion: { _, _ in
            didCallAdditionalConfiguartion = true
        }), CellConfiguration<UITableViewCellMock<String>>(cellIdentifier: secondCellIdentifier)]
        let realTableView = UITableView()
        let mockCells = [cellIdentifier: UITableViewCellMock<Int>(), secondCellIdentifier: UITableViewCellMock<String>()]
        let tableViewMock = UITableViewMock(mockTableViewCells: mockCells)
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, anyCells: cellConfig)
        
        let intCell = dataSource.tableView(realTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let stringCell = dataSource.tableView(realTableView, cellForRowAt: IndexPath(row: 0, section: 1))
        
        //Then
        let mockIntCell = tableViewMock.cellMocks[cellIdentifier] as! UITableViewCellMock<Int>
        let mockStringCell = tableViewMock.cellMocks[secondCellIdentifier] as! UITableViewCellMock<String>
        XCTAssert(didCallAdditionalConfiguartion)
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 2)
        XCTAssertTrue(intCell is UITableViewCellMock<Int>)
        
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockStringCell.configuredObject, "String")
        XCTAssertTrue(stringCell is UITableViewCellMock<String>)
    }

    func testUpdateDataSourceWithNoData() {
        //Given
        let cellConfig: [CellDequeable] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, anyCells: cellConfig)
        dataSource.process(updates: nil)
        
        //Then
        XCTAssertEqual(tableViewMock.reloadedCount, 2)
    }
    
    func testSectionIndexTitles() {
        //Given
        let cellConfig: [CellDequeable] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, anyCells: cellConfig)
        let realTableView = UITableView()
        let sectionTitles = dataSource.sectionIndexTitles(for: realTableView)
        
        //Then
        XCTAssertEqual(["foo", "bar"], sectionTitles!)
    }
    
    func testSetNewTableView() {
        //Given
        let cellConfig: [CellDequeable] = [CellConfiguration<UITableViewCellMock<Int>>(cellIdentifier: cellIdentifier)]
        let secondTableview = UITableViewMock()
        
        //When
        XCTAssertNil(secondTableview.dataSource)
        let dataSource = TableViewDataSource(tableView: UITableView(), dataProvider: dataProvider, anyCells: cellConfig)
        dataSource.tableView = secondTableview
        //Then
        XCTAssertNotNil(secondTableview.dataSource)
        XCTAssertEqual(secondTableview.reloadedCount, 1)
    }
}
