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
    
    func testSetDataSource() {
        //Given
        let dataProvider = ArrayDataProvider(rows: [1])
        let tableView = UITableViewMock()
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell>(cellIdentifier: "testIdentifier")]
        
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
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCell>(cellIdentifier: "testIdentifier", nib: nib, additionalConfiguartion: nil)]
        
        //When
        let _ = MultiCellTableViewDataSource(tableView: tableView, dataProvider: dataProvider, cellDequeables: cellConfig)
        
        //Then
        XCTAssertEqual(tableView.registerdNibs.count, 1)
        XCTAssertNotNil(tableView.registerdNibs["testIdentifier"])
    }
//
//    func testNumberOfSections() {
//        //Given
//        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3]])
//        let tableViewMock = UITableViewMock()
//        let cellConfig = CellConfiguration<MockCell>(cellIdentifier: "testIdentifier")
//        let realTableView = UITableView()
//        
//        //When
//        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
//        let sectionCount = dataSource.numberOfSectionsInTableView(realTableView)
//        
//        //Then
//        XCTAssertEqual(sectionCount, 2)
//    }
//    
//    func testNumberOfRowsInSections() {
//        //Given
//        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 3]])
//        let tableViewMock = UITableViewMock()
//        let cellConfig = CellConfiguration<MockCell>(cellIdentifier: "testIdentifier")
//        let realTableView = UITableView()
//        
//        //When
//        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
//        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
//        
//        //Then
//        
//        XCTAssertEqual(rowCount, 3)
//    }
//    
//    func testDequCells() {
//        //Given
//        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
//        let tableViewMock = UITableViewMock()
//        let cellConfig = CellConfiguration<MockCell>(cellIdentifier: "testIdentifier")
//        let realTableView = UITableView()
//        
//        //When
//        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
//        let cell = dataSource.tableView(realTableView, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1))
//        
//        //Then
//        XCTAssertEqual(tableViewMock.mockCell.configurationCount, 1)
//        XCTAssertEqual(tableViewMock.mockCell.configuredObject, 10)
//        XCTAssertEqual(tableViewMock.lastUedReuseIdetifier, "testIdentifier")
//        XCTAssertTrue(cell is MockCell)
//    }
//    
//    func testUpdateDataSource() {
//        //Given
//        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
//        let tableViewMock = UITableViewMock()
//        let cellConfig = CellConfiguration<MockCell>(cellIdentifier: "testIdentifier")
//        
//        //When
//        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
//        dataSource.processUpdates([.Update(NSIndexPath(forRow: 2, inSection: 1), 100)])
//        
//        //Then
//        XCTAssertEqual(tableViewMock.reloadedCount, 1)
//        XCTAssertEqual(tableViewMock.mockCell.configuredObject, 100)
//    }
//    
//    func testUpdateDataSourceWithNoData() {
//        //Given
//        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
//        let tableViewMock = UITableViewMock()
//        let cellConfig = CellConfiguration<MockCell>(cellIdentifier: "testIdentifier")
//        
//        //When
//        let dataSource = TableViewDataSource(tableView: tableViewMock, dataProvider: dataProvider, cellDequable: cellConfig)
//        dataSource.processUpdates(nil)
//        
//        //Then
//        XCTAssertEqual(tableViewMock.reloadedCount, 2)
//    }
}
