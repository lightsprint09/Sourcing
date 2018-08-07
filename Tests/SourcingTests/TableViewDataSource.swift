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

import XCTest
import UIKit
import Sourcing

class TableViewDataSourceSingleCellTest: XCTestCase {
    
    let reuseIdentifier = "reuseIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var dataModificator: DataModificatorMock!
    var tableViewMock: UITableViewMock!
    var cell: ReusableViewConfiguration<UITableViewCellMock<Int>, Int>!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        tableViewMock = UITableViewMock()
        cell = ReusableViewConfiguration(reuseIdentifier: reuseIdentifier)
        dataModificator = DataModificatorMock()
    }
    
    func testNumberOfSections() {
        //Given
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        let sectionCount = dataSource.numberOfSections(in: realTableView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }
    
    func testNumberOfRowsInSections() {
        //Given
        let realTableView = UITableView()
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        let rowCount = dataSource.tableView(realTableView, numberOfRowsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 3)
    }
    
    func testDequeCells() {
        //Given
        let cell = ReusableViewConfiguration<UITableViewCellMock<Int>, Int>(reuseIdentifier: reuseIdentifier)
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        let cellForGivenRow = dataSource.tableView(tableViewMock, cellForRowAt: IndexPath(row: 2, section: 1))
        
        //Then
        let tableViewCell = tableViewMock.cellDequeueMock.cells[reuseIdentifier]
        guard let uiTableViewCellMock = tableViewCell as? UITableViewCellMock<Int> else {
            XCTFail("Cell must must be of type UITableViewCellMock<Int> but was of type \(String(describing: tableViewCell.self))")
            return
        }

        XCTAssertEqual(uiTableViewCellMock.configurationCount, 1)
        XCTAssertEqual(uiTableViewCellMock.configuredObject, 10)
        XCTAssertEqual(tableViewMock.cellDequeueMock.dequeueCellReuseIdentifiers.first, reuseIdentifier)
        XCTAssertTrue(cellForGivenRow is UITableViewCellMock<Int>)
    }
    
    func testMoveIndexPaths() {
        //Given
        let cellConfig = ReusableViewConfiguration<UITableViewCellMock<Int>, Int>(reuseIdentifier: reuseIdentifier)
        let dataProviderMock = ArrayDataProvider<Int>(sections: [[]])
        let dataSource = TableViewDataSource(dataProvider: dataProviderMock,
                                             cellConfiguration: cellConfig, dataModificator: dataModificator)
        
        //When
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.tableView(tableViewMock, moveRowAt: fromIndexPath, to: toIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataModificator.destinationIndexPath, toIndexPath)
        XCTAssertFalse(dataModificator.updateView ?? true)
    }
    
    func testCanMoveCellAtIndexPath() {
        //Given
        dataModificator.canMoveItemAt = true
        
        //When
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell, dataModificator: dataModificator)
        
        //Then
        XCTAssertTrue(dataSource.tableView(tableViewMock, canMoveRowAt: IndexPath(row: 0, section: 0)))
        
    }
    
    func testCanMoveCellAtIndexPathWithOutDataModificator() {
        //Given
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        
        //When
        let canMove = dataSource.tableView(tableViewMock, canMoveRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertFalse(canMove)
    }
    
    func testCanDeleteCell() {
        //Given
        dataModificator.canDeleteItemAt = true
         let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell, dataModificator: dataModificator)
        
        //When
        let canDelete = dataSource.tableView(tableViewMock, canEditRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssert(canDelete)
    }
    
    func testCanDeleteCellWithOutDataModificator() {
        //Given
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        
        //When
        let canDelete = dataSource.tableView(tableViewMock, canEditRowAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertFalse(canDelete)
    }
    
    func testDeleteCell() {
        //Given
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell, dataModificator: dataModificator)
        let deletedIndexPath = IndexPath(row: 0, section: 0)
        
        //When
        dataSource.tableView(tableViewMock, commit: .delete, forRowAt: deletedIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.deletedIndexPath, deletedIndexPath)
    }
    
    func testInsertCell() {
        //Given
        let dataSource = TableViewDataSource(dataProvider: dataProvider, cellConfiguration: cell, dataModificator: dataModificator)
        let insertedIndexPath = IndexPath(row: 0, section: 0)
        
        //When
        dataSource.tableView(tableViewMock, commit: .insert, forRowAt: insertedIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.insertedIndexPath, insertedIndexPath)
    }
    
    func testTitleForHeaderInSection() {
        //Given
        let sectionMetaData = SectionMetdaData(headerTexts: ["foo", "bar"] as [String?])
        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        let dataSource = TableViewDataSource(dataProvider: dataProvider,
                                             cellConfiguration: cell,
                                             sectionMetaData: sectionMetaData)
        
        //When
        let sectionTitle = dataSource.tableView(tableViewMock, titleForHeaderInSection: 1)
        
        //Then
        XCTAssertEqual(sectionTitle, "bar")
    }
    
    func testTitleForFooterInSection() {
        //Given
        let sectionMetaData = SectionMetdaData(footerTexts: ["foo", "bar"] as [String?])
        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        let dataSource = TableViewDataSource(dataProvider: dataProvider,
                                             cellConfiguration: cell,
                                             sectionMetaData: sectionMetaData)
        
        //When
        let sectionTitle = dataSource.tableView(tableViewMock, titleForFooterInSection: 1)
        
        //Then
        XCTAssertEqual(sectionTitle, "bar")
    }
    
    func testSectionIndexTitles() {
        //Given
        let sectionIndexTitles = ["foo", "bar"]
        let sectionMetaData = SectionMetdaData(indexTitles: sectionIndexTitles)
        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        let dataSource = TableViewDataSource(dataProvider: dataProvider,
                                             cellConfiguration: cell,
                                             sectionMetaData: sectionMetaData)
        
        //When
        let computedSectionIndexes = dataSource.sectionIndexTitles(for: tableViewMock)
        
        //Then
        XCTAssertEqual(computedSectionIndexes, sectionIndexTitles)
    }
    
    func testSectionForSectionIndexTitle() {
        //Given
        let sectionIndexTitles = ["foo", "bar"]
        let sectionMetaData = SectionMetdaData(indexTitles: sectionIndexTitles)
        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        let dataSource = TableViewDataSource(dataProvider: dataProvider,
                                             cellConfiguration: cell,
                                             sectionMetaData: sectionMetaData)
        
        //When
        let section = dataSource.tableView(tableViewMock, sectionForSectionIndexTitle: "bar", at: 1)
        
        //Then
        XCTAssertEqual(section, 1)
    }

}
