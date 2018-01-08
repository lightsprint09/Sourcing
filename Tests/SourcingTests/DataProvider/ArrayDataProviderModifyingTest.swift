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

class ArrayDataProviderModifyingTest: XCTestCase {
    
    var arrayDataModifier: ArrayDataProviderModifier<Int>!
    var dataProvider: ArrayDataProvider<Int>!
    
    override func setUp() {
        super.setUp()
        dataProvider = ArrayDataProvider(sections: [[1, 2], [3, 4]])
        arrayDataModifier = ArrayDataProviderModifier(dataProvider: dataProvider)
    }
    
    func testCanMoveItemFromTo() {
        //When
        arrayDataModifier.canMoveItems = true
        
        //Then
        XCTAssert(arrayDataModifier.canMoveItem(at: IndexPath(item: 0, section: 0)))
    }
    
    func testMoveItemFromTo() {
        //Given
        var didNotifyTableView = false
        var change: DataProviderChange?
        _ = dataProvider.observable.addObserver(observer: { changes in
            didNotifyTableView = true
            change = changes
            
        })
        let sourceIndexPath = IndexPath(item: 0, section: 0)
        let destinationIndexPath = IndexPath(item: 1, section: 0)
        
        //When
        arrayDataModifier.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, updateView: false)
        
        //Then
        let destinationObject = dataProvider.object(at: destinationIndexPath)
        XCTAssertEqual(destinationObject, 1)
        XCTAssert(didNotifyTableView)
        if case .triggeredByUserInteraction? = change {
            
        } else {
            XCTFail("Must be triggeredByUserInteraction")
        }
    }
    
    func testCanDelteItems() {
        
        //When
        arrayDataModifier.canDeleteItems = true
        
        //Then
        XCTAssert(arrayDataModifier.canDeleteItem(at: IndexPath(item: 0, section: 0)))
    }
    
    func testDelteItemAtIndexPath() {
        //Given
        var didNotifyTableView = false
        _ = dataProvider.observable.addObserver(observer: { _ in didNotifyTableView = true })
        let deleteIndexPath = IndexPath(item: 0, section: 0)
        
        //When
        arrayDataModifier.deleteItem(at: deleteIndexPath)
        
        //Then
        let destinationObject = dataProvider.object(at: deleteIndexPath)
        XCTAssertEqual(destinationObject, 2)
        XCTAssert(didNotifyTableView)
    }
}
