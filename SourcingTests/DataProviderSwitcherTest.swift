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

import XCTest
import Sourcing

enum MockState {
    case state1
    case state2
}

class DataProviderSwitcherTest: XCTestCase {
    
    func testInit() {
        //When
        let arrayDataProvider = ArrayDataProvider<String>(rows: [])
        let dataProviderSwitcher = DataProviderSwitcher(initialState: MockState.state1, resolve: { _ in return AnyDataProvider(arrayDataProvider)
        })
        
        //Then
        XCTAssertEqual(dataProviderSwitcher.state, .state1)
    }
    
    func testWhenStateChanges() {
        //Given
        var didCallDataProviderChanges = false
        let arrayDataProvider = ArrayDataProvider<String>(rows: [])
        let dataProviderSwitcher = DataProviderSwitcher(initialState: MockState.state1, resolve: { _ in return AnyDataProvider(arrayDataProvider)
        })
        dataProviderSwitcher.whenDataProviderChanged = { _ in
            didCallDataProviderChanges = true
        }

        //When
        dataProviderSwitcher.state = .state2
        
        //Then
        XCTAssertEqual(dataProviderSwitcher.state, .state2)
        XCTAssert(didCallDataProviderChanges)
    }
    
    func testObjectAtIndex() {
        //Given
        let expectedObjectAtIndex = "Test"
        let arrayDataProvider = ArrayDataProvider<String>(rows: [expectedObjectAtIndex])
        let dataProviderSwitcher = DataProviderSwitcher(initialState: MockState.state1, resolve: { _ in return AnyDataProvider(arrayDataProvider)
        })
        
        //When
        let objectAtIndex = dataProviderSwitcher.object(at: IndexPath(row: 0, section: 0))
        
        //Then
        XCTAssertEqual(expectedObjectAtIndex, objectAtIndex)
    }
    
    func testNumberOfSections() {
        //Given
        let arrayDataProvider = ArrayDataProvider<String>(sections: [[], []])
        let dataProviderSwitcher = DataProviderSwitcher(initialState: MockState.state1, resolve: { _ in return AnyDataProvider(arrayDataProvider)
        })
        
        //When
        let numbersOfSection = dataProviderSwitcher.numberOfSections()
        
        //Then
        XCTAssertEqual(numbersOfSection, 2)
    }
    
    func testNumberOfItemsInSection() {
        //Given
        let arrayDataProvider = ArrayDataProvider<String>(sections: [[], [""]])
        let dataProviderSwitcher = DataProviderSwitcher(initialState: MockState.state1, resolve: { _ in return AnyDataProvider(arrayDataProvider)
        })
        
        //When
        let numbersOfitems = dataProviderSwitcher.numberOfItems(inSection: 1)
        
        //Then
        XCTAssertEqual(numbersOfitems, 1)
    }
}
