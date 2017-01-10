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
@testable import Sourcing

// swiftlint:disable force_cast
class CollectionViewDataSourceTest: XCTestCase {

    let cellIdentifier = "cellIdentifier"
    
    var dataProvider: ArrayDataProvider<Int>!
    var collectionViewMock: UICollectionViewMock!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], [1, 3, 10]])
        collectionViewMock = UICollectionViewMock()
    }
    
    func testSetDataSource() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let _ = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        
        //Then
        XCTAssertEqual(collectionViewMock.reloadedCount, 1)
        XCTAssertNotNil(collectionViewMock.dataSource)
        XCTAssertEqual(collectionViewMock.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let nib = UINib(data: Data(), bundle: nil)
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier, nib: nib)
        
        //When
        let _ = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        
        //Then
        XCTAssertEqual(collectionViewMock.registerdNibs.count, 1)
        XCTAssertNotNil(collectionViewMock.registerdNibs[cellIdentifier])
    }

    func testNumberOfSections() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        let sectionCount = dataSource.numberOfSections(in: realCollectionView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        let rowCount = dataSource.collectionView(realCollectionView, numberOfItemsInSection: 1)
        
        //Then
        XCTAssertEqual(rowCount, 3)
    }

    func testDequCells() {
        //Given
        var didCallAdditionalConfiguartion = false
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguartion:  { cell, object in
            didCallAdditionalConfiguartion = true
        })
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        let cell = dataSource.collectionView(realCollectionView, cellForItemAt: IndexPath(row: 2, section: 1))
        
        //Then
        let mockCell = (collectionViewMock.cellMocks[cellIdentifier] as! MockCollectionCell<Int>)
        XCTAssertEqual(mockCell.configurationCount, 1)
        XCTAssertEqual(mockCell.configuredObject, 10)
        XCTAssertEqual(collectionViewMock.lastUsedReuseIdetifiers.first, cellIdentifier)
        XCTAssertTrue(cell is MockCollectionCell<Int>)
        XCTAssertTrue(didCallAdditionalConfiguartion)
    }

    func testUpdateDataSource() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        dataSource.processUpdates([.update(IndexPath(row: 2, section: 1), 100)])
        
        //Then
        XCTAssertEqual(collectionViewMock.reloadedCount, 1)
        let mockCell = (collectionViewMock.cellMocks[cellIdentifier] as! MockCollectionCell<Int>)
        XCTAssertEqual(mockCell.configuredObject, 100)
    }

    func testUpdateDataSourceWithNoData() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        dataSource.processUpdates(nil)
        
        //Then
        XCTAssertEqual(collectionViewMock.reloadedCount, 2)
    }
    
    func testSelectedObject() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        collectionViewMock.selectedIndexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 2, section: 1)]
        let selectedObjects = dataSource.selectedObjects
        
        //Then
        XCTAssertEqual(selectedObjects!, [2, 10])
    }
    
    func testNoSelectedObject() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        let selectedObject = dataSource.selectedObjects
        
        //Then
        XCTAssertNil(selectedObject)
    }
    
    func testSetNewCollectionView() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        let collectionViewMock = UICollectionViewMock()
        let secondCollectionViewMock = UICollectionViewMock()
        
        //When
        XCTAssertNil(secondCollectionViewMock.dataSource)
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeable: cellConfig)
        dataSource.collectionView = secondCollectionViewMock
        //Then
        XCTAssertNotNil(secondCollectionViewMock.dataSource)
        XCTAssertEqual(secondCollectionViewMock.reloadedCount, 1)
    }

    func testMoveIndexPaths() {
        //Given
        let cellConfig = CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let dataProviderMock = DataProviderMock<Int>()
        
        //When
        let dataSource = CollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProviderMock, cellDequeable: cellConfig)
        let fromIndexPath = IndexPath(row: 0, section: 1)
        let toIndexPath = IndexPath(row: 1, section: 0)
        dataSource.collectionView(realCollectionView, moveItemAt: fromIndexPath, to: toIndexPath)
        

        //Then
        XCTAssertEqual(dataProviderMock.sourceIndexPath, fromIndexPath)
        XCTAssertEqual(dataProviderMock.destinationIndexPath, toIndexPath)
    }
}
