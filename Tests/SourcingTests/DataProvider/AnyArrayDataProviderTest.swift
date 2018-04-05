//
//  Copyright (C) 2017 Lukas Schmidt.
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

import Foundation
import XCTest
import Sourcing

class AnyArrayDataProviderTest: XCTestCase {

    func testContents() {
        //Given
        let contents = ["ICE", "TGV"]
        let arrayDataProvider = ArrayDataProvider(rows: contents)

        //When
        let anyArrayDataProvider = AnyCollectionDataProvider(arrayDataProvider)

        //Then
        guard let section = anyArrayDataProvider.content.first else {
            XCTFail("Needs a first section")
            return
        }
        XCTAssertEqual(Array(section), contents)
    }
    
    func testNumberOfItemsInSection() {
        //Given
        let contents = ["ICE", "TGV"]
        let arrayDataProvider = ArrayDataProvider(rows: contents)
        
        //When
        let numberItems = AnyCollectionDataProvider(arrayDataProvider).numberOfItems(inSection: 0)
        
        //Then
        XCTAssertEqual(numberItems, 2)
    }
    
    func testNumberOfSections() {
        //Given
        let contents = ["ICE", "TGV"]
        let arrayDataProvider = ArrayDataProvider(rows: contents)
        
        //When
        let numberOfSections = AnyCollectionDataProvider(arrayDataProvider).numberOfSections()
        
        //Then
        XCTAssertEqual(numberOfSections, 1)
    }
    
    func testObjectAtIndexPath() {
        //Given
        let contents = ["ICE", "TGV"]
        let arrayDataProvider = ArrayDataProvider(rows: contents)
        
        //When
        let object = AnyCollectionDataProvider(arrayDataProvider).object(at: IndexPath(item: 0, section: 0))
        
        //Then
        XCTAssertEqual(object, "ICE")
    }

    func testSetWhenDataProviderChanged() {
        //Given
        let contents = ["ICE", "TGV"]
        let arrayDataProvider = ArrayDataProvider(rows: contents)
        let anyArrayDataProvider = AnyCollectionDataProvider(arrayDataProvider)

        //When
        var calledWhenChanges = false
        _ = anyArrayDataProvider.observable.addObserver(observer: { _ in
            calledWhenChanges = true
        })
        arrayDataProvider.reconfigure(with: [[]])

        //Then
        XCTAssert(calledWhenChanges)
    }
    
    func testPerformanceOfObjectAtIndex() {
        //Given
        let contents = repeatElement("ICE", count: 1000000)
        let arrayDataProvider = ArrayDataProvider(rows: contents)
        let anyArrayDataProvider = AnyCollectionDataProvider(arrayDataProvider)
        
        //When
        measure {
            (0..<10000).forEach({ (_) in
                _ = anyArrayDataProvider.object(at: IndexPath(item: 0, section: 0))
            })
            
        }
    }
    
    func testPerformanceOfObjectAtIndexBAseline() {
        //Given
        let contents = repeatElement("ICE", count: 1000000)
        let arrayDataProvider = ArrayDataProvider(rows: contents)
        
        //When
        measure {
            (0..<10000).forEach({ (_) in
                _ = arrayDataProvider.object(at: IndexPath(item: 0, section: 0))
            })
        }
    }

}
