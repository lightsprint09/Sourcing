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
import Sourcing

// swiftlint:disable force_unwrapping
class ArrayDataProviderTest: XCTestCase {
    var dataProvider: ArrayDataProvider<Int>!
    
    func testNumberOfSections() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        let numberOfSections = dataProvider.numberOfSections()
        
        //Then
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func testNumberOfItemsInSection() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        let numberOfItems = dataProvider.numberOfItems(inSection: 0)
        
        //Then
        XCTAssertEqual(numberOfItems, 2)
    }
    
    func testObjectAtIndexPath() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        let indexPath = IndexPath(item: 0, section: 0)
        let object = dataProvider.object(at: indexPath)
        
        //Then
        XCTAssertEqual(object, 1)
    }
    
    func testSafeAccesToObjectAtIndexPath() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        let indexPath = IndexPath(item: 0, section: 0)
        let object = dataProvider.safeAccessToObject(at: indexPath)
        
        //Then
        XCTAssertEqual(object, 1)
    }
    
    func testSafeAccesToObjectAtIndexPathWithInvalidIndexPath() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        let indexPath = IndexPath(item: 5, section: 5)
        let object = dataProvider.safeAccessToObject(at: indexPath)
        
        //Then
        XCTAssertNil(object)
    }
    
    func testIndexPathForContainingObject() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        let indexPath = dataProvider.indexPath(for: 1)
        
        //Then
        XCTAssertEqual(indexPath, IndexPath(item: 0, section: 0))
    }
    
    func testIndexPathForNotContainingObject() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        let indexPath = dataProvider.indexPath(for: 5)
        
        //Then
        XCTAssertNil(indexPath)
    }
    
    func testCallUpdate() {
        var didUpdate = false
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        _ = dataProvider.observable.addObserver(observer: { _ in
            didUpdate = true
        })
        
        //When
        dataProvider.reconfigure(with: [8, 9, 10])
        
        //Then
        XCTAssertTrue(didUpdate)
    }
    
    func testRefonfigure() {
        //Given
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        
        //When
        dataProvider.reconfigure(with: [8, 9, 10])
        
        //Then
        XCTAssertEqual(dataProvider.content.first!, [8, 9, 10])
    }
    
}
