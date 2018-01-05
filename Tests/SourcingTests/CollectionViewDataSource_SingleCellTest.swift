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
//  CollectionViewDataSourceTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 22.08.16.
//

import XCTest
import UIKit
import Sourcing

// swiftlint:disable force_cast
class CollectionViewDataSourceSingleCellTest: XCTestCase {

    let reuseIdentifier = "reuseIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var dataModificator: DataModificatorMock!
    var collectionViewMock: UICollectionViewMock!
    var cell: CellConfiguration<UICollectionViewCellMock<Int>>!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        collectionViewMock = UICollectionViewMock()
        cell = CellConfiguration(reuseIdentifier: reuseIdentifier)
        dataModificator = DataModificatorMock()
    }

    func testNumberOfSections() {
        //Given
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        
        //When
        let sectionCount = dataSource.numberOfSections(in: collectionViewMock)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        
        //When
        let rowCount = dataSource.collectionView(collectionViewMock, numberOfItemsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 3)
    }

    func testDequeCells() {
        //Given
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        let indexPath = IndexPath(row: 2, section: 1)
        
        //When
        let cellAtIdexPath = dataSource.collectionView(collectionViewMock, cellForItemAt: indexPath)
        
        //Then
        let mockCell = (collectionViewMock.cellDequeueMock.cells[reuseIdentifier] as! UICollectionViewCellMock<Int>)
        XCTAssertEqual(mockCell.configurationCount, 1)
        XCTAssertEqual(mockCell.configuredObject, 10)
        XCTAssertEqual(collectionViewMock.cellDequeueMock.dequeueCellReuseIdentifiers.first, reuseIdentifier)
        XCTAssertTrue(cellAtIdexPath is UICollectionViewCellMock<Int>)
    }
    
    func testDequeSupplementaryView() {
        //Given
        let elementKind = "elementKind"
        var configuredObject: Int?
        var configurationCount = 0
        let supplemenaryViewConfiguration = BasicSupplementaryViewConfiguration<SupplementaryViewMock, Int>(elementKind: elementKind,
                                                                                                            configuration: { (_, _, object) in
            configuredObject = object
            configurationCount += 1
        })
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cellConfiguration: cell,
                                                  supplementaryViewConfigurations: [supplemenaryViewConfiguration])
        let indexPath = IndexPath(row: 2, section: 1)
        
        //When
        _ = dataSource.collectionView(collectionViewMock, viewForSupplementaryElementOfKind: elementKind, at: indexPath)
        
        //Then
        XCTAssertEqual(configurationCount, 1)
        XCTAssertEqual(configuredObject, 10)
    }
    
    func testIndexTitles() {
        //Given
        let indexTitles = StaticSectionTitlesProvider(sectionIndexTitles: ["First"])
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cellConfiguration: cell, sectionIndexTitleProvider: indexTitles)
        
        //When
        let computedIndexTitles = dataSource.indexTitles(for: collectionViewMock)
        XCTAssertNotNil(computedIndexTitles)
    }
    
    func testSectionForSectionIndexTitle() {
        //Given
        let indexHeaders = ["foo", "bar"]
        let sectionTitleProvider = StaticSectionTitlesProvider(sectionIndexTitles: indexHeaders)
        let dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cellConfiguration: cell, sectionIndexTitleProvider: sectionTitleProvider)
        
        //When
        let indexPath = dataSource.collectionView(collectionViewMock, indexPathForIndexTitle: "bar", at: 1)
        
        //Then
        XCTAssertEqual(indexPath.section, 1)
    }
    
    func testMoveIndexPaths() {
        //Given
        let cellConfig = CellConfiguration<UICollectionViewCellMock<Int>>(reuseIdentifier: reuseIdentifier)
        let dataProviderMock = ArrayDataProvider<Int>(sections: [[]])
        
        //When
        let dataSource = CollectionViewDataSource(dataProvider: dataProviderMock,
                                                  cellConfiguration: cellConfig, dataModificator: dataModificator)
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.collectionView(collectionViewMock, moveItemAt: fromIndexPath, to: toIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataModificator.destinationIndexPath, toIndexPath)
    }
    
    func testCanMoveCellAtIndexPath() {
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider,
                                                  cellConfiguration: cell, dataModificator: dataModificator)
        //When
        dataModificator.canMoveItemAt = true
        
        //Then
        let indexPath = IndexPath(item: 0, section: 0)
        let dataSourceCanMoveItem = dataSource.collectionView(collectionViewMock, canMoveItemAt: indexPath)
        XCTAssertTrue(dataSourceCanMoveItem)
    }
    
    func testCanMoveCellAtIndexPathWithOutDataModificator() {
        //Given
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cellConfiguration: cell)
        
        //When
        let canMove = dataSource.collectionView(collectionViewMock, canMoveItemAt: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertFalse(canMove)
    }

}
