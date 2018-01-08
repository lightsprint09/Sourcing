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
//  Created by Lukas Schmidt on 25.08.16.
//

import XCTest
import Sourcing
// swiftlint:disable force_cast

class CollectionViewDataSourceMultiCellTest: XCTestCase {
    var dataProvider: ArrayDataProvider<Any>!
    var collectionViewMock: UICollectionViewMock!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[2], ["String"]])
        collectionViewMock = UICollectionViewMock()
    }
    
    func testInitStronglyTypedMultiCell() {
        //Given
        let reuseIdentifier = "reuseIdentifier"
        let secondCellIdentifier = "cellIdentifier2"
        let cellConfig: [BasicReuseableViewConfiguration<UICollectionViewCellMock<Int>, Int>] =
            [.init(reuseIdentifier: reuseIdentifier), .init(reuseIdentifier: secondCellIdentifier)]
        
        //When
        _ = CollectionViewDataSource(dataProvider: ArrayDataProvider(sections: [[2], [2]]), cellConfigurations: cellConfig)
        
    }

    func testDequeCells() {
        //Given
        let reuseIdentifier = "reuseIdentifier"
        let secondCellIdentifier = "cellIdentifier2"
        let cellConfig: [ReuseableViewConfiguring] = [BasicReuseableViewConfiguration<UICollectionViewCellMock<Int>, Int>(reuseIdentifier: reuseIdentifier),
                                             BasicReuseableViewConfiguration<UICollectionViewCellMock<String>, String>(reuseIdentifier: secondCellIdentifier)]
        let collectionViewMock = UICollectionViewMock(mockCollectionViewCells: [reuseIdentifier: UICollectionViewCellMock<Int>(),
                                                                                secondCellIdentifier: UICollectionViewCellMock<String>()])
        
        //When
        let dataSource = CollectionViewDataSource(dataProvider: dataProvider, anyCellConfigurations: cellConfig)
        let intCell = dataSource.collectionView(collectionViewMock, cellForItemAt: IndexPath(row: 0, section: 0))
        let stringCell = dataSource.collectionView(collectionViewMock, cellForItemAt: IndexPath(row: 0, section: 1))
        
        //Then
        let mockIntCell = collectionViewMock.cellDequeueMock.cells[reuseIdentifier] as! UICollectionViewCellMock<Int>
        let mockStringCell = collectionViewMock.cellDequeueMock.cells[secondCellIdentifier] as! UICollectionViewCellMock<String>
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockIntCell.configuredObject, 2)
        XCTAssertTrue(intCell is UICollectionViewCellMock<Int>)
        
        XCTAssertEqual(mockIntCell.configurationCount, 1)
        XCTAssertEqual(mockStringCell.configuredObject, "String")
        XCTAssertTrue(stringCell is UICollectionViewCellMock<String>)
    }

}
