//
//  Copyright (C) DB Systel GmbH.
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

@MainActor
class LazyTranformationDataProviderTest: XCTestCase {
   
    func testGIVEN_TransformedDataProvider_WHEN_getNumberOfSections_THEN_SameAsWrappedDataProvider() {
        // GIVEN
        let dataProvider = ArrayDataProvider(rows: [1, 2, 3])
        let transformedDataProvider = dataProvider.lazyTransform { "\($0)" }
        // WHEN
        let numberOfSections = transformedDataProvider.numberOfSections()
        
        // THEN
        XCTAssertEqual(numberOfSections, dataProvider.numberOfSections())
    }
    
    func testGIVEN_TransformedDataProvider_WHEN_getNumberOfItemsInSections_THEN_SameAsWrappedDataProvider() {
        // GIVEN
        let dataProvider = ArrayDataProvider(rows: [1, 2, 3])
        let transformedDataProvider = dataProvider.lazyTransform { "\($0)" }
        // WHEN
        let numberOfItemsInSections = transformedDataProvider.numberOfItems(inSection: 0)
        
        // THEN
        XCTAssertEqual(numberOfItemsInSections, dataProvider.numberOfItems(inSection: 0))
    }
    
    func testGIVEN_TransformedDataProvider_WHEN_ObjectAtElement_THEN_ObjectShouldBeWrapped() {
        // GIVEN
        let dataProvider = ArrayDataProvider(rows: [1, 2, 3])
        let transformedDataProvider = dataProvider.lazyTransform { "\($0)" }

        // WHEN
        let object = transformedDataProvider.object(at: IndexPath(row: 0, section: 0))
        
        // THEN
        XCTAssertEqual(object, "1")
    }
    
    func testGIVEN_TransformedDataProvider_WHEN_WrappedDataProviderChanges_THEN_ChangeMustBeProagated() {
        // GIVEN
        let dataProvider = ArrayDataProvider(rows: [1, 2, 3])
        let transformedDataProvider = dataProvider.lazyTransform { "\($0)" }

        var capturedChange: DataProviderChange?
        _ = transformedDataProvider.observable.addObserver { capturedChange = $0 }
        
        // WHEN
        dataProvider.reconfigure(with: [Int]())
        
        // THEN
        if case .unknown? = capturedChange {
            
        } else {
            XCTFail("Must propagate change")
        }
    }
    
}
