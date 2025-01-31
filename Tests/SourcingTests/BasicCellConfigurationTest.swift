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
import UIKit
import Sourcing

@MainActor
class ReusableViewConfigurationTest: XCTestCase {
    

    
    func testCellConfigurationInit() {
        //Given
        var configuration: CellConfiguration<UITableViewCellMock<Int>>!
        let identifier = "reuseIdentifier"
        let additionalConfiguration: @MainActor (UITableViewCellMock<Int>, IndexPath, Int) -> Void = { view, indexPath, object in }

        //When
        configuration = CellConfiguration(reuseIdentifier: identifier, additionalConfiguration: additionalConfiguration)
        
        //Then
        XCTAssertEqual(identifier, configuration.reuseIdentifier(for: 0))
    }
    
    func testCellConfigurationInitWithCellIdentifierProviding() {
        //Given
        var configuration: CellConfiguration<UITableViewCellMock<Int>>!
        let identifier = "reuseIdentifier"
        let additionalConfiguration: @MainActor (UITableViewCellMock<Int>, IndexPath, Int) -> Void = { view, indexPath, object in }

        //When
        configuration = CellConfiguration(additionalConfiguration: additionalConfiguration)
        
        //Then
        XCTAssertEqual(UITableViewCellMock<Int>.reuseIdentifier, configuration.reuseIdentifier(for: 0))
    }
    
    func testConfigureCell() {
        //Given
        var configuration: CellConfiguration<UITableViewCellMock<Int>>!
        let identifier = "reuseIdentifier"
        var didCallAdditionalConfigurtion = false
        let additionalConfiguration: @MainActor (UITableViewCellMock<Int>, IndexPath, Int) -> Void = { view, indexPath, object in
            didCallAdditionalConfigurtion = true
        }
        configuration = CellConfiguration(additionalConfiguration: additionalConfiguration)
        let cell = UITableViewCellMock<Int>()
        
        //When
        configuration.configure(cell, at: IndexPath(row: 0, section: 0), with: 100)
        
        //Then
        XCTAssertTrue(didCallAdditionalConfigurtion)
        XCTAssertEqual(cell.configurationCount, 1)
        XCTAssertEqual(cell.configuredObject, 100)
    }
    
    class BasicCell: ReuseIdentifierProviding {
        static let reuseIdentifier = "reuseIdentifier"
    }
    
    func testBasicCanConfigureInit() {
        //Given
        let configuration = ReusableViewConfiguration<BasicCell, String>(configuration: { _, _, _ in })
        
        //Then
        XCTAssertEqual(configuration.reuseIdentifier(for: ""), "reuseIdentifier")
    }

}
