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
import Sourcing

// swiftlint:disable force_cast
class TableViewDataSourceMultiCellTest: XCTestCase {
    var dataProvider: ArrayDataProvider<Any>!
    var tableViewMock: UITableViewMock!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider<Any>(sections: [[2], ["String"]])
        tableViewMock = UITableViewMock()
    }
    
    func testInitStronglyTypedMultiCell() {
        //Given
        let reuseIdentifier = "reuseIdentifier"
        let secondCellIdentifier = "cellIdentifier2"
        let cellConfig: [ReuseableViewConfiguration<UITableViewCellMock<Int>, Int>] = [.init(reuseIdentifier: reuseIdentifier),
                                                                        .init(reuseIdentifier: secondCellIdentifier)]
        
        //When
        _ = TableViewDataSource(dataProvider: ArrayDataProvider(sections: [[2], [2]]), cellConfigurations: cellConfig)
        
    }

    func testDequeCells() {
        //Given
        let reuseIdentifier = "reuseIdentifier"
        let secondCellIdentifier = "cellIdentifier2"
        let cellConfig: [ReuseableViewConfiguring] = [ReuseableViewConfiguration<UITableViewCellMock<Int>, Int>(reuseIdentifier: reuseIdentifier),
             ReuseableViewConfiguration<UITableViewCellMock<String>, String>(reuseIdentifier: secondCellIdentifier)]
        let mockCells = [reuseIdentifier: UITableViewCellMock<Int>(), secondCellIdentifier: UITableViewCellMock<String>()]
        let tableViewMock = UITableViewMock(mockTableViewCells: mockCells)
        let dataSource = TableViewDataSource(dataProvider: dataProvider, anyCellConfigurations: cellConfig)

        //When
        let intCell = dataSource.tableView(tableViewMock, cellForRowAt: IndexPath(row: 0, section: 0))
        let stringCell = dataSource.tableView(tableViewMock, cellForRowAt: IndexPath(row: 0, section: 1))
        
        //Then
        let mockIntCell = tableViewMock.cellDequeueMock.cells[reuseIdentifier] as! UITableViewCellMock<Int>
        let mockStringCell = tableViewMock.cellDequeueMock.cells[secondCellIdentifier] as! UITableViewCellMock<String>
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 2)
        XCTAssertTrue(intCell is UITableViewCellMock<Int>)
        
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockStringCell.configuredObject, "String")
        XCTAssertTrue(stringCell is UITableViewCellMock<String>)
    }

}
