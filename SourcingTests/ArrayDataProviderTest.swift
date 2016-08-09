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
//  ArrayDataProviderTest.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 08.08.16.
//

import XCTest
@testable import Sourcing

class ArrayDataProviderTest: XCTestCase {
    var dataProvider: ArrayDataProvider<Int>!
    
    func testDataSource() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1,2], [3, 4]])
        
        //Then
        let dataExpection = DataProviderExpection(rowsAtSection: (numberOfItems: 2, atSection: 1), sections: 2, objectIndexPath: (object: 4, atIndexPath: NSIndexPath(forRow: 1, inSection: 1)), notContainingObject: 100)
        let dataProviderTest = DataProvidingTester(dataProvider: dataProvider, providerConfiguration: dataExpection)
        dataProviderTest.test()
    }
    
    func testCallUpdate() {
        var didUpdate = false
        //Given
        dataProvider = ArrayDataProvider(sections: [[1,2], [3, 4]], dataProviderDidUpdate: { update in
            didUpdate = true
        })
        //When
        dataProvider.reconfigureData([8, 9, 10])
        
        //Then
        XCTAssertTrue(didUpdate)
        let dataExpection = DataProviderExpection(rowsAtSection: (numberOfItems: 3, atSection: 0), sections: 1, objectIndexPath: (object: 9, atIndexPath: NSIndexPath(forRow: 1, inSection: 0)), notContainingObject: 100)
        let dataProviderTest = DataProvidingTester(dataProvider: dataProvider, providerConfiguration: dataExpection)
        dataProviderTest.test()
    }
}