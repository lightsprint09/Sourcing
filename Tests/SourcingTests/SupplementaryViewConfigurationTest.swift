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
import UIKit
import Sourcing

extension SupplementaryViewMock: ReuseIdentifierProviding { }

class SupplementaryViewConfigurationTest: XCTestCase {
    
    let nib = UINib(data: Data(), bundle: nil)
    let identifier = "reuseIdentifier"
    let supplementaryKind = "supplementaryKind"
    var supplemenaryViewConfiguration: SupplementaryViewConfiguration<SupplementaryViewMock>!
    
    func testCellConfigurationInit() {
        //Given
        let configuration = { (cell: SupplementaryViewMock, indexPath: IndexPath, object: Any) in }
        
        //When
        supplemenaryViewConfiguration = SupplementaryViewConfiguration(elementKind: supplementaryKind,
                                                                       reuseIdentifier: identifier, nib: nib, configuration: configuration)
        
        //Then
        XCTAssertEqual(supplemenaryViewConfiguration.reuseIdentifier, identifier)
        XCTAssertNotNil(supplemenaryViewConfiguration.nib)
    }
    
    func testCellConfigurationInitWithCellIdentifierProviding() {
        //Given
        let configuration = { (cell: SupplementaryViewMock, indexPath: IndexPath, object: Any) in }

        //When
        supplemenaryViewConfiguration = SupplementaryViewConfiguration(elementKind: supplementaryKind,
                                                                       nib: nib, configuration: configuration)

        //Then
        XCTAssertEqual(supplemenaryViewConfiguration.reuseIdentifier, "SupplementaryViewMock")
        XCTAssertNotNil(supplemenaryViewConfiguration.nib)
    }

    func testConfigureCell() {
        //Given
        var didCallConfigurtion = false
        let configuration = { (cell: SupplementaryViewMock, indexPath: IndexPath, object: Any) in
            didCallConfigurtion = true
        }
        supplemenaryViewConfiguration = SupplementaryViewConfiguration(elementKind: supplementaryKind,
                                                                       reuseIdentifier: identifier, nib: nib, configuration: configuration)
        let supplementaryView = SupplementaryViewMock()

        //When
        _ = supplemenaryViewConfiguration.configure(supplementaryView, at: IndexPath(row: 0, section: 0), with: 10)

        //Then
        XCTAssertTrue(didCallConfigurtion)
    }

    func testCanConfigureCell() {
        //Given
        supplemenaryViewConfiguration = SupplementaryViewConfiguration(elementKind: supplementaryKind,
                                                                       reuseIdentifier: identifier, nib: nib)
        
        //When
        let canConfigure = supplemenaryViewConfiguration.canConfigureView(with: 1, ofKind: supplementaryKind)

        //Then
        XCTAssert(canConfigure)
    }
    
    func testStatCanConfigurateStatic() {
        //Given
        let supplemenaryViewConfiguration = BasicSupplementaryViewConfiguration<SupplementaryViewMock, String>(elementKind: supplementaryKind,
                                                                       reuseIdentifier: identifier, nib: nib)
        
        //When
        let canConfigure = supplemenaryViewConfiguration.canConfigureView(with: 1, ofKind: supplementaryKind)
        
        //Then
        XCTAssertFalse(canConfigure)
    }
    
}
