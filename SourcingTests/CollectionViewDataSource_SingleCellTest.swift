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

    let cellIdentifier = "cellIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var dataModificator: DataModificatorMock!
    var collectionViewMock: UICollectionViewMock!
    var cell: CellConfiguration<UICollectionViewCellMock<Int>>!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        collectionViewMock = UICollectionViewMock()
        cell = CellConfiguration(cellIdentifier: cellIdentifier)
        dataModificator = DataModificatorMock()
    }

    func testNumberOfSections() {
        //Given
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cell: cell)
        
        //When
        let sectionCount = dataSource.numberOfSections(in: collectionViewMock)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cell: cell)
        
        //When
        let rowCount = dataSource.collectionView(collectionViewMock, numberOfItemsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 3)
    }

    func testDequeCells() {
        //Given
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, cell: cell)
        let indexPath = IndexPath(row: 2, section: 1)
        
        //When
        let cellAtIdexPath = dataSource.collectionView(collectionViewMock, cellForItemAt: indexPath)
        
        //Then
        let mockCell = (collectionViewMock.cellDequeueMock.cells[cellIdentifier] as! UICollectionViewCellMock<Int>)
        XCTAssertEqual(mockCell.configurationCount, 1)
        XCTAssertEqual(mockCell.configuredObject, 10)
        XCTAssertEqual(collectionViewMock.cellDequeueMock.dequeueCellReuseIdentifiers.first, cellIdentifier)
        XCTAssertTrue(cellAtIdexPath is UICollectionViewCellMock<Int>)
    }
    
    func testMoveIndexPaths() {
        //Given
        let cellConfig = CellConfiguration<UICollectionViewCellMock<Int>>(cellIdentifier: cellIdentifier)
        let dataProviderMock = DataProviderMock<Int>()
        
        //When
        let dataSource = CollectionViewDataSource(dataProvider: dataProviderMock,
                                                  cell: cellConfig, dataModificator: dataModificator)
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.collectionView(collectionViewMock, moveItemAt: fromIndexPath, to: toIndexPath)
        
        //Then
        XCTAssertEqual(dataModificator.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataModificator.destinationIndexPath, toIndexPath)
    }
    
    @available(iOS 10.0, *)
    func testPrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = CollectionViewDataSource(dataProvider: dataProviderMock, cell: cell)
        
        //When
        let prefetchedIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.collectionView(collectionViewMock, prefetchItemsAt: prefetchedIndexPaths)
        
        //Then
        guard let resultingPrefetchedIndexPaths = dataProviderMock.prefetchedIndexPaths else {
            return XCTFail("Did not use given prefatch indexPaths")
        }
        XCTAssertEqual(resultingPrefetchedIndexPaths, prefetchedIndexPaths)
    }
    
    @available(iOS 10.0, *)
    func testCenclePrefetchItemsAtIndexPaths() {
        //Given
        let dataProviderMock = DataProviderMock<Int>()
        let dataSource = CollectionViewDataSource(dataProvider: dataProviderMock, cell: cell)
        
        //When
        let canceldIndexPaths = [IndexPath(row: 0, section: 0)]
        dataSource.collectionView(collectionViewMock, cancelPrefetchingForItemsAt: canceldIndexPaths)
        
        //Then
        guard let resultingPrefetchedIndexPaths = dataProviderMock.canceledPrefetchedIndexPaths else {
            return XCTFail("Did not use given prefatch indexPaths")
        }
        XCTAssertEqual(resultingPrefetchedIndexPaths, canceldIndexPaths)
    }
    
    func testCanMoveCellAtIndexPath() {
        
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider,
                                                  cell: cell, dataModificator: dataModificator)
        //When
        dataModificator.canMoveItemAt = true
        
        //Then
        let indexPath = IndexPath(item: 0, section: 0)
        let dataSourceCanMoveItem = dataSource.collectionView(collectionViewMock, canMoveItemAt: indexPath)
        XCTAssertTrue(dataSourceCanMoveItem)
    }
}
