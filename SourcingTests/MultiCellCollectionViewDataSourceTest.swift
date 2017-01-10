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
//  MultiCellCollectionViewDataSourceTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 25.08.16.
//

import XCTest
@testable import Sourcing
// swiftlint:disable force_cast

class MultiCellCollectionViewDataSourceTest: XCTestCase {

    let cellIdentifier = "cellIdentifier"
    let secondCellIdentifier = "cellIdentifier2"
    
    var dataProvider: ArrayDataProvider<Any>!
    var collectionViewMock: UICollectionViewMock!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], ["String"]])
        collectionViewMock = UICollectionViewMock()
    }
    
    func testSetDataSource() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let _ = MultiCellCollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        
        //Then
        XCTAssertEqual(collectionViewMock.reloadedCount, 1)
        XCTAssertNotNil(collectionViewMock.dataSource)
        XCTAssertEqual(collectionViewMock.registerdNibs.count, 0)
    }
    
    func testRegisterNib() {
        //Given
        let nib = UINib(data: Data(), bundle: nil)
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier, nib: nib, additionalConfiguartion: nil),
                          CellConfiguration<MockCollectionCell<String>>(cellIdentifier: secondCellIdentifier, nib: nib, additionalConfiguartion: nil)]
        
        //When
        let _ = MultiCellCollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        
        //Then
        XCTAssertEqual(collectionViewMock.registerdNibs.count, 2)
        XCTAssertNotNil(collectionViewMock.registerdNibs[cellIdentifier])
        XCTAssertNotNil(collectionViewMock.registerdNibs[secondCellIdentifier])
    }
    
    func testNumberOfSections() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier),
                          CellConfiguration<MockCollectionCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = MultiCellCollectionViewDataSource(collectionView: realCollectionView, dataProvider: dataProvider, cellDequeables: cellConfig)
        let sectionCount = dataSource.numberOfSections(in: realCollectionView)
        
        //Then
        XCTAssertEqual(sectionCount, 2)
    }

    func testNumberOfRowsInSections() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier),
                          CellConfiguration<MockCollectionCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        //When
        let dataSource = MultiCellCollectionViewDataSource(collectionView: realCollectionView, dataProvider: dataProvider, cellDequeables: cellConfig)
        let rowCount = dataSource.collectionView(realCollectionView, numberOfItemsInSection: 0)
        
        //Then
        XCTAssertEqual(rowCount, 1)
    }

    func testDequCells() {
        //Given
        var didCallAdditionalConfiguartion = false
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier, nib: nil, additionalConfiguartion: { _, _ in
            didCallAdditionalConfiguartion = true
        } ), CellConfiguration<MockCollectionCell<String>>(cellIdentifier: secondCellIdentifier)]
        let realCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let collectionViewMock = UICollectionViewMock(mockCollectionViewCells: [cellIdentifier: MockCollectionCell<Int>(), secondCellIdentifier: MockCollectionCell<String>()])
        
        //When
        let dataSource = MultiCellCollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        let intCell = dataSource.collectionView(realCollectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        let stringCell = dataSource.collectionView(realCollectionView, cellForItemAt:  IndexPath(row: 0, section: 1))
        
        //Then
        let mockIntCell = collectionViewMock.cellMocks[cellIdentifier] as! MockCollectionCell<Int>
        let mockStringCell = collectionViewMock.cellMocks[secondCellIdentifier] as! MockCollectionCell<String>
        XCTAssert(didCallAdditionalConfiguartion)
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 2)
        XCTAssertTrue(intCell is MockCollectionCell<Int>)
        
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockStringCell.configuredObject, "String")
        XCTAssertTrue(stringCell is MockCollectionCell<String>)
    }

    func testUpdateDataSource() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = MultiCellCollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        dataSource.processUpdates([.update(IndexPath(row: 2, section: 1), 100)])
        
        //Then
        let mockIntCell = collectionViewMock.cellMocks[cellIdentifier] as! MockCollectionCell<Int>
        XCTAssertEqual(collectionViewMock.reloadedCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 100)
    }

    func testUpdateDataSourceWithNoData() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)]
        
        //When
        let dataSource = MultiCellCollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        dataSource.processUpdates(nil)
        
        //Then
        XCTAssertEqual(collectionViewMock.reloadedCount, 2)
    }
    
    func testSetNewCollectionView() {
        //Given
        let cellConfig: Array<CellDequeable> = [CellConfiguration<MockCollectionCell<Int>>(cellIdentifier: cellIdentifier)]
        let collectionViewMock = UICollectionViewMock()
        let secondCollectionViewMock = UICollectionViewMock()
        
        //When
        XCTAssertNil(secondCollectionViewMock.dataSource)
        let dataSource = MultiCellCollectionViewDataSource(collectionView: collectionViewMock, dataProvider: dataProvider, cellDequeables: cellConfig)
        dataSource.collectionView = secondCollectionViewMock
        //Then
        XCTAssertNotNil(secondCollectionViewMock.dataSource)
        XCTAssertEqual(secondCollectionViewMock.reloadedCount, 1)
    }
}
